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
  String? tourId; // Add this line
  String? school; // Add this line for school
  final SchoolFacilitiesRecords? existingRecord;
  SchoolFacilitiesForm({
    super.key,
    this.userid,
    String? office, this.existingRecord,
    this.school,   this.tourId,
  });

  @override
  State<SchoolFacilitiesForm> createState() => _SchoolFacilitiesFormState();
}

class _SchoolFacilitiesFormState extends State<SchoolFacilitiesForm> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();



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
      schoolFacilitiesController.selectedValue = existingRecord.udiseCode;
      schoolFacilitiesController.selectedValue2 = existingRecord.residentialValue;
      schoolFacilitiesController.selectedValue3 = existingRecord.electricityValue;
      schoolFacilitiesController.selectedValue4 = existingRecord.internetValue;
      schoolFacilitiesController.selectedValue5 = existingRecord.projectorValue;
      schoolFacilitiesController.selectedValue6 = existingRecord.smartClassValue;
      schoolFacilitiesController.selectedValue7 = existingRecord.playgroundValue;
      schoolFacilitiesController.selectedValue8 = existingRecord.libValue;
      schoolFacilitiesController.selectedValue9 = existingRecord.librarianTraining;
      schoolFacilitiesController.selectedValue10 = existingRecord.libRegisterValue;
      schoolFacilitiesController.selectedDesignation = existingRecord.libLocation;
      widget.userid = existingRecord.created_by;

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
                                        if (schoolFacilitiesController.showBasicDetails) ...[
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
                                              schoolFacilitiesController.splitSchoolLists = tourController
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
                                            items: schoolFacilitiesController.splitSchoolLists, // Split school list as strings
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
                                                    groupValue: schoolFacilitiesController.selectedValue,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue =
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
                                                    groupValue: schoolFacilitiesController.selectedValue,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (schoolFacilitiesController.radioFieldError)
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
                                            if (schoolFacilitiesController.selectedValue == 'No') ...[
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
                                                  schoolFacilitiesController.radioFieldError =
                                                      schoolFacilitiesController.selectedValue == null ||
                                                          schoolFacilitiesController.selectedValue!
                                                              .isEmpty;
                                                });

                                                if (_formKey.currentState!
                                                        .validate() &&
                                                    !schoolFacilitiesController.radioFieldError) {
                                                  setState(() {
                                                    schoolFacilitiesController.showBasicDetails = false;
                                                    schoolFacilitiesController.showSchoolFacilities = true;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                          // End of Basic Details

                                          // Start of School Facilities
                                          if (schoolFacilitiesController.showSchoolFacilities) ...[
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
                                                    groupValue: schoolFacilitiesController.selectedValue2,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue2 =
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
                                                    groupValue: schoolFacilitiesController.selectedValue2,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue2 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (schoolFacilitiesController.radioFieldError2)
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
                                                    groupValue: schoolFacilitiesController.selectedValue3,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue3 =
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
                                                    groupValue:schoolFacilitiesController.selectedValue3,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue3 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (schoolFacilitiesController.radioFieldError3)
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
                                                    groupValue: schoolFacilitiesController.selectedValue4,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue4 =
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
                                                    groupValue: schoolFacilitiesController.selectedValue4,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue4 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (schoolFacilitiesController.radioFieldError4)
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
                                                    groupValue: schoolFacilitiesController.selectedValue5,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue5 =
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
                                                    groupValue:schoolFacilitiesController.selectedValue5,
                                                    onChanged: (value) {
                                                      setState(() {schoolFacilitiesController.selectedValue5 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (schoolFacilitiesController.radioFieldError5)
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
                                                    groupValue: schoolFacilitiesController.selectedValue6,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue6 =
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
                                                    groupValue: schoolFacilitiesController.selectedValue6,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue6 =
                                                            value as String?;
                                                      });
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (schoolFacilitiesController.radioFieldError6)
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
                                                    groupValue: schoolFacilitiesController.selectedValue7,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue7 =
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
                                                    groupValue: schoolFacilitiesController.selectedValue7,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue7 =
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
                                            if (schoolFacilitiesController.radioFieldError7)
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
                                            if (schoolFacilitiesController.selectedValue7 == 'Yes') ...[
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
                                                      color: schoolFacilitiesController.isImageUploaded ==
                                                              false
                                                          ? AppColors.primary
                                                          : AppColors.error),
                                                ),
                                                child: ListTile(
                                                    title: schoolFacilitiesController.isImageUploaded ==
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
                                                isVisible: schoolFacilitiesController.validateRegister,
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
                                                        schoolFacilitiesController.showBasicDetails = true;
                                                        schoolFacilitiesController.showSchoolFacilities =
                                                            false;
                                                      });
                                                    }),
                                                const Spacer(),
                                                CustomButton(
                                                  title: 'Next',
                                                  onPressedButton: () {
                                                    setState(() {
                                                      schoolFacilitiesController.radioFieldError2 =
                                                          schoolFacilitiesController.selectedValue2 ==
                                                                  null ||
                                                              schoolFacilitiesController.selectedValue2!
                                                                  .isEmpty;
                                                      schoolFacilitiesController.radioFieldError3 =
                                                          schoolFacilitiesController.selectedValue3 ==
                                                                  null ||
                                                              schoolFacilitiesController.selectedValue3!
                                                                  .isEmpty;
                                                      schoolFacilitiesController.radioFieldError4 =
                                                          schoolFacilitiesController.selectedValue4 ==
                                                                  null ||
                                                              schoolFacilitiesController.selectedValue4!
                                                                  .isEmpty;
                                                      schoolFacilitiesController.radioFieldError5 =
                                                          schoolFacilitiesController.selectedValue5 ==
                                                                  null ||
                                                              schoolFacilitiesController.selectedValue5!
                                                                  .isEmpty;
                                                      schoolFacilitiesController.radioFieldError6 =
                                                          schoolFacilitiesController.selectedValue6 ==
                                                                  null ||
                                                              schoolFacilitiesController.selectedValue6!
                                                                  .isEmpty;
                                                      schoolFacilitiesController.radioFieldError7 =
                                                          schoolFacilitiesController.selectedValue7 ==
                                                                  null ||
                                                              schoolFacilitiesController.selectedValue7!
                                                                  .isEmpty;

                                                      // Validate the upload photo playground only if "Yes" is selected
                                                      if (schoolFacilitiesController.selectedValue7 ==
                                                          'Yes') {
                                                        schoolFacilitiesController.validateRegister =
                                                            schoolFacilitiesController
                                                                .multipleImage
                                                                .isEmpty;
                                                      } else {
                                                        schoolFacilitiesController.validateRegister =
                                                            false;
                                                      }
                                                    });

                                                    if (_formKey.currentState!
                                                            .validate() &&
                                                        !schoolFacilitiesController.radioFieldError2 &&
                                                        !schoolFacilitiesController.radioFieldError3 &&
                                                        !schoolFacilitiesController.radioFieldError4 &&
                                                        !schoolFacilitiesController.radioFieldError5 &&
                                                        !schoolFacilitiesController.radioFieldError6 &&
                                                        !schoolFacilitiesController.radioFieldError7 &&
                                                        !schoolFacilitiesController.validateRegister) {
                                                      setState(() {
                                                        schoolFacilitiesController.showSchoolFacilities =
                                                            false;
                                                        schoolFacilitiesController.showLibrary = true;
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
                                          if (schoolFacilitiesController.showLibrary) ...[
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
                                                    groupValue: schoolFacilitiesController.selectedValue8,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue8 =
                                                            value as String?;
                                                        schoolFacilitiesController.radioFieldError8 =
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
                                                    groupValue: schoolFacilitiesController.selectedValue8,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        schoolFacilitiesController.selectedValue8 =
                                                            value as String?;
                                                        schoolFacilitiesController.radioFieldError8 =
                                                            false; // Reset error state
                                                      });
                                                      if (value == 'No') {

                                                        schoolFacilitiesController.selectedDesignation = null;
                                                        schoolFacilitiesController.selectedValue9 = null;
                                                        schoolFacilitiesController.selectedValue10 = null;
                                                        schoolFacilitiesController.nameOfLibrarianController.clear();
                                                        schoolFacilitiesController.multipleImage2.clear();


                                                      }
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (schoolFacilitiesController.radioFieldError8)
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
                                            if (schoolFacilitiesController.selectedValue8 == 'Yes') ...[
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
                                                value: schoolFacilitiesController.selectedDesignation,
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
                                                    schoolFacilitiesController.selectedDesignation =
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
                                                      schoolFacilitiesController.selectedValue9,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          schoolFacilitiesController.selectedValue9 =
                                                              value as String?;
                                                          schoolFacilitiesController.radioFieldError9 =
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
                                                      schoolFacilitiesController.selectedValue9,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          schoolFacilitiesController.selectedValue9 =
                                                              value as String?;
                                                          schoolFacilitiesController.radioFieldError9 =
                                                              false; // Reset error state
                                                        });
                                                      },
                                                    ),
                                                    const Text('No'),
                                                  ],
                                                ),
                                              ),
                                              if (schoolFacilitiesController.radioFieldError9)
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
                                                      schoolFacilitiesController.selectedValue10,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          schoolFacilitiesController.selectedValue10 =
                                                              value as String?;
                                                          schoolFacilitiesController.radioFieldError10 =
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
                                                      schoolFacilitiesController.selectedValue10,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          schoolFacilitiesController.selectedValue10 =
                                                              value as String?;
                                                          schoolFacilitiesController.radioFieldError10 =
                                                              false; // Reset error state
                                                        });
                                                      },
                                                    ),
                                                    const Text('No'),
                                                  ],
                                                ),
                                              ),
                                              if (schoolFacilitiesController.radioFieldError10)
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
                                              if (schoolFacilitiesController.selectedValue10 ==
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
                                                        schoolFacilitiesController.isImageUploaded2 ==
                                                                    false
                                                                ? AppColors
                                                                    .primary
                                                                : AppColors
                                                                    .error),
                                                  ),
                                                  child: ListTile(
                                                      title:
                                                      schoolFacilitiesController.isImageUploaded2 ==
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
                                                  isVisible: schoolFacilitiesController.validateRegister2,
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
                                                        schoolFacilitiesController.showSchoolFacilities =
                                                            true;
                                                        schoolFacilitiesController.showLibrary = false;
                                                      });
                                                    }),
                                                const Spacer(),
                                                CustomButton(
                                                    title: 'Submit',
                                                    onPressedButton: () async {
                                                      print('userid');
                                                      print( widget.userid);
                                                      setState(() {
                                                        schoolFacilitiesController.radioFieldError8 =
                                                            schoolFacilitiesController.selectedValue8 ==
                                                                    null ||
                                                                schoolFacilitiesController.selectedValue8!
                                                                    .isEmpty;
                                                        schoolFacilitiesController.radioFieldError9 =
                                                            schoolFacilitiesController.selectedValue8 ==
                                                                    'Yes' &&
                                                                (schoolFacilitiesController.selectedValue9 ==
                                                                        null ||
                                                                    schoolFacilitiesController.selectedValue9!
                                                                        .isEmpty);

                                                        schoolFacilitiesController.radioFieldError10 =
                                                            schoolFacilitiesController.selectedValue8 ==
                                                                    'Yes' &&
                                                                (schoolFacilitiesController.selectedValue10 ==
                                                                        null ||
                                                                    schoolFacilitiesController.selectedValue10!
                                                                        .isEmpty);

                                                        if (schoolFacilitiesController.selectedValue10 ==
                                                            'Yes') {
                                                          schoolFacilitiesController.validateRegister2 =
                                                              schoolFacilitiesController
                                                                  .multipleImage2
                                                                  .isEmpty;
                                                        } else {
                                                          schoolFacilitiesController.validateRegister2 =
                                                              false;
                                                        }
                                                      });

                                                      if (_formKey.currentState!
                                                              .validate() &&
                                                          !schoolFacilitiesController.radioFieldError8 &&
                                                          !schoolFacilitiesController.radioFieldError9 &&
                                                          !schoolFacilitiesController.radioFieldError10 &&
                                                          !schoolFacilitiesController.validateRegister2) {
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
                                                            schoolFacilitiesController.selectedValue ?? 'No',
                                                            residentialValue:
                                                            schoolFacilitiesController.selectedValue2!,
                                                            electricityValue:
                                                            schoolFacilitiesController.selectedValue3!,
                                                            internetValue:
                                                            schoolFacilitiesController.selectedValue4!,
                                                            projectorValue:
                                                            schoolFacilitiesController.selectedValue5!,
                                                            smartClassValue:
                                                            schoolFacilitiesController.selectedValue6!,
                                                            playgroundValue:
                                                            schoolFacilitiesController.selectedValue7!,
                                                            libValue:
                                                            schoolFacilitiesController.selectedValue8!,
                                                            libLocation:
                                                            schoolFacilitiesController.selectedDesignation,
                                                            librarianTraining:
                                                            schoolFacilitiesController.selectedValue9,
                                                            libRegisterValue:
                                                            schoolFacilitiesController.selectedValue10,
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
                                                            schoolFacilitiesController.isImageUploaded = false;
                                                            schoolFacilitiesController.isImageUploaded2 = false;
                                                            schoolFacilitiesController.selectedValue3 = '';
                                                            schoolFacilitiesController.selectedValue2 = '';
                                                            schoolFacilitiesController.selectedValue = '';
                                                            schoolFacilitiesController.selectedValue4 = '';
                                                            schoolFacilitiesController.selectedValue5 = '';
                                                            schoolFacilitiesController.selectedValue6 = '';
                                                            schoolFacilitiesController.selectedValue7 = '';
                                                            schoolFacilitiesController.selectedValue8 = '';
                                                            schoolFacilitiesController.selectedValue9 = '';
                                                            schoolFacilitiesController.selectedValue10 = '';
                                                            schoolFacilitiesController.selectedDesignation = '';
                                                            schoolFacilitiesController.correctUdiseCodeController.clear();
                                                            schoolFacilitiesController.noOfFunctionalClassroomController.clear();
                                                            schoolFacilitiesController.noOfEnrolledStudentAsOnDateController.clear();
                                                            schoolFacilitiesController.nameOfLibrarianController.clear();
                                                            schoolFacilitiesController.correctUdiseCodeController.clear();



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
    // Request storage permissions (needed for Android)
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Determine the correct storage directory based on the platform
      Directory? directory;

      if (Platform.isAndroid) {
        // On Android, we use the external storage directory for files that should be accessible
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
      } else if (Platform.isIOS) {
        // On iOS, we use the documents directory
        directory = await getApplicationDocumentsDirectory();
      } else {
        // For any other platforms, we default to application documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      // Create the directory if it doesn't exist
      if (directory != null && !await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Prepare the file path with a unique identifier (timestamp)
      final path = '${directory!.path}/school_facilities_form_${data.created_at}.txt';
      print('Saving file to: $path'); // Debugging output

      // Convert the SchoolFacilitiesRecords object to a JSON string
      String jsonString = jsonEncode(data);

      // Handle Base64 conversion for images
      List<String> base64PlayImages = [];
      if (data.playImg != null) {
        for (String imagePath in data.playImg!.split(',')) {
          File imageFile = File(imagePath);
          if (await imageFile.exists()) {
            List<int> imageBytes = await imageFile.readAsBytes();
            String base64Image = base64Encode(imageBytes);
            base64PlayImages.add(base64Image);
          } else {
            print('Playground Image not found: $imagePath');
          }
        }
      }

      List<String> base64RegisterImages = [];
      if (data.imgRegister != null) {
        for (String imagePath in data.imgRegister!.split(',')) {
          File imageFile = File(imagePath);
          if (await imageFile.exists()) {
            List<int> imageBytes = await imageFile.readAsBytes();
            String base64Image = base64Encode(imageBytes);
            base64RegisterImages.add(base64Image);
          } else {
            print('Register Image not found: $imagePath');
          }
        }
      }

      // Update the school facilities data to include Base64 image strings
      Map<String, dynamic> updatedData = jsonDecode(jsonString);
      updatedData['playImg'] = base64PlayImages; // Store Base64 instead of file paths for play images
      updatedData['imgRegister'] = base64RegisterImages; // Store Base64 instead of file paths for register images

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
