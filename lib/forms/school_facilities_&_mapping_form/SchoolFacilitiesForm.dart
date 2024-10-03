import 'dart:convert';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:path_provider/path_provider.dart';

import 'package:app17000ft_new/forms/school_facilities_&_mapping_form/school_facilities_controller.dart';
import 'package:app17000ft_new/forms/school_facilities_&_mapping_form/school_facilities_modals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_button.dart';
import 'package:app17000ft_new/components/custom_imagepreview.dart';
import 'package:app17000ft_new/components/custom_textField.dart';
import 'package:app17000ft_new/components/error_text.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/helper/responsive_helper.dart';
import 'package:app17000ft_new/tourDetails/tour_controller.dart';
import 'package:app17000ft_new/components/custom_dropdown.dart';
import 'package:app17000ft_new/components/custom_labeltext.dart';
import 'package:app17000ft_new/components/custom_sizedBox.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import '../../base_client/base_client.dart';
import '../../components/custom_confirmation.dart';
import '../../components/custom_snackbar.dart';
import '../../helper/database_helper.dart';
import '../../home/home_screen.dart';


class SchoolFacilitiesForm extends StatefulWidget {
  String? userid;
  String? office;
  final SchoolFacilitiesRecords? existingRecord;
  SchoolFacilitiesForm({
    super.key,
    this.userid,
    String? office, this.existingRecord,
  });

  @override
  State<SchoolFacilitiesForm> createState() => _SchoolFacilitiesFormState();
}

