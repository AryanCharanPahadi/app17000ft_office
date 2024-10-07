import 'dart:convert';
import 'package:app17000ft_new/components/custom_labeltext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;
import '../../components/custom_appBar.dart';
import '../../components/custom_confirmation.dart';
import '../../components/custom_dropdown.dart';
import '../../components/custom_sizedBox.dart';
import '../../helper/database_helper.dart';
import '../../tourDetails/tour_controller.dart';
import '../school_enrolment/school_enrolment.dart';
import '../school_facilities_&_mapping_form/SchoolFacilitiesForm.dart';
import '../school_facilities_&_mapping_form/school_facilities_modals.dart';
import '../school_staff_vec_form/school_vec_from.dart';
import '../school_staff_vec_form/school_vec_modals.dart';
import 'edit controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // For checking network status
import 'package:dropdown_search/dropdown_search.dart';
import '../../helper/responsive_helper.dart';
import '../school_enrolment/school_enrolment_model.dart';
class EditFormPage extends StatefulWidget {
  const EditFormPage({super.key});
  @override
  State<EditFormPage> createState() => _EditFormPageState();
}
class _EditFormPageState extends State<EditFormPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> splitSchoolLists = [];
  final SqfliteDatabaseHelper dbHelper = SqfliteDatabaseHelper();
  String selectedFormLabel = ''; // Empty string for the default state
  Map<String, dynamic> formData = {}; // Store fetched form data
  String selectedSchool = '';
  late EditController editController;
  List<String> tourIds = []; // List to store available tour IDs
  bool isOfflineMode = false; // Track if the app is in offline mode
  Future<bool> _isConnected() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  void initState() {
    super.initState();
    editController = Get.put(EditController());
    _checkConnectivityAndShowPopup(); // Check connectivity and show pop-up if online
    setState(() {
      selectedFormLabel = '';
    });
  }

  Future<void> _checkConnectivityAndShowPopup() async {
    bool isConnected = await _isConnected();
    if (isConnected) {
      _showOnlinePopup(); // Show pop-up only if online
    } else {
      setState(() {
        isOfflineMode = true;
      });
      _loadTourIdsFromLocal(); // Load only the stored Tour IDs in offline mode
    }
  }

  void _showOnlinePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Confirmation(
          desc:
          'Select TourId and School. For edit the data in the offline mode!',
          title: 'Notification',
          iconname: Icons.info,
          yes: 'OK',
          onPressed: () {},
        );
      },
    );
  }

  Future<void> fetchData(String tourId, [String? school]) async {
    bool isConnected = await _isConnected();
    if (isConnected) {
      // Fetch data from the API when online
      final url =
          'https://mis.17000ft.org/apis/fast_apis/pre-fill-data.php?id=$tourId';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data != null && data.isNotEmpty) {
          List<String> allSchools = [];

          // Loop through each school in the response
          for (var schoolName in data.keys) {
            allSchools.add(schoolName);
            var schoolData = data[schoolName];

            if (schoolData != null) {
              // Save each school's form data to the local DB
              await saveFormDataToLocalDB(tourId, schoolName, schoolData);
            }
          }

          setState(() {
            splitSchoolLists =
                allSchools; // Update splitSchoolLists with all fetched schools
            formData =
            {}; // Clear formData as it's now irrelevant since we're showing all
          });

          // Save the selected Tour ID locally for offline mode
          await saveTourIdToLocal(tourId);

          // If a specific school is selected, fetch its data from the local DB
          if (school != null) {
            formData = await getFormDataFromLocalDB(tourId, school);
          }
        }
      }
    } else {
      // Offline mode: Load the selected tour ID from local storage
      List<String> allSchools = await dbHelper.getSchoolsForTourId(tourId);
      if (school != null) {
        formData = await getFormDataFromLocalDB(tourId, school);
      }

      setState(() {
        splitSchoolLists = allSchools;
        selectedSchool = school ?? '';
      });
    }
  }

  Future<void> saveFormDataToLocalDB(String tourId, String school,
      Map<String, dynamic> formData) async {
    try {
      await dbHelper.insertFormData(tourId, school, formData);
    } catch (e) {
      print("Error saving data to SQLite: $e");
    }
  }

  Future<Map<String, dynamic>> getFormDataFromLocalDB(String tourId,
      String school) async {
    return await SqfliteDatabaseHelper.instance.getFormData(tourId, school);
  }

  // Save the selected Tour ID to the local database (or shared preferences)
  Future<void> saveTourIdToLocal(String tourId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Retrieve existing IDs
    List<String> existingIds = prefs.getStringList('selectedTourIds') ?? [];
    // Add the new ID if not already present
    if (!existingIds.contains(tourId)) {
      existingIds.add(tourId);
      await prefs.setStringList('selectedTourIds', existingIds);
    }
  }

  // Load all Tour IDs from local database (or shared preferences) in offline mode
  Future<void> _loadTourIdsFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? storedTourIds = prefs.getStringList('selectedTourIds');

    if (storedTourIds != null) {
      setState(() {
        tourIds = storedTourIds; // Show all stored Tour IDs
      });
    } else {
      setState(() {
        tourIds = []; // If no Tour ID is stored, keep the list empty
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await showDialog(
          context: context,
          builder: (_) =>
              Confirmation(
                iconname: Icons.warning,
                title: 'Exit Confirmation',
                desc: 'Are you sure you want to leave this screen?',
                yes: 'Yes',
                no: 'No',
                onPressed: () {
                  setState(() {
                    formData = {}; // Reset form data
                    selectedSchool = '';
                    selectedFormLabel = '';
                    editController.setSchool(null);
                    editController.setTour(null);
                  });
                  Navigator.of(context).pop(true);
                },
              ),
        );
        return shouldExit;
      },
      child: Scaffold(
        appBar: const CustomAppbar(
          title: 'Edit Form',
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              children: [
                GetBuilder<TourController>(
                  init: TourController(),
                  builder: (tourController) {
                    if (!isOfflineMode) {
                      tourController
                          .fetchTourDetails(); // Fetch online tour list if online
                    }
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          LabelText(label: 'Select Tour ID'),
                          CustomSizedBox(value: 20, side: 'height'),
                          CustomDropdownFormField(
                            focusNode: editController.tourIdFocusNode,
                            options: isOfflineMode
                                ? tourIds // Show all stored Tour IDs in offline mode
                                : tourController.getLocalTourList
                                .map((e) => e.tourId!)
                                .toList(),
                            selectedOption: editController.tourValue,
                            onChanged: (value) {
                              if (value != null) {
                                fetchData(value);
                                setState(() {
                                  editController.setTour(value);
                                });
                              }
                            },
                            labelText: "Select Tour ID",
                          ),
                          CustomSizedBox(value: 20, side: 'height'),
                          LabelText(label: 'School', astrick: true),
                          CustomSizedBox(value: 20, side: 'height'),
                          DropdownSearch<String>(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please Select School";
                              }
                              return null;
                            },
                            popupProps: PopupProps.menu(
                              showSelectedItems: true,
                              showSearchBox: true,
                              scrollbarProps: ScrollbarProps(
                                thickness: 2,
                                radius: Radius.circular(10),
                                thumbColor: Colors.black87,
                                thumbVisibility: true,
                              ),
                              searchFieldProps: TextFieldProps(
                                decoration: InputDecoration(
                                  hintText: 'Search School',
                                  filled: true,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              ),
                            ),
                            items: splitSchoolLists,
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Select School",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedSchool = value;
                                  editController.setSchool(value);
                                  fetchData(editController.tourValue!,
                                      value); // Pass the selected school to fetchData
                                });
                              }
                            },
                            selectedItem: editController.schoolValue,
                          ),
                          CustomSizedBox(value: 20, side: 'height'),
                          LabelText(label: 'Select Form'),
                          CustomSizedBox(value: 20, side: 'height'),
                          DropdownButtonFormField<String>(
                            value: selectedFormLabel.isEmpty
                                ? null
                                : selectedFormLabel,
                            items: ['enrollment', 'vec', 'facilities']
                                .map((label) =>
                                DropdownMenuItem(
                                  value: label,
                                  child: Text(label.toUpperCase()),
                                ))
                                .toList(),
                            decoration: InputDecoration(
                              labelText: 'Select Form',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectedFormLabel = value ?? '';
                                // Clear form data when changing form
                                formData = {};
                                // Fetch data relevant to the selected form
                                if (selectedSchool.isNotEmpty &&
                                    editController.tourValue != null) {
                                  fetchData(editController.tourValue!,
                                      selectedSchool);
                                }
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a form';
                              }
                              return null;
                            },
                          ),
                          CustomSizedBox(value: 30, side: 'height'),
                        ],
                      ),
                    );
                  },
                ),
                // Show data based on the selected form
                if (formData.isNotEmpty)
                  Card(
                    elevation: 8,
                    margin: EdgeInsets.all(10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(
                            'Selected School: $selectedSchool',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          // Display only relevant data based on selected form
                          ...formData.entries.map((entry) {
                            switch (selectedFormLabel) {
                              case 'enrollment':
                                if (entry.key == 'enrollment') {
                                  final enrollmentFetch =
                                  formData['enrollment'];

                                  if (enrollmentFetch is Map) {
                                    List<Widget> classRows = [];

                                    // Add headers row
                                    classRows.add(
                                      Row(
                                        children: const [
                                          Expanded(
                                              child: Text('Class',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold))),
                                          Expanded(
                                              child: Text('Boys',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold))),
                                          Expanded(
                                              child: Text('Girls',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                      FontWeight.bold))),
                                        ],
                                      ),
                                    );

                                    // Adding class data rows
                                    enrollmentFetch.forEach((className, data) {
                                      if (data is Map &&
                                          data.containsKey('boys') &&
                                          data.containsKey('girls')) {
                                        final boys =
                                            int.tryParse(data['boys'] ?? '0') ??
                                                0;
                                        final girls = int.tryParse(
                                            data['girls'] ?? '0') ??
                                            0;

                                        classRows.add(
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Text(className,
                                                      style: const TextStyle(
                                                          fontSize: 14))),
                                              Expanded(
                                                  child: Text('$boys',
                                                      style: const TextStyle(
                                                          fontSize: 14))),
                                              Expanded(
                                                  child: Text('$girls',
                                                      style: const TextStyle(
                                                          fontSize: 14))),
                                            ],
                                          ),
                                        );
                                      }
                                    });

                                    // Display the enrollment data in a card with headers
                                    return Card(
                                      elevation: 4,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                                children:
                                                classRows),
                                            // Displaying the rows with class data
                                            SizedBox(height: 16),
                                            ElevatedButton(
                                              onPressed: () {
                                                final enrolmentDataMap = <
                                                    String,
                                                    Map<String, String>>{};

                                                enrollmentFetch.forEach((
                                                    className, data) {
                                                  if (data is Map &&
                                                      data.containsKey(
                                                          'boys') &&
                                                      data.containsKey(
                                                          'girls')) {
                                                    enrolmentDataMap[className] =
                                                    {
                                                      'boys': data['boys'] ??
                                                          '0',
                                                      'girls': data['girls'] ??
                                                          '0',
                                                    };
                                                  }
                                                });

                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        SchoolEnrollmentForm(
                                                          userid: 'userid',
                                                          existingRecord: EnrolmentCollectionModel(
                                                            enrolmentData: jsonEncode(
                                                                enrolmentDataMap),
                                                            remarks: enrollmentFetch['remarks'] ??
                                                                '',
                                                            tourId: editController
                                                                .tourValue,
                                                            // Pass the selected Tour ID here
                                                            school: editController
                                                                .schoolValue,
                                                            // Pass the selected school here
                                                            submittedBy: editController
                                                                .empId, // Pass created_by here


                                                          ),
                                                          tourId: editController
                                                              .tourValue ??
                                                              'Not Provided',
                                                          // Pass the selected Tour ID here
                                                          school: editController
                                                              .schoolValue ??
                                                              'Not provided', // Pass the selected school here


                                                        ),
                                                  ),
                                                );
                                              },
                                              child: const Text(
                                                  'Edit Enrollment Data'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Text(
                                        'Enrollment data format is incorrect');
                                  }
                                }
                                break;
                              case 'vec':
                                if (entry.key == 'vec') {
                                  // Check if the 'vec' entry is a list and contains data
                                  if (entry.value is List &&
                                      (entry.value as List).isNotEmpty) {
                                    List<dynamic> vecData = entry.value;
                                    return Column(
                                      children: [
                                        // Display data cards
                                        ...vecData.map((vecEntry) {
                                          return Card(
                                            elevation: 8,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'School: ${vecEntry['school'] ??
                                                          'N/A'}',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  const Divider(),
                                                  Text(
                                                      'State: ${vecEntry['state'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'District: ${vecEntry['district'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Block: ${vecEntry['block'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Tour ID: ${vecEntry['tourId'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'UDISE Value: ${vecEntry['udiseValue'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Correct UDISE: ${vecEntry['correctUdise'] ??
                                                          'N/A'}'),
                                                  const SizedBox(height: 8),
                                                  Text('Head Information',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  Text(
                                                      'Name: ${vecEntry['headName'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Gender: ${vecEntry['headGender'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Mobile: ${vecEntry['headMobile'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Email: ${vecEntry['headEmail'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Designation: ${vecEntry['headDesignation'] ??
                                                          'N/A'}'),
                                                  const SizedBox(height: 8),
                                                  Text('Staff Information',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  Text(
                                                      'Total Teaching Staff: ${vecEntry['totalTeachingStaff'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Total Non-Teaching Staff: ${vecEntry['totalNonTeachingStaff'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Total Staff: ${vecEntry['totalStaff'] ??
                                                          'N/A'}'),
                                                  const SizedBox(height: 8),
                                                  Text('VEC Information',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  Text(
                                                      'SMC/VEC Name: ${vecEntry['SmcVecName'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Gender: ${vecEntry['genderVec'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Mobile: ${vecEntry['vecMobile'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Email: ${vecEntry['vecEmail'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Qualification: ${vecEntry['vecQualification'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Total Members: ${vecEntry['vecTotal'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Meeting Duration: ${vecEntry['meetingDuration'] ??
                                                          'N/A'}'),
                                                  const SizedBox(height: 8),
                                                  Text('Other Information',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  Text(
                                                      'Other Qualification: ${vecEntry['otherQual'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Created By: ${vecEntry['createdBy'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Created At: ${vecEntry['createdAt'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Submitted At: ${vecEntry['submittedAt'] ??
                                                          'N/A'}'),
                                                  const SizedBox(height: 8),

                                                  // Display the "Edit" button if data exists
                                                  Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        // Navigate to the SchoolFacilitiesForm and pass the selected facility record
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                SchoolStaffVecForm(
                                                                  userid: 'userid',

                                                                  existingRecord:
                                                                  SchoolStaffVecRecords(
                                                                    headName: vecEntry[
                                                                    'headName'],
                                                                    tourId: editController
                                                                        .tourValue,
                                                                    // Pass the selected Tour ID here
                                                                    school: editController
                                                                        .schoolValue,
                                                                    // Pass the selected school here
                                                                    createdBy: editController
                                                                        .empId,
                                                                    // Pass created_by here
                                                                    headGender:
                                                                    vecEntry[
                                                                    'headGender'],
                                                                    udiseValue:
                                                                    vecEntry[
                                                                    'udiseValue'],
                                                                    correctUdise:
                                                                    vecEntry[
                                                                    'correctUdise'],
                                                                    headMobile:
                                                                    vecEntry[
                                                                    'headMobile'],
                                                                    headEmail: vecEntry[
                                                                    'headEmail'],
                                                                    headDesignation:
                                                                    vecEntry[
                                                                    'headDesignation'],
                                                                    totalTeachingStaff:
                                                                    vecEntry[
                                                                    'totalTeachingStaff'],
                                                                    totalNonTeachingStaff:
                                                                    vecEntry[
                                                                    'totalNonTeachingStaff'],
                                                                    totalStaff:
                                                                    vecEntry[
                                                                    'totalStaff'],
                                                                    SmcVecName:
                                                                    vecEntry[
                                                                    'SmcVecName'],
                                                                    genderVec: vecEntry[
                                                                    'genderVec'],
                                                                    vecMobile: vecEntry[
                                                                    'vecMobile'],
                                                                    vecEmail: vecEntry[
                                                                    'vecEmail'],
                                                                    vecQualification:
                                                                    vecEntry[
                                                                    'vecQualification'],
                                                                    vecTotal: vecEntry[
                                                                    'vecTotal'],
                                                                    meetingDuration:
                                                                    vecEntry[
                                                                    'meetingDuration'],

                                                                    createdAt: vecEntry[
                                                                    'createdAt'],
                                                                    other: vecEntry[
                                                                    'other'],
                                                                    otherQual: vecEntry[
                                                                    'otherQual'],
                                                                  ),
                                                                  tourId: editController
                                                                      .tourValue ??
                                                                      'Not Provided',
                                                                  // Pass the selected Tour ID here
                                                                  school: editController
                                                                      .schoolValue ??
                                                                      'Not provided', // Pass the selected school here
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text(
                                                          'Edit VEC Data'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        const Text('No VEC data available'),

                                        // Display the "Add Data" button if no data exists
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Navigate to the form for adding new VEC data
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SchoolStaffVecForm(),
                                              ),
                                            );
                                          },
                                          child: const Text('Add New VEC Data'),
                                        ),
                                      ],
                                    );
                                  }
                                }
                                break;

                              case 'facilities':
                                if (entry.key == 'facilities') {
                                  // Check if the 'facilities' entry is a list and contains data
                                  if (entry.value is List &&
                                      (entry.value as List).isNotEmpty) {
                                    List<dynamic> facilitiesData = entry.value;
                                    return Column(
                                      children: [
                                        // Display data cards
                                        ...facilitiesData.map((facilityEntry) {
                                          return Card(
                                            elevation: 8,
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      'School: ${facilityEntry['school'] ??
                                                          'N/A'}',
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  const Divider(),
                                                  Text(
                                                      'State: ${facilityEntry['state'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'District: ${facilityEntry['district'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Block: ${facilityEntry['block'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Tour ID: ${facilityEntry['tourId'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'UDISE Value: ${facilityEntry['udiseValue'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Correct UDISE: ${facilityEntry['correctUdise'] ??
                                                          'N/A'}'),
                                                  const SizedBox(height: 8),
                                                  Text('Facilities Information',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  Text(
                                                      'Residential: ${facilityEntry['residentialValue'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Electricity: ${facilityEntry['electricityValue'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Internet: ${facilityEntry['internetValue'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Projector: ${facilityEntry['projectorValue'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Smart Class: ${facilityEntry['smartClassValue'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Functional Classrooms: ${facilityEntry['numFunctionalClass'] ??
                                                          'N/A'}'),
                                                  const SizedBox(height: 8),
                                                  Text('Playground',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  Text(
                                                      'Playground Available: ${facilityEntry['playgroundValue'] ??
                                                          'N/A'}'),
                                                  const SizedBox(height: 8),
                                                  Text('Library',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  Text(
                                                      'Library Available: ${facilityEntry['libValue'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Library Location: ${facilityEntry['libLocation'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Librarian Name: ${facilityEntry['librarianName'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Librarian Trained: ${facilityEntry['librarianTraining'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Library Register Available: ${facilityEntry['libRegisterValue'] ??
                                                          'N/A'}'),
                                                  const SizedBox(height: 8),
                                                  Text('Images',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  Text(
                                                      'Playground Images: ${facilityEntry['playImg'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Library Register Images: ${facilityEntry['imgRegister'] ??
                                                          'N/A'}'),
                                                  const SizedBox(height: 8),
                                                  Text('Other Information',
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight.bold)),
                                                  Text(
                                                      'Created By: ${facilityEntry['created_by'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Created At: ${facilityEntry['created_at'] ??
                                                          'N/A'}'),
                                                  Text(
                                                      'Submitted At: ${facilityEntry['submitted_at'] ??
                                                          'N/A'}'),
                                                  const SizedBox(height: 8),

                                                  // Display the "Edit" button if data exists
                                                  Align(
                                                    alignment:
                                                    Alignment.centerLeft,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        // Navigate to the SchoolFacilitiesForm and pass the selected facility record
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (
                                                                context) =>
                                                                SchoolFacilitiesForm(
                                                                  userid: 'userid',
                                                                  existingRecord:
                                                                  SchoolFacilitiesRecords(
                                                                    residentialValue:
                                                                    facilityEntry[
                                                                    'residentialValue'],
                                                                    tourId: editController
                                                                        .tourValue,
                                                                    // Pass the selected Tour ID here
                                                                    school: editController
                                                                        .schoolValue,
                                                                    // Pass the selected school here
                                                                    electricityValue:
                                                                    facilityEntry[
                                                                    'electricityValue'],
                                                                    internetValue:
                                                                    facilityEntry[
                                                                    'internetValue'],
                                                                    udiseCode:
                                                                    facilityEntry[
                                                                    'udiseValue'],
                                                                    correctUdise:
                                                                    facilityEntry[
                                                                    'correctUdise'],
                                                                    // school: facilityEntry['school'],
                                                                    projectorValue:
                                                                    facilityEntry[
                                                                    'projectorValue'],
                                                                    smartClassValue:
                                                                    facilityEntry[
                                                                    'smartClassValue'],
                                                                    numFunctionalClass:
                                                                    facilityEntry[
                                                                    'numFunctionalClass'],
                                                                    playgroundValue:
                                                                    facilityEntry[
                                                                    'playgroundValue'],
                                                                    libValue:
                                                                    facilityEntry[
                                                                    'libValue'],
                                                                    libLocation:
                                                                    facilityEntry[
                                                                    'libLocation'],
                                                                    librarianName:
                                                                    facilityEntry[
                                                                    'librarianName'],
                                                                    librarianTraining:
                                                                    facilityEntry[
                                                                    'librarianTraining'],
                                                                    libRegisterValue:
                                                                    facilityEntry[
                                                                    'libRegisterValue'],
                                                                    created_by: editController
                                                                        .empId,
                                                                    // Pass empId here as created_by

                                                                    created_at:
                                                                    facilityEntry[
                                                                    'created_at'],
                                                                  ),
                                                                  tourId: editController
                                                                      .tourValue ??
                                                                      'Not Provided',
                                                                  // Pass the selected Tour ID here
                                                                  school: editController
                                                                      .schoolValue ??
                                                                      'Not provided', // Pass the selected school here
                                                                ),
                                                          ),
                                                        );
                                                      },
                                                      child: const Text(
                                                          'Edit Facilities Data'),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      ],
                                    );
                                  } else {
                                    return Column(
                                      children: [
                                        const Text(
                                            'No Facilities data available'),

                                        // Display the "Add Data" button if no data exists
                                        const SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: () {
                                            // Navigate to the form for adding new facilities data
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    SchoolFacilitiesForm(),
                                              ),
                                            );
                                          },
                                          child: const Text(
                                              'Add New Facilities Data'),
                                        ),
                                      ],
                                    );
                                  }
                                }
                                break;

                              default:
                                return SizedBox.shrink(); // No data to show
                            }
                            return SizedBox.shrink(); // No data to show
                          }).toList(),
                        ],
                      ),
                    ),
                  )
                else
                  Text(''),
              ],
            ),
          ),
        ),
      ),
    );
  }

}