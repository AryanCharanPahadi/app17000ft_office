import 'dart:convert';
import 'package:app17000ft_new/components/custom_labeltext.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../components/custom_appBar.dart';
import '../../components/custom_confirmation.dart';
import '../../components/custom_dropdown.dart';
import '../../components/custom_sizedBox.dart';
import '../../helper/database_helper.dart';
import '../../tourDetails/tour_controller.dart';
import '../school_enrolment/school_enrolment.dart';
import '../school_enrolment/school_enrolment_model.dart';
import '../school_facilities_&_mapping_form/SchoolFacilitiesForm.dart';
import '../school_facilities_&_mapping_form/school_facilities_modals.dart';
import '../school_staff_vec_form/school_vec_from.dart';
import '../school_staff_vec_form/school_vec_modals.dart';
import 'edit controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // For checking network status
import 'package:dropdown_search/dropdown_search.dart';
import '../../helper/responsive_helper.dart';

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
  // Instance of EditController
  late EditController editController;
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
    }); // Set to empty so that "Select Form" shows up
  }

  Future<void> _checkConnectivityAndShowPopup() async {
    bool isConnected = await _isConnected();
    if (isConnected) {
      _showOnlinePopup(); // Show pop-up only if online
    }
  }

  void _showOnlinePopup() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification'),
          content: const Text('Select TourId and School. For edit the data in the offline mode!'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> fetchData(String tourId, String school) async {
    bool isConnected = await _isConnected();

    if (isConnected) {
      // Fetch data from the API when online
      final url =
          'https://mis.17000ft.org/apis/fast_apis/pre-fill-data.php?id=$tourId';
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Data fetched from API: ${data[school]}");

        // Ensure that data is not null before storing
        if (data[school] != null) {
          setState(() {
            formData = data[school];
          });

          // Store fetched data in SQLite for offline access
          await saveFormDataToLocalDB(tourId, school, formData);
        } else {
          print("No data found for the given school in API response.");
        }
      } else {
        print("Error fetching data from API: ${response.statusCode}");
      }
    } else {
      print("Device is offline. Fetching data from SQLite...");
      Map<String, dynamic> offlineData =
      await getFormDataFromLocalDB(tourId, school);
      setState(() {
        formData = offlineData.isNotEmpty ? offlineData : {};
      });
      print("Fetched data from SQLite: $offlineData");
    }
  }

  Future<void> saveFormDataToLocalDB(
      String tourId, String school, Map<String, dynamic> formData) async {
    try {
      print(
          "Saving data to local SQLite database for tourId: $tourId, school: $school");
      await dbHelper.insertFormData(tourId, school, formData);
      print("Data saved successfully.");
    } catch (e) {
      print("Error saving data to SQLite: $e");
    }
  }

  Future<Map<String, dynamic>> getFormDataFromLocalDB(
      String tourId, String school) async {
    // Use the database helper to get the data from SQLite
    return await SqfliteDatabaseHelper.instance.getFormData(tourId, school);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return WillPopScope(
      onWillPop: () async {
        bool shouldExit = await showDialog(
          context: context,
          builder: (_) => Confirmation(
            iconname: Icons.warning, // Provide the appropriate icon here
            title: 'Exit Confirmation',
            desc: 'Are you sure you want to leave this screen?',
            yes: 'Yes',
            no: 'No',
            onPressed: () {
              setState(() {
                formData = {}; // Reset form data
                selectedSchool = ''; // Reset school selection
                selectedFormLabel = ''; // Reset form label to empty or null
                editController.setSchool(null); // Reset school
                editController.setTour(null); // Reset tour
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
                    tourController
                        .fetchTourDetails(); // Fetch tour details initially
                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          LabelText(label: 'Select Tour ID'),
                          CustomSizedBox(value: 20, side: 'height'),
                          CustomDropdownFormField(
                            focusNode: editController.tourIdFocusNode,
                            options: tourController.getLocalTourList
                                .map((e) =>
                            e.tourId!) // Ensure tourId is non-nullable
                                .toList(),
                            selectedOption: editController.tourValue,
                            onChanged: (value) {
                              // Safely handle the school list splitting by commas
                              splitSchoolLists = tourController.getLocalTourList
                                  .where((e) => e.tourId == value)
                                  .map((e) => e.allSchool!
                                  .split(',')
                                  .map((s) => s.trim())
                                  .toList())
                                  .expand((x) => x)
                                  .toList();
                              // Single setState call for efficiency
                              setState(() {
                                editController.setSchool(null);
                                editController.setTour(value);
                              });
                            },
                            labelText: "Select Tour ID",
                          ),
                          CustomSizedBox(value: 20, side: 'height'),
                          // School Selection
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
                                thickness: 2, // Thickness of the scrollbar
                                radius: Radius.circular(
                                    10), // Rounded scrollbar corners
                                thumbColor: Colors.black87, // Correct type
                                thumbVisibility:
                                true, // Make the scrollbar visible while scrolling
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
                            items: splitSchoolLists, // List of schools
                            dropdownDecoratorProps: DropDownDecoratorProps(
                              dropdownSearchDecoration: InputDecoration(
                                labelText: "Select School",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            dropdownBuilder: (context, selectedItem) {
                              return Text(
                                selectedItem ?? "Select School",
                              );
                            },
                            onChanged: (value) {
                              if (value != null) {
                                setState(() {
                                  selectedSchool = value;
                                  editController.setSchool(value);
                                  fetchData(editController.tourValue!,
                                      value); // Ensure tourValue is non-null
                                });
                              }
                            },
                            selectedItem: editController.schoolValue,
                          ),
                          CustomSizedBox(value: 20, side: 'height'),
                          // Dropdown for form labels
                          LabelText(label: 'Select Form'),
                          CustomSizedBox(value: 20, side: 'height'),
                          DropdownButtonFormField<String>(
                            value: selectedFormLabel.isEmpty
                                ? null
                                : selectedFormLabel, // Show "Select Form" when empty
                            items: ['enrollment', 'vec', 'facilities']
                                .map((label) => DropdownMenuItem(
                              value: label,
                              child: Text(label.toUpperCase()),
                            ))
                                .toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedFormLabel =
                                    value ?? ''; // Update selected form label
                              });
                            },
                            decoration: InputDecoration(
                              labelText:
                              'Select Form', // Set placeholder as "Select Form"
                              border: OutlineInputBorder(),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please select a form"; // Add validation to ensure selection
                              }
                              return null;
                            },
                          ),
                          CustomSizedBox(value: 20, side: 'height'),
                          if (formData.isNotEmpty && selectedSchool.isNotEmpty)
                            buildFormDataWidget(selectedFormLabel),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


// Function to build widget to display form data in a single card horizontally
  Widget buildFormDataWidget(String label) {

    // Check for offline mode as well as presence of formData before trying to render the widget
    if (formData.isEmpty && selectedSchool.isNotEmpty) {
      return const Text('No data available for the selected school and form.');
    }
    switch (label) {
      case 'enrollment':
        if (formData.containsKey('enrollment')) {
          final enrollmentFetch = formData['enrollment'];

          if (enrollmentFetch is Map) {
            List<Widget> classRows = [];

            // Add headers row
            classRows.add(
              Row(
                children: const [
                  Expanded(child: Text('Class', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  Expanded(child: Text('Boys', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                  Expanded(child: Text('Girls', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
                ],
              ),
            );

            // Adding class data rows
            enrollmentFetch.forEach((className, data) {
              if (data is Map && data.containsKey('boys') && data.containsKey('girls')) {
                final boys = int.tryParse(data['boys'] ?? '0') ?? 0;
                final girls = int.tryParse(data['girls'] ?? '0') ?? 0;

                classRows.add(
                  Row(
                    children: [
                      Expanded(child: Text(className, style: const TextStyle(fontSize: 14))),
                      Expanded(child: Text('$boys', style: const TextStyle(fontSize: 14))),
                      Expanded(child: Text('$girls', style: const TextStyle(fontSize: 14))),
                    ],
                  ),
                );
              }
            });

            // Display the enrollment data in a card with headers
            return Card(
              elevation: 4,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(children: classRows), // Displaying the rows with class data
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final enrolmentDataMap = <String, Map<String, String>>{};

                        enrollmentFetch.forEach((className, data) {
                          if (data is Map && data.containsKey('boys') && data.containsKey('girls')) {
                            enrolmentDataMap[className] = {
                              'boys': data['boys'] ?? '0',
                              'girls': data['girls'] ?? '0',
                            };
                          }
                        });

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SchoolEnrollmentForm(
                              userid: 'userid',
                              existingRecord: EnrolmentCollectionModel(
                                enrolmentData: jsonEncode(enrolmentDataMap),
                                remarks: enrollmentFetch['remarks'] ?? '',
                                // tourId: enrollmentFetch['tourId'] ?? '',
                                school: enrollmentFetch['school'] ?? '',
                              ),
                            ),
                          ),
                        );
                      },
                      child: const Text('Edit Enrollment Data'),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Text('Enrollment data format is incorrect');
          }
        } else {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('No enrollment data available'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchoolEnrollmentForm(),
                        ),
                      );
                    },
                    child: const Text('Add New Enrollment Data'),
                  ),
                ],
              ),
            ),
          );
        }

      case 'vec':
        if (formData.containsKey('vec') && formData['vec'] != null && formData['vec'].isNotEmpty) {
          final vecData = formData['vec']; // Assuming vecData is a list of VEC records
          List<Widget> vecWidgets = [];

          // Build a widget for each VEC record
          vecData.forEach((vec) {
            vecWidgets.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tour Id: ${vec['tourId']}'),
                  Text('School: ${vec['school']}'),
                  // Add other facility fields as necessary...
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the SchoolFacilitiesForm and pass the selected facility record
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchoolStaffVecForm(

                            existingRecord: SchoolStaffVecRecords(
                              headName: vec['headName'],
                              tourId: vec['tourId'],
                              school: vec['school'],
                              headGender: vec['headGender'],
                              udiseValue: vec['udiseValue'],
                              correctUdise: vec['correctUdise'],
                              headMobile: vec['headMobile'],
                              headEmail: vec['headEmail'],
                              headDesignation: vec['headDesignation'],
                              totalTeachingStaff: vec['totalTeachingStaff'],
                              totalNonTeachingStaff: vec['totalNonTeachingStaff'],
                              totalStaff: vec['totalStaff'],
                              SmcVecName: vec['SmcVecName'],
                              genderVec: vec['genderVec'],
                              vecMobile: vec['vecMobile'],
                              vecEmail: vec['vecEmail'],
                              vecQualification: vec['vecQualification'],
                              vecTotal: vec['vecTotal'],
                              meetingDuration: vec['meetingDuration'],
                              createdBy: vec['createdBy'],
                              createdAt: vec['createdAt'],
                              other: vec['other'],
                              otherQual: vec['otherQual'],
                            ),

                          ),
                        ),
                      );
                    },
                    child: const Text('Edit VEC Data'),
                  ),
                ],
              ),
            );
          });

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: vecWidgets,
              ),
            ),
          );
        } else {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('No VEC data available'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the form for adding new VEC data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchoolStaffVecForm(

                          ),
                        ),
                      );
                    },
                    child: const Text('Add New VEC Data'),
                  ),
                ],
              ),
            ),
          );
        }


      case 'facilities':
        if (formData.containsKey('facilities') &&
            formData['facilities'] != null &&
            formData['facilities'].isNotEmpty) {
          final facilitiesData = formData['facilities']; // Assuming facilitiesData is a list of facility records
          List<Widget> facilityWidgets = [];

          // Build a widget for each facility record
          facilitiesData.forEach((facility) {
            facilityWidgets.add(
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Tour Id: ${facility['tourId']}'),
                  Text('School: ${facility['school']}'),
                  // Add other facility fields as necessary...
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the SchoolFacilitiesForm and pass the selected facility record
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchoolFacilitiesForm(

                            existingRecord: SchoolFacilitiesRecords(
                              residentialValue: facility['residentialValue'],
                              tourId: facility['tourId'],
                              electricityValue: facility['electricityValue'],
                              internetValue: facility['internetValue'],
                              udiseCode: facility['udiseValue'],
                              correctUdise: facility['correctUdise'],
                              school: facility['school'],
                              projectorValue: facility['projectorValue'],
                              smartClassValue: facility['smartClassValue'],
                              numFunctionalClass: facility['numFunctionalClass'],
                              playgroundValue: facility['playgroundValue'],
                              libValue: facility['libValue'],
                              libLocation: facility['libLocation'],
                              librarianName: facility['librarianName'],
                              librarianTraining: facility['librarianTraining'],
                              libRegisterValue: facility['libRegisterValue'],
                              created_by: facility['created_by'],
                              created_at: facility['created_at'],
                            ),
                          ),
                        ),
                      );
                    },
                    child: const Text('Edit Facilities Data'),
                  ),
                ],
              ),
            );
          });

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: facilityWidgets,
              ),
            ),
          );
        } else {
          return Card(
            elevation: 4,
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('No facilities data available'),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the form for adding new facilities data
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SchoolFacilitiesForm(


                          ),
                        ),
                      );
                    },
                    child: const Text('Add New Facilities Data'),
                  ),
                ],
              ),
            ),
          );
        }


      default:
        return const Text('No data available'); // Ensure a default return case
    }
  }

}