class _SchoolFacilitiesFormState extends State<SchoolFacilitiesForm> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();





  // Start of selecting Field
  String? selectedValue = ''; // For the UDISE code
  String? selectedValue2 = ''; // For the Residential School
  String? selectedValue3 = ''; // For the Electricity Available
  String? selectedValue4 = ''; // For the Internet Connectivity
  String? selectedValue5 = ''; // For the Projector
  String? selectedValue6 = ''; // For the Smart Classroom
  String? selectedValue7 = ''; // For the Playground Available
  String? selectedValue8 = ''; // For the Library Available
  String? selectedValue9 = ''; // For the librarian training
  String? selectedValue10 = ''; // For the librarian register
  // End of selecting Field error


  // Start of radio Field
  bool radioFieldError = false; // For the UDISE code
  bool radioFieldError2 = false; // For the Residential School
  bool radioFieldError3 = false; // For the Electricity Available
  bool radioFieldError4 = false; // For the Internet Connectivity
  bool radioFieldError5 = false; // For the Projector
  bool radioFieldError6 = false; // For the Smart Classroom
  bool radioFieldError7 = false; // For the Playground Available
  bool radioFieldError8 = false; // For the Library Available
  bool radioFieldError9 = false; // For the librarian training
  bool radioFieldError10 = false; // For the librarian register
  // End of radio Field error



  List<String> splitSchoolLists = [];
  String? _selectedDesignation;

  // Start of Showing Fields
  bool showBasicDetails = true; // For show Basic Details
  bool showSchoolFacilities = false; //For show and hide School Facilities
  bool showLibrary = false; //For show and hide Library
  // End of Showing Fields

  bool validateRegister = false;
  bool _isImageUploaded = false;

  bool validateRegister2 = false;
  bool _isImageUploaded2 = false;


    @override
  void initState() {
    super.initState();

    if (!Get.isRegistered<SchoolFacilitiesController>()) {
      Get.put(SchoolFacilitiesController());
    }




    final schoolFacilitiesController =
        Get.find<SchoolFacilitiesController>();

    if (widget.existingRecord != null) {
      final existingRecord = widget.existingRecord!;

      schoolFacilitiesController.correctUdiseCodeController
          .text = existingRecord.correctUdise ?? '';
      schoolFacilitiesController.nameOfLibrarianController.text =
          existingRecord.librarianName ?? '';
      schoolFacilitiesController.noOfFunctionalClassroomController.text =
          existingRecord.numFunctionalClass ?? '';
      schoolFacilitiesController.setTour(existingRecord.tourId);
   schoolFacilitiesController.setSchool(existingRecord.school);


// make this code that user can also edit the participant string
      selectedValue = existingRecord.udiseCode;
      selectedValue2 = existingRecord.residentialValue;
      selectedValue3 = existingRecord.electricityValue;
      selectedValue4 = existingRecord.internetValue;
      selectedValue5 = existingRecord.projectorValue;
      selectedValue6 = existingRecord.smartClassValue;
      selectedValue7 = existingRecord.playgroundValue;
      selectedValue8 = existingRecord.libValue;
      selectedValue9 = existingRecord.librarianTraining;
      selectedValue10 = existingRecord.libRegisterValue;
      _selectedDesignation = existingRecord.libLocation;
      widget.userid = existingRecord.created_by;
// make a init state here for feching the data to facilities from the api and make it editable on click of edit and navigate the user in this page




    }
  }




  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return WillPopScope(
        onWillPop: () async {
          IconData icon = Icons.check_circle;
          bool shouldExit = await showDialog(
              context: context,
              builder: (_) => Confirmation(
                  iconname: icon,
                  title: 'Exit Confirmation',
                  yes: 'Yes',
                  no: 'no',
                  desc: 'Are you sure you want to leave this screen?',
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                  }));
          return shouldExit;
        },
        child: Scaffold(
            appBar: const CustomAppbar(
              title: 'School Facilities & Mapping Form',
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(children: [
                      GetBuilder<SchoolFacilitiesController>(
                          init: SchoolFacilitiesController(),
                          builder: (schoolFacilitiesController) {
                            return Form(
                                key: _formKey,
                                child: GetBuilder<TourController>(
                                    init: TourController(),
                                    builder: (tourController) {
                                      // Fetch tour details once, not on every rebuild.
                                      if (tourController.getLocalTourList.isEmpty) {
                                        tourController.fetchTourDetails();
                                      }

                                      return Column(children: [
                                        if (showBasicDetails) ...[
                                          LabelText(
                                            label: 'Basic Details',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          LabelText(
                                            label: 'Tour ID',
                                            astrick: true,
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          CustomDropdownFormField(
                                            focusNode: schoolFacilitiesController.tourIdFocusNode,
                                            options: tourController.getLocalTourList
                                                .map((e) => e.tourId!) // Ensure tourId is non-nullable
                                                .toList(),
                                            selectedOption: schoolFacilitiesController.tourValue,
                                            onChanged: (value) {
                                              // Safely handle the school list splitting by commas
                                              splitSchoolLists = tourController
                                                  .getLocalTourList
                                                  .where((e) => e.tourId == value)
                                                  .map((e) => e.allSchool!.split(',').map((s) => s.trim()).toList())
                                                  .expand((x) => x)
                                                  .toList();

                                              // Single setState call for efficiency
                                              setState(() {
                                                schoolFacilitiesController.setSchool(null);
                                                schoolFacilitiesController.setTour(value);
                                              });
                                            },
                                            labelText: "Select Tour ID",
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          LabelText(
                                            label: 'School',
                                            astrick: true,
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          // DropdownSearch for selecting a single school
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
                                              disabledItemFn: (String s) => s.startsWith('I'), // Disable based on condition
                                            ),
                                            items: splitSchoolLists, // Split school list as strings
                                            dropdownDecoratorProps: const DropDownDecoratorProps(
                                              dropdownSearchDecoration: InputDecoration(
                                                labelText: "Select School",
                                                hintText: "Select School",
                                              ),
                                            ),
                                            onChanged: (value) {
                                              // Set the selected school
                                              setState(() {
                                                schoolFacilitiesController.setSchool(value);
                                              });
                                            },
                                            selectedItem: schoolFacilitiesController.schoolValue,
                                          ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            LabelText(
                                              label:
                                                  'Is this UDISE code is correct?',
                                              astrick: true,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue: selectedValue,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue =
                                                            value as String?;
                                                        if (value == 'Yes') {

                                                          schoolFacilitiesController.correctUdiseCodeController.clear();


                                                        }

                                                      });
                                                    },
                                                  ),
                                                  const Text('Yes'),
                                                ],
                                              ),
                                            ),
                                            CustomSizedBox(
                                              value: 150,
                                              side: 'width',
                                            ),
                                            // make it that user can also edit the tourId and school
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'No',
                                                    groupValue: selectedValue,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (radioFieldError)
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Please select an option',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            if (selectedValue == 'No') ...[
                                              LabelText(
                                                label:
                                                    'Write Correct UDISE school code',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                              CustomTextFormField(
                                                textController:
                                                    schoolFacilitiesController
                                                        .correctUdiseCodeController,
                                                textInputType:
                                                    TextInputType.number,
                                                inputFormatters: [
                                                  LengthLimitingTextInputFormatter(
                                                      13),
                                                  FilteringTextInputFormatter
                                                      .digitsOnly,
                                                ],
                                                labelText:
                                                    'Enter correct UDISE code',
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill this field';
                                                  }
                                                  if (!RegExp(r'^[0-9]+$')
                                                      .hasMatch(value)) {
                                                    return 'Please enter a valid number';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                            ],
                                            CustomButton(
                                              title: 'Next',
                                              onPressedButton: () {
                                                setState(() {
                                                  radioFieldError =
                                                      selectedValue == null ||
                                                          selectedValue!
                                                              .isEmpty;
                                                });

                                                if (_formKey.currentState!
                                                        .validate() &&
                                                    !radioFieldError) {
                                                  setState(() {
                                                    showBasicDetails = false;
                                                    showSchoolFacilities = true;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                          // End of Basic Details

                                          // Start of School Facilities
                                          if (showSchoolFacilities) ...[
                                            LabelText(
                                              label: 'School Facilities',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            LabelText(
                                              label: 'Residential School',
                                              astrick: true,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue: selectedValue2,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue2 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('Yes'),
                                                ],
                                              ),
                                            ),
                                            CustomSizedBox(
                                              value: 150,
                                              side: 'width',
                                            ),

                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'No',
                                                    groupValue: selectedValue2,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue2 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (radioFieldError2)
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Please select an option',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            LabelText(
                                              label: 'Electricity Available',
                                              astrick: true,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue: selectedValue3,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue3 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('Yes'),
                                                ],
                                              ),
                                            ),
                                            CustomSizedBox(
                                              value: 150,
                                              side: 'width',
                                            ),
                                            // make it that user can also edit the tourId and school
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'No',
                                                    groupValue:selectedValue3,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue3 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (radioFieldError3)
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Please select an option',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            LabelText(
                                              label: 'Internet Connectivity',
                                              astrick: true,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue: selectedValue4,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue4 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('Yes'),
                                                ],
                                              ),
                                            ),
                                            CustomSizedBox(
                                              value: 150,
                                              side: 'width',
                                            ),
                                            // make it that user can also edit the tourId and school
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'No',
                                                    groupValue: selectedValue4,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue4 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (radioFieldError4)
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Please select an option',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            LabelText(
                                              label: 'Projector',
                                              astrick: true,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue: selectedValue5,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue5 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('Yes'),
                                                ],
                                              ),
                                            ),
                                            CustomSizedBox(
                                              value: 150,
                                              side: 'width',
                                            ),
                                            // make it that user can also edit the tourId and school
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'No',
                                                    groupValue:selectedValue5,
                                                    onChanged: (value) {
                                                      setState(() {selectedValue5 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (radioFieldError5)
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Please select an option',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            LabelText(
                                              label: 'Smart Classroom',
                                              astrick: true,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue: selectedValue6,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue6 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('Yes'),
                                                ],
                                              ),
                                            ),
                                            CustomSizedBox(
                                              value: 150,
                                              side: 'width',
                                            ),
                                            // make it that user can also edit the tourId and school
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'No',
                                                    groupValue: selectedValue6,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue6 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (radioFieldError6)
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Please select an option',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            LabelText(
                                              label:
                                                  'Number of functional Classroom ',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),

                                            CustomTextFormField(
                                              textController:
                                                  schoolFacilitiesController
                                                      .noOfFunctionalClassroomController,
                                              labelText: 'Enter number',
                                              textInputType:
                                                  TextInputType.number,
                                              inputFormatters: [
                                                LengthLimitingTextInputFormatter(
                                                    3),
                                                FilteringTextInputFormatter
                                                    .digitsOnly,
                                              ],
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (!RegExp(r'^[0-9]+$')
                                                    .hasMatch(value)) {
                                                  return 'Please enter a valid number';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),

                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            LabelText(
                                              label: 'Playground Available',
                                              astrick: true,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue: selectedValue7,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue7 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('Yes'),
                                                ],
                                              ),
                                            ),
                                            CustomSizedBox(
                                              value: 150,
                                              side: 'width',
                                            ),
                                            // make it that user can also edit the tourId and school
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'No',
                                                    groupValue: selectedValue7,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue7 =
                                                            value as String?;
                                                      });
                                                      if (value == 'No') {

                                                        schoolFacilitiesController.multipleImage.clear();


                                                      }
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (radioFieldError7)
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(left: 16.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Text(
                                                    'Please select an option',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            if (selectedValue7 == 'Yes') ...[
                                              LabelText(
                                                label:
                                                    'Upload photos of Playground',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                              Container(
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  border: Border.all(
                                                      width: 2,
                                                      color: _isImageUploaded ==
                                                              false
                                                          ? AppColors.primary
                                                          : AppColors.error),
                                                ),
                                                child: ListTile(
                                                    title: _isImageUploaded ==
                                                            false
                                                        ? const Text(
                                                            'Click or Upload Image',
                                                          )
                                                        : const Text(
                                                            'Click or Upload Image',
                                                            style: TextStyle(
                                                                color: AppColors
                                                                    .error),
                                                          ),
                                                    trailing: const Icon(
                                                        Icons.camera_alt,
                                                        color: AppColors
                                                            .onBackground),
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          backgroundColor:
                                                              AppColors.primary,
                                                          context: context,
                                                          builder: ((builder) =>
                                                              schoolFacilitiesController
                                                                  .bottomSheet(
                                                                      context)));
                                                    }),
                                              ),
                                              ErrorText(
                                                isVisible: validateRegister,
                                                message:
                                                    'Playground Image Required',
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                              schoolFacilitiesController
                                                      .multipleImage.isNotEmpty
                                                  ? Container(
                                                      width: responsive
                                                          .responsiveValue(
                                                              small: 600.0,
                                                              medium: 900.0,
                                                              large: 1400.0),
                                                      height: responsive
                                                          .responsiveValue(
                                                              small: 170.0,
                                                              medium: 170.0,
                                                              large: 170.0),
                                                      decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color: Colors.grey),
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                      ),
                                                      child:
                                                          schoolFacilitiesController
                                                                  .multipleImage
                                                                  .isEmpty
                                                              ? const Center(
                                                                  child: Text(
                                                                      'No images selected.'),
                                                                )
                                                              : ListView
                                                                  .builder(
                                                                  scrollDirection:
                                                                      Axis.horizontal,
                                                                  itemCount:
                                                                      schoolFacilitiesController
                                                                          .multipleImage
                                                                          .length,
                                                                  itemBuilder:
                                                                      (context,
                                                                          index) {
                                                                    return SizedBox(
                                                                      height:
                                                                          200,
                                                                      width:
                                                                          200,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                const EdgeInsets.all(8.0),
                                                                            child:
                                                                                GestureDetector(
                                                                              onTap: () {
                                                                                CustomImagePreview.showImagePreview(schoolFacilitiesController.multipleImage[index].path, context);
                                                                              },
                                                                              child: Image.file(
                                                                                File(schoolFacilitiesController.multipleImage[index].path),
                                                                                width: 190,
                                                                                height: 120,
                                                                                fit: BoxFit.fill,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              setState(() {
                                                                                schoolFacilitiesController.multipleImage.removeAt(index);
                                                                              });
                                                                            },
                                                                            child:
                                                                                const Icon(
                                                                              Icons.delete,
                                                                              color: Colors.red,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                    )
                                                  : const SizedBox(),
                                              CustomSizedBox(
                                                value: 40,
                                                side: 'height',
                                              ),
                                            ],
                                            Row(
                                              children: [
                                                CustomButton(
                                                    title: 'Back',
                                                    onPressedButton: () {
                                                      setState(() {
                                                        showBasicDetails = true;
                                                        showSchoolFacilities =
                                                            false;
                                                      });
                                                    }),
                                                const Spacer(),
                                                CustomButton(
                                                  title: 'Next',
                                                  onPressedButton: () {
                                                    setState(() {
                                                      radioFieldError2 =
                                                          selectedValue2 ==
                                                                  null ||
                                                              selectedValue2!
                                                                  .isEmpty;
                                                      radioFieldError3 =
                                                          selectedValue3 ==
                                                                  null ||
                                                              selectedValue3!
                                                                  .isEmpty;
                                                      radioFieldError4 =
                                                          selectedValue4 ==
                                                                  null ||
                                                              selectedValue4!
                                                                  .isEmpty;
                                                      radioFieldError5 =
                                                          selectedValue5 ==
                                                                  null ||
                                                              selectedValue5!
                                                                  .isEmpty;
                                                      radioFieldError6 =
                                                          selectedValue6 ==
                                                                  null ||
                                                              selectedValue6!
                                                                  .isEmpty;
                                                      radioFieldError7 =
                                                          selectedValue7 ==
                                                                  null ||
                                                              selectedValue7!
                                                                  .isEmpty;

                                                      // Validate the upload photo playground only if "Yes" is selected
                                                      if (selectedValue7 ==
                                                          'Yes') {
                                                        validateRegister =
                                                            schoolFacilitiesController
                                                                .multipleImage
                                                                .isEmpty;
                                                      } else {
                                                        validateRegister =
                                                            false;
                                                      }
                                                    });

                                                    if (_formKey.currentState!
                                                            .validate() &&
                                                        !radioFieldError2 &&
                                                        !radioFieldError3 &&
                                                        !radioFieldError4 &&
                                                        !radioFieldError5 &&
                                                        !radioFieldError6 &&
                                                        !radioFieldError7 &&
                                                        !validateRegister) {
                                                      setState(() {
                                                        showSchoolFacilities =
                                                            false;
                                                        showLibrary = true;
                                                      });
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                            CustomSizedBox(
                                              value: 40,
                                              side: 'height',
                                            ),
                                          ],
                                          if (showLibrary) ...[
                                            LabelText(
                                              label: 'Teacher Capacity',
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            LabelText(
                                              label: '1. Library Available?',
                                              astrick: true,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue: selectedValue8,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue8 =
                                                            value as String?;
                                                        radioFieldError8 =
                                                            false; // Reset error state
                                                      });
                                                    },
                                                  ),
                                                  const Text('Yes'),
                                                ],
                                              ),
                                            ),
                                            CustomSizedBox(
                                              value: 150,
                                              side: 'width',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'No',
                                                    groupValue: selectedValue8,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        selectedValue8 =
                                                            value as String?;
                                                        radioFieldError8 =
                                                            false; // Reset error state
                                                      });
                                                      if (value == 'No') {

                                                        _selectedDesignation = null;
                                                        selectedValue9 = null;
                                                        selectedValue10 = null;
                                                        schoolFacilitiesController.nameOfLibrarianController.clear();
                                                        schoolFacilitiesController.multipleImage2.clear();


                                                      }
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (radioFieldError8)
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 16.0),
                                                child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: const Text(
                                                    'Please select an option',
                                                    style: TextStyle(
                                                        color: Colors.red),
                                                  ),
                                                ),
                                              ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            if (selectedValue8 == 'Yes') ...[
                                              LabelText(
                                                label:
                                                    'Where is the Library located?',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                  value: 20, side: 'height'),
                                              DropdownButtonFormField<String>(
                                                decoration: InputDecoration(
                                                  labelText: 'Select an option',
                                                  border: OutlineInputBorder(),
                                                ),
                                                value: _selectedDesignation,
                                                items: [
                                                  DropdownMenuItem(
                                                      value: 'Corridor',
                                                      child: Text('Corridor')),
                                                  DropdownMenuItem(
                                                      value: 'HMs Room',
                                                      child: Text('HMs Room')),
                                                  DropdownMenuItem(
                                                      value: 'DigiLab Room',
                                                      child:
                                                          Text('DigiLab Room')),
                                                  DropdownMenuItem(
                                                      value: 'Classroom',
                                                      child: Text('Classroom')),
                                                  DropdownMenuItem(
                                                      value:
                                                          'Separate Library room',
                                                      child: Text(
                                                          'Separate Library room')),
                                                ],
                                                onChanged: (value) {
                                                  setState(() {
                                                    _selectedDesignation =
                                                        value;
                                                  });
                                                },
                                                validator: (value) {
                                                  if (value == null) {
                                                    return 'Please select a designation';
                                                  }
                                                  return null;
                                                },
                                              ),
                                              CustomSizedBox(
                                                  value: 20, side: 'height'),
                                              LabelText(
                                                label:
                                                    'Name of Designated Librarian',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                  value: 20, side: 'height'),
                                              CustomTextFormField(
                                                textController:
                                                    schoolFacilitiesController
                                                        .nameOfLibrarianController,
                                                labelText: 'Enter Name',
                                                validator: (value) {
                                                  if (value!.isEmpty) {
                                                    return 'Write Name';
                                                  }
                                                  return null;
                                                },
                                                showCharacterCount: true,
                                              ),
                                              CustomSizedBox(
                                                  value: 20, side: 'height'),
                                              LabelText(
                                                label:
                                                    'Has the Librarian attended 17000ft centralized training?',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                  value: 20, side: 'height'),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 300),
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                      value: 'Yes',
                                                      groupValue:
                                                      selectedValue9,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedValue9 =
                                                              value as String?;
                                                          radioFieldError9 =
                                                              false; // Reset error state
                                                        });
                                                      },
                                                    ),
                                                    const Text('Yes'),
                                                  ],
                                                ),
                                              ),
                                              CustomSizedBox(
                                                value: 150,
                                                side: 'width',
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 300),
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                      value: 'No',
                                                      groupValue:
                                                      selectedValue9,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedValue9 =
                                                              value as String?;
                                                          radioFieldError9 =
                                                              false; // Reset error state
                                                        });
                                                      },
                                                    ),
                                                    const Text('No'),
                                                  ],
                                                ),
                                              ),
                                              if (radioFieldError9)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: const Text(
                                                      'Please select an option',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                              LabelText(
                                                label:
                                                    'Is the Librarian Register available?',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                  value: 20, side: 'height'),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 300),
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                      value: 'Yes',
                                                      groupValue:
                                                      selectedValue10,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedValue10 =
                                                              value as String?;
                                                          radioFieldError10 =
                                                              false; // Reset error state
                                                        });
                                                      },
                                                    ),
                                                    const Text('Yes'),
                                                  ],
                                                ),
                                              ),
                                              CustomSizedBox(
                                                value: 150,
                                                side: 'width',
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 300),
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                      value: 'No',
                                                      groupValue:
                                                      selectedValue10,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          selectedValue10 =
                                                              value as String?;
                                                          radioFieldError10 =
                                                              false; // Reset error state
                                                        });
                                                      },
                                                    ),
                                                    const Text('No'),
                                                  ],
                                                ),
                                              ),
                                              if (radioFieldError10)
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 16.0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.centerLeft,
                                                    child: const Text(
                                                      'Please select an option',
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                              if (selectedValue10 ==
                                                  'Yes') ...[
                                                LabelText(
                                                  label:
                                                      'Upload photos of Library Register',
                                                  astrick: true,
                                                ),
                                                CustomSizedBox(
                                                  value: 20,
                                                  side: 'height',
                                                ),
                                                Container(
                                                  height: 60,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                    border: Border.all(
                                                        width: 2,
                                                        color:
                                                            _isImageUploaded2 ==
                                                                    false
                                                                ? AppColors
                                                                    .primary
                                                                : AppColors
                                                                    .error),
                                                  ),
                                                  child: ListTile(
                                                      title:
                                                          _isImageUploaded2 ==
                                                                  false
                                                              ? const Text(
                                                                  'Click or Upload Image',
                                                                )
                                                              : const Text(
                                                                  'Click or Upload Image',
                                                                  style: TextStyle(
                                                                      color: AppColors
                                                                          .error),
                                                                ),
                                                      trailing: const Icon(
                                                          Icons.camera_alt,
                                                          color: AppColors
                                                              .onBackground),
                                                      onTap: () {
                                                        showModalBottomSheet(
                                                            backgroundColor:
                                                                AppColors
                                                                    .primary,
                                                            context: context,
                                                            builder: ((builder) =>
                                                                schoolFacilitiesController
                                                                    .bottomSheet2(
                                                                        context)));
                                                      }),
                                                ),
                                                ErrorText(
                                                  isVisible: validateRegister2,
                                                  message:
                                                      'library Register Image Required',
                                                ),
                                                CustomSizedBox(
                                                  value: 20,
                                                  side: 'height',
                                                ),
                                                schoolFacilitiesController
                                                        .multipleImage2
                                                        .isNotEmpty
                                                    ? Container(
                                                        width: responsive
                                                            .responsiveValue(
                                                                small: 600.0,
                                                                medium: 900.0,
                                                                large: 1400.0),
                                                        height: responsive
                                                            .responsiveValue(
                                                                small: 170.0,
                                                                medium: 170.0,
                                                                large: 170.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        child:
                                                            schoolFacilitiesController
                                                                    .multipleImage2
                                                                    .isEmpty
                                                                ? const Center(
                                                                    child: Text(
                                                                        'No images selected.'),
                                                                  )
                                                                : ListView
                                                                    .builder(
                                                                    scrollDirection:
                                                                        Axis.horizontal,
                                                                    itemCount: schoolFacilitiesController
                                                                        .multipleImage2
                                                                        .length,
                                                                    itemBuilder:
                                                                        (context,
                                                                            index) {
                                                                      return SizedBox(
                                                                        height:
                                                                            200,
                                                                        width:
                                                                            200,
                                                                        child:
                                                                            Column(
                                                                          children: [
                                                                            Padding(
                                                                              padding: const EdgeInsets.all(8.0),
                                                                              child: GestureDetector(
                                                                                onTap: () {
                                                                                  CustomImagePreview2.showImagePreview2(schoolFacilitiesController.multipleImage2[index].path, context);
                                                                                },
                                                                                child: Image.file(
                                                                                  File(schoolFacilitiesController.multipleImage2[index].path),
                                                                                  width: 190,
                                                                                  height: 120,
                                                                                  fit: BoxFit.fill,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            GestureDetector(
                                                                              onTap: () {
                                                                                setState(() {
                                                                                  schoolFacilitiesController.multipleImage2.removeAt(index);
                                                                                });
                                                                              },
                                                                              child: const Icon(
                                                                                Icons.delete,
                                                                                color: Colors.red,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    },
                                                                  ),
                                                      )
                                                    : const SizedBox(),
                                                CustomSizedBox(
                                                  value: 40,
                                                  side: 'height',
                                                ),
                                              ],
                                            ],
                                            Row(
                                              children: [
                                                CustomButton(
                                                    title: 'Back',
                                                    onPressedButton: () {
                                                      setState(() {
                                                        showSchoolFacilities =
                                                            true;
                                                        showLibrary = false;
                                                      });
                                                    }),
                                                const Spacer(),
                                                CustomButton(
                                                    title: 'Submit',
                                                    onPressedButton: () async {
                                                      setState(() {
                                                        radioFieldError8 =
                                                            selectedValue8 ==
                                                                    null ||
                                                                selectedValue8!
                                                                    .isEmpty;
                                                        radioFieldError9 =
                                                            selectedValue8 ==
                                                                    'Yes' &&
                                                                (selectedValue9 ==
                                                                        null ||
                                                                    selectedValue9!
                                                                        .isEmpty);

                                                        radioFieldError10 =
                                                            selectedValue8 ==
                                                                    'Yes' &&
                                                                (selectedValue10 ==
                                                                        null ||
                                                                    selectedValue10!
                                                                        .isEmpty);

                                                        if (selectedValue10 ==
                                                            'Yes') {
                                                          validateRegister2 =
                                                              schoolFacilitiesController
                                                                  .multipleImage2
                                                                  .isEmpty;
                                                        } else {
                                                          validateRegister2 =
                                                              false;
                                                        }
                                                      });

                                                      if (_formKey.currentState!
                                                              .validate() &&
                                                          !radioFieldError8 &&
                                                          !radioFieldError9 &&
                                                          !radioFieldError10 &&
                                                          !validateRegister2) {
                                                        print('Inserted');

                                                        List<File> imgPlayFiles = [];
                                                        for (var imagePath in schoolFacilitiesController.imagePaths) {
                                                          imgPlayFiles.add(File(imagePath)); // Convert image path to File
                                                        }

                                                        List<File> register_picFiles = [];
                                                        for (var imagePath2 in schoolFacilitiesController.imagePaths2) {
                                                          register_picFiles.add(File(imagePath2)); // Convert image path to File
                                                        }
                                                        DateTime now =
                                                            DateTime.now();
                                                        String formattedDate =
                                                            DateFormat(
                                                                    'yyyy-MM-dd')
                                                                .format(now);

                                                        String imgPlayFilesPaths = imgPlayFiles.map((file) => file.path).join(',');
                                                        String register_picFilesPaths = register_picFiles.map((file) => file.path).join(',');


                                                        SchoolFacilitiesRecords enrolmentCollectionObj = SchoolFacilitiesRecords(
                                                            tourId: schoolFacilitiesController.tourValue ??
                                                                '',
                                                            school: schoolFacilitiesController.schoolValue ??
                                                                '',
                                                            playImg:
                                                            imgPlayFilesPaths,
                                                            correctUdise: schoolFacilitiesController
                                                                .correctUdiseCodeController
                                                                .text,
                                                            numFunctionalClass:
                                                                schoolFacilitiesController
                                                                    .noOfFunctionalClassroomController
                                                                    .text,
                                                            librarianName:
                                                                schoolFacilitiesController
                                                                    .nameOfLibrarianController
                                                                    .text,
                                                            imgRegister:
                                                            register_picFilesPaths,
                                                            udiseCode:
                                                            selectedValue ?? 'No',
                                                            residentialValue:
                                                            selectedValue2!,
                                                            electricityValue:
                                                            selectedValue3!,
                                                            internetValue:
                                                            selectedValue4!,
                                                            projectorValue:
                                                            selectedValue5!,
                                                            smartClassValue:
                                                            selectedValue6!,
                                                            playgroundValue:
                                                            selectedValue7!,
                                                            libValue:
                                                            selectedValue8!,
                                                            libLocation:
                                                                _selectedDesignation,
                                                            librarianTraining:
                                                            selectedValue9,
                                                            libRegisterValue:
                                                            selectedValue10,
                                                            created_at:
                                                                formattedDate.toString(),
                                                            created_by: widget.userid.toString());

                                                        int result =
                                                            await LocalDbController()
                                                                .addData(
                                                                    schoolFacilitiesRecords:
                                                                        enrolmentCollectionObj);
                                                        if (result > 0) {
                                                          schoolFacilitiesController
                                                              .clearFields();
                                                          setState(() {

                                                          // Clear the image list
                                                            _isImageUploaded = false;
                                                            _isImageUploaded2 = false;
                                                            selectedValue3 = '';
                                                            selectedValue2 = '';
                                                            selectedValue = '';
                                                            selectedValue4 = '';
                                                            selectedValue5 = '';
                                                            selectedValue6 = '';
                                                            selectedValue7 = '';
                                                            selectedValue8 = '';
                                                            selectedValue9 = '';
                                                            selectedValue10 = '';
                                                            _selectedDesignation = '';



                                                          });

                                                          await saveDataToFile(enrolmentCollectionObj).then((_) {
                                                            // If successful, show a snackbar indicating the file was downloaded
                                                            customSnackbar(
                                                              'File downloaded successfully',
                                                              'downloaded',
                                                              AppColors.primary,
                                                              AppColors.onPrimary,
                                                              Icons.file_download_done,
                                                            );
                                                          }).catchError((error) {
                                                            // If there's an error during download, show an error snackbar
                                                            customSnackbar(
                                                              'Error',
                                                              'File download failed: $error',
                                                              AppColors.primary,
                                                              AppColors.onPrimary,
                                                              Icons.error,
                                                            );
                                                          });


                                                          customSnackbar(

                                                              'Submitted Successfully',
                                                              'Submitted',
                                                              AppColors.primary,
                                                              AppColors
                                                                  .onPrimary,
                                                              Icons.verified);

                                                          // Navigate to HomeScreen
                                                          Navigator.pushReplacement(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                    HomeScreen()),
                                                          );
                                                        } else {
                                                          customSnackbar(
                                                              'Error',
                                                              'Something went wrong',
                                                              AppColors.error,
                                                              Colors.white,
                                                              Icons.error);
                                                        }
                                                      } else {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                FocusNode());
                                                      }
                                                    }),
                                              ],
                                            ),
                                          ] // end of the library
                                        ],
                                      );
                                    }));
                          })
                    ])))));
  }
}





Future<void> saveDataToFile(SchoolFacilitiesRecords data) async {
  try {
    // Request storage permissions
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Use path_provider to get a valid directory, such as downloads
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
        if (directory != null) {
          String newPath = '';
          List<String> folders = directory.path.split('/');
          for (int x = 1; x < folders.length; x++) {
            String folder = folders[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          directory = Directory("$newPath/Download");
        }
      }

      if (directory != null && !await directory.exists()) {
        await directory.create(
            recursive: true); // Create the directory if it doesn't exist
      }

      final path =
          '${directory!.path}/school_facilities_form_${data.created_at}.txt';
      print('Saving file to: $path'); // Debugging output

      // Convert the EnrolmentCollectionModel object to a JSON string
      String jsonString = jsonEncode(data);

      // Handle Base64 conversion for images
      List<String> base64Images = [];
      for (String imagePath in data.playImg!.split(',')) {
        File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          List<int> imageBytes = await imageFile.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          base64Images.add(base64Image);
        } else {
          print('Image not found: $imagePath');
        }
      }

      for (String imagePath in data.imgRegister!.split(',')) {
        File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          List<int> imageBytes = await imageFile.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          base64Images.add(base64Image);
        } else {
          print('Image not found: $imagePath');
        }
      }

      // Update the enrolment data to include Base64 image strings
      Map<String, dynamic> updatedData = jsonDecode(jsonString);
      updatedData['playImg'] =
          base64Images;

      updatedData['imgRegister'] =
          base64Images;

      // Write the updated JSON string to a file
      File file = File(path);
      await file.writeAsString(jsonEncode(updatedData));

      // Check if the file has been created successfully
      if (await file.exists()) {
        print('File successfully created at: ${file.path}');
      } else {
        print('File not found after writing.');
      }
    } else {
      print('Storage permission not granted');
      // Optionally, handle what happens if permission is denied
    }
  } catch (e) {
    print('Error saving data: $e');
  }
}
