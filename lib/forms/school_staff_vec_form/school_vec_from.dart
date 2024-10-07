import 'dart:convert';
import 'dart:io';
import 'package:app17000ft_new/forms/school_staff_vec_form/school_vec_controller.dart';
import 'package:app17000ft_new/forms/school_staff_vec_form/school_vec_modals.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_button.dart';
import 'package:app17000ft_new/components/custom_imagepreview.dart';
import 'package:app17000ft_new/components/custom_textField.dart';
import 'package:app17000ft_new/components/error_text.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/cab_meter_tracking_form/cab_meter_tracing_controller.dart';
import 'package:app17000ft_new/helper/responsive_helper.dart';
import 'package:app17000ft_new/tourDetails/tour_controller.dart';
import 'package:app17000ft_new/components/custom_dropdown.dart';
import 'package:app17000ft_new/components/custom_labeltext.dart';
import 'package:app17000ft_new/components/custom_sizedBox.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../base_client/base_client.dart';
import '../../components/custom_confirmation.dart';
import '../../components/custom_snackbar.dart';
import '../../helper/database_helper.dart';
import '../../home/home_screen.dart';

class SchoolStaffVecForm extends StatefulWidget {
  String? userid;
  String? office;
  String? tourId; // Add this line
  String? school; // Add this line for school
  final SchoolStaffVecRecords? existingRecord;
  SchoolStaffVecForm({
    super.key,
    this.userid,
    String? office,
    this.existingRecord,
    this.school,   this.tourId,
  });
  @override
  State<SchoolStaffVecForm> createState() => _SchoolStaffVecFormState();
}

class _SchoolStaffVecFormState extends State<SchoolStaffVecForm> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Ensure the controller is registered
    if (!Get.isRegistered<SchoolStaffVecController>()) {
      Get.put(SchoolStaffVecController());
    }

    // Get the controller instance
    final schoolStaffVecController = Get.find<SchoolStaffVecController>();

    // Check if this is in edit mode (i.e., if an existing record is provided)
    if (widget.existingRecord != null) {
      final existingRecord = widget.existingRecord!;
      print("This is edit mode: ${existingRecord.tourId.toString()}");
      print(jsonEncode(existingRecord));

      // Populate the controllers with existing data
      schoolStaffVecController.correctUdiseCodeController.text =
          existingRecord.correctUdise ?? '';
      widget.userid = existingRecord.createdBy;
      schoolStaffVecController.nameOfHoiController.text =
          existingRecord.headName ?? '';
      schoolStaffVecController.staffPhoneNumberController.text =
          existingRecord.headMobile ??
              ''; // Use mobileOfHoi for staffPhoneNumber
      schoolStaffVecController.emailController.text =
          existingRecord.headEmail ?? '';
      schoolStaffVecController.nameOfchairpersonController.text =
          existingRecord.SmcVecName ?? '';
      schoolStaffVecController.email2Controller.text =
          existingRecord.vecEmail ?? '';
      schoolStaffVecController.totalVecStaffController.text =
          existingRecord.vecTotal ?? '';
      schoolStaffVecController.chairPhoneNumberController.text =
          existingRecord.vecMobile ?? '';
      schoolStaffVecController.totalTeachingStaffController.text =
      (existingRecord.totalTeachingStaff ?? '');
      schoolStaffVecController.totalNonTeachingStaffController.text =
      (existingRecord.totalNonTeachingStaff ?? '');
      schoolStaffVecController.totalStaffController.text =
      (existingRecord.totalStaff ?? '');
      // Set other dropdown values
      schoolStaffVecController.selectedValue = existingRecord.udiseValue;
      schoolStaffVecController.selectedValue2 = existingRecord.headGender;
      schoolStaffVecController.selectedValue3 = existingRecord.genderVec;
      schoolStaffVecController.selectedDesignation = existingRecord.headDesignation;
      schoolStaffVecController.selected2Designation = existingRecord.vecQualification;
      schoolStaffVecController.selected3Designation = existingRecord.meetingDuration;
      widget.userid = existingRecord.createdBy;

      // Set other fields related to tour and school
      schoolStaffVecController.setTour(existingRecord.tourId);
      schoolStaffVecController.setSchool(existingRecord.school ?? '');
    }
  }


  final SchoolStaffVecController schoolStaffVecController =
  Get.put(SchoolStaffVecController());

  void updateTotalStaff() {
    final totalTeachingStaff = int.tryParse(
        schoolStaffVecController.totalTeachingStaffController.text) ??
        0;
    final totalNonTeachingStaff = int.tryParse(
        schoolStaffVecController.totalNonTeachingStaffController.text) ??
        0;
    final totalStaff = totalTeachingStaff + totalNonTeachingStaff;

    schoolStaffVecController.totalStaffController.text = totalStaff.toString();
  }



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
            title: 'School Staff & SMC/VEC Details',
          ),
          body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Column(children: [
                    GetBuilder<SchoolStaffVecController>(
                        init: SchoolStaffVecController(),
                        builder: (schoolStaffVecController) {
                          return Form(
                              key: _formKey,
                              child:GetBuilder<TourController>(
                                  init: TourController(),
                                  builder: (tourController) {
                                    // Fetch tour details once, not on every rebuild.
                                    if (tourController.getLocalTourList.isEmpty) {
                                      tourController.fetchTourDetails();
                                    }

                                    return Column(children: [
                                      if (schoolStaffVecController.showBasicDetails) ...[
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
                                          focusNode: schoolStaffVecController.tourIdFocusNode,
                                          options: tourController.getLocalTourList
                                              .map((e) => e.tourId!) // Ensure tourId is non-nullable
                                              .toList(),
                                          selectedOption: schoolStaffVecController.tourValue,
                                          onChanged: (value) {
                                            // Safely handle the school list splitting by commas
                                            schoolStaffVecController.splitSchoolLists = tourController
                                                .getLocalTourList
                                                .where((e) => e.tourId == value)
                                                .map((e) => e.allSchool!.split(',').map((s) => s.trim()).toList())
                                                .expand((x) => x)
                                                .toList();

                                            // Single setState call for efficiency
                                            setState(() {
                                              schoolStaffVecController.setSchool(null);
                                              schoolStaffVecController.setTour(value);
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
                                          items: schoolStaffVecController.splitSchoolLists, // Split school list as strings
                                          dropdownDecoratorProps: const DropDownDecoratorProps(
                                            dropdownSearchDecoration: InputDecoration(
                                              labelText: "Select School",
                                              hintText: "Select School",
                                            ),
                                          ),
                                          onChanged: (value) {
                                            // Set the selected school
                                            setState(() {
                                              schoolStaffVecController.setSchool(value);
                                            });
                                          },
                                          selectedItem: schoolStaffVecController.schoolValue,
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
                                          padding:
                                          const EdgeInsets.only(right: 300),
                                          child: Row(
                                            children: [
                                              Radio(
                                                value: 'Yes',
                                                groupValue: schoolStaffVecController.selectedValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    schoolStaffVecController.selectedValue =
                                                    value as String?;
                                                  });
                                                  if (value == 'Yes') {
                                                    schoolStaffVecController.correctUdiseCodeController.clear();

                                                  }
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
                                          padding:
                                          const EdgeInsets.only(right: 300),
                                          child: Row(
                                            children: [
                                              Radio(
                                                value: 'No',
                                                groupValue: schoolStaffVecController.selectedValue,
                                                onChanged: (value) {
                                                  setState(() {
                                                    schoolStaffVecController.selectedValue =
                                                    value as String?;
                                                  });
                                                },
                                              ),
                                              const Text('No'),
                                            ],
                                          ),
                                        ),
                                        if (schoolStaffVecController.radioFieldError)
                                          const Padding(
                                            padding:
                                            EdgeInsets.only(left: 16.0),
                                            child: Align(
                                              alignment: Alignment.centerLeft,
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
                                        if (schoolStaffVecController.selectedValue == 'No') ...[
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
                                            schoolStaffVecController
                                                .correctUdiseCodeController,
                                            textInputType: TextInputType.number,
                                            inputFormatters: [
                                              LengthLimitingTextInputFormatter(
                                                  13),
                                              FilteringTextInputFormatter
                                                  .digitsOnly,
                                            ],                                            labelText:
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
                                            print('submit Basic Details');
                                            setState(() {
                                              schoolStaffVecController.radioFieldError =
                                                  schoolStaffVecController.selectedValue == null ||
                                                      schoolStaffVecController.selectedValue!.isEmpty;
                                            });

                                            if (_formKey.currentState!
                                                .validate() &&
                                                !schoolStaffVecController.radioFieldError) {
                                              setState(() {
                                                schoolStaffVecController.showBasicDetails = false;
                                                schoolStaffVecController.showStaffDetails = true;
                                              });
                                            }
                                          },
                                        ),

                                        CustomSizedBox(
                                          value: 20,
                                          side: 'height',
                                        ),
                                      ],
                                      // End of Basic Details

                                      //start of staff Details
                                      if (schoolStaffVecController.showStaffDetails) ...[
                                        LabelText(
                                          label: 'Staff Details',
                                        ),
                                        CustomSizedBox(
                                          value: 20,
                                          side: 'height',
                                        ),
                                        LabelText(
                                          label: 'Name Of Head Of Institute',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(
                                            value: 20, side: 'height'),
                                        CustomTextFormField(
                                          textController:
                                          schoolStaffVecController
                                              .nameOfHoiController,
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
                                          label: 'Gender',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(
                                            value: 20, side: 'height'),

                                        // Wrapping in a LayoutBuilder to adjust based on available width
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 'Male',
                                                      groupValue:
                                                      schoolStaffVecController.selectedValue2,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          schoolStaffVecController.selectedValue2 =
                                                          value as String?;
                                                          schoolStaffVecController.radioFieldError2 =
                                                          false; // Reset error state
                                                        });
                                                      },
                                                    ),
                                                    const Text('Male'),
                                                  ],
                                                ),
                                                SizedBox(
                                                    width: screenWidth *
                                                        0.1), // Adjust spacing based on screen width
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 'Female',
                                                      groupValue:
                                                      schoolStaffVecController.selectedValue2,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          schoolStaffVecController.selectedValue2 =
                                                          value as String?;
                                                          schoolStaffVecController.radioFieldError2 =
                                                          false; // Reset error state
                                                        });
                                                      },
                                                    ),
                                                    const Text('Female'),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        ),

                                        if (schoolStaffVecController.radioFieldError2)
                                          const Padding(
                                            padding:
                                            EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              'Please select an option',
                                              style:
                                              TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        CustomSizedBox(
                                            value: 20, side: 'height'),

                                        LabelText(
                                          label: 'Mobile Number',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(
                                          value: 20,
                                          side: 'height',
                                        ),
                                        CustomTextFormField(
                                          textController:
                                          schoolStaffVecController
                                              .staffPhoneNumberController,
                                          labelText: 'Enter Mobile Number',
                                          textInputType: TextInputType.number,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                10),
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please Enter Mobile';
                                            }

                                            // Regex for validating Indian phone number
                                            String pattern = r'^[6-9]\d{9}$';
                                            RegExp regex = RegExp(pattern);

                                            if (!regex.hasMatch(value)) {
                                              return 'Enter a valid Mobile number';
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
                                          label: 'Email ID',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(
                                          value: 20,
                                          side: 'height',
                                        ),
                                        CustomTextFormField(
                                          textController:
                                          schoolStaffVecController
                                              .emailController,
                                          labelText: 'Enter Email',
                                          textInputType:
                                          TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Email';
                                            }

                                            // Regular expression for validating email
                                            final emailRegex = RegExp(
                                              r'^[^@]+@[^@]+\.[^@]+$',
                                              caseSensitive: false,
                                            );

                                            if (!emailRegex.hasMatch(value)) {
                                              return 'Please Enter a Valid Email Address';
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
                                          label: 'Designation',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(
                                            value: 20, side: 'height'),
                                        DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            labelText: 'Select a designation',
                                            border: OutlineInputBorder(),
                                          ),
                                          value: schoolStaffVecController.selectedDesignation,
                                          items: [
                                            DropdownMenuItem(
                                                value: 'HeadMaster/ HeadMistress',
                                                child: Text('HeadMaster/HeadMistress')),
                                            DropdownMenuItem(
                                                value: 'Principal',
                                                child: Text('Principal')),
                                            DropdownMenuItem(
                                                value: 'Incharge',
                                                child: Text('Incharge')),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              schoolStaffVecController.selectedDesignation = value;
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
                                          'Total Teaching Staff (Including Head Of Institute)',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(value: 20, side: 'height'),
                                        CustomTextFormField(
                                          textController: schoolStaffVecController
                                              .totalTeachingStaffController,
                                          labelText: 'Enter Teaching Staff',
                                          textInputType: TextInputType.number,

                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please Enter Number';
                                            }
                                            return null;
                                          },
                                          showCharacterCount: true,
                                          onChanged: (value) =>
                                              updateTotalStaff(), // Update total staff when this field changes
                                        ),

                                        CustomSizedBox(
                                            value: 20, side: 'height'),
                                        LabelText(
                                          label: 'Total Non Teaching Staff',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(value: 20, side: 'height'),
                                        CustomTextFormField(
                                          textController: schoolStaffVecController
                                              .totalNonTeachingStaffController,
                                          labelText: 'Enter Teaching Staff',
                                          textInputType: TextInputType.number,

                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please Enter Number';
                                            }
                                            return null;
                                          },
                                          showCharacterCount: true,
                                          onChanged: (value) =>
                                              updateTotalStaff(), // Update total staff when this field changes
                                        ),

                                        CustomSizedBox(
                                            value: 20, side: 'height'),
                                        LabelText(
                                          label: 'Total Staff',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(value: 20, side: 'height'),
                                        CustomTextFormField(
                                          textController:
                                          schoolStaffVecController.totalStaffController,
                                          labelText: 'Enter Teaching Staff',

                                          showCharacterCount: true,
                                          readOnly: true, // Make this field read-only
                                        ),

                                        CustomSizedBox(
                                            value: 20, side: 'height'),
                                        Row(
                                          children: [
                                            CustomButton(
                                                title: 'Back',
                                                onPressedButton: () {
                                                  setState(() {
                                                    schoolStaffVecController.showBasicDetails = true;
                                                    schoolStaffVecController.showStaffDetails = false;
                                                    false;
                                                  });
                                                }),
                                            const Spacer(),
                                            CustomButton(
                                              title: 'Next',
                                              onPressedButton: () {

                                                print('submit staff details');
                                                setState(() {
                                                  schoolStaffVecController.radioFieldError2 =
                                                      schoolStaffVecController.selectedValue2 == null ||
                                                          schoolStaffVecController.selectedValue2!
                                                              .isEmpty;
                                                });

                                                if (_formKey.currentState!
                                                    .validate() &&
                                                    !schoolStaffVecController.radioFieldError2) {
                                                  setState(() {
                                                    schoolStaffVecController.showStaffDetails = false;
                                                    schoolStaffVecController.showSmcVecDetails = true;
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
                                      ], //end of staff details

                                      // start of staff vec details
                                      if (schoolStaffVecController.showSmcVecDetails) ...[
                                        LabelText(
                                          label: 'SMC VEC Details',
                                        ),
                                        CustomSizedBox(
                                          value: 20,
                                          side: 'height',
                                        ),
                                        LabelText(
                                          label: 'Name Of SMC/VEC chairperson',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(
                                            value: 20, side: 'height'),
                                        CustomTextFormField(
                                          textController:
                                          schoolStaffVecController
                                              .nameOfchairpersonController,
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
                                          label: 'Gender',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(value: 20, side: 'height'),

                                        // Wrapping in a LayoutBuilder to adjust based on available width
                                        LayoutBuilder(
                                          builder: (context, constraints) {
                                            return Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 'Male',
                                                      groupValue: schoolStaffVecController.selectedValue3,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          schoolStaffVecController.selectedValue3 = value as String?;
                                                          schoolStaffVecController.radioFieldError3 = false; // Reset error state
                                                        });
                                                      },
                                                    ),
                                                    const Text('Male'),
                                                  ],
                                                ),
                                                SizedBox(width: screenWidth * 0.1), // Adjust spacing based on screen width
                                                Row(
                                                  children: [
                                                    Radio(
                                                      value: 'Female',
                                                      groupValue: schoolStaffVecController.selectedValue3,
                                                      onChanged: (value) {
                                                        setState(() {
                                                          schoolStaffVecController.selectedValue3 = value as String?;
                                                          schoolStaffVecController.radioFieldError3 = false; // Reset error state
                                                        });
                                                      },
                                                    ),
                                                    const Text('Female'),
                                                  ],
                                                ),
                                              ],
                                            );
                                          },
                                        ),

                                        if (schoolStaffVecController.radioFieldError3)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8.0),
                                            child: const Text(
                                              'Please select an option',
                                              style: TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        CustomSizedBox(value: 20, side: 'height'),

                                        CustomSizedBox(
                                          value: 20,
                                          side: 'height',
                                        ),
                                        LabelText(
                                          label: 'Mobile Number',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(
                                          value: 20,
                                          side: 'height',
                                        ),
                                        CustomTextFormField(
                                          textController:
                                          schoolStaffVecController
                                              .chairPhoneNumberController,
                                          labelText: 'Enter Mobile Number',
                                          textInputType: TextInputType.number,
                                          inputFormatters: [
                                            LengthLimitingTextInputFormatter(
                                                10),
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                          ],
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Please Enter Mobile';
                                            }

                                            // Regex for validating Indian phone number
                                            String pattern = r'^[6-9]\d{9}$';
                                            RegExp regex = RegExp(pattern);

                                            if (!regex.hasMatch(value)) {
                                              return 'Enter a valid Mobile number';
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
                                          label: 'Email ID',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(
                                          value: 20,
                                          side: 'height',
                                        ),
                                        CustomTextFormField(
                                          textController:
                                          schoolStaffVecController
                                              .email2Controller,
                                          labelText: 'Enter Email',
                                          textInputType:
                                          TextInputType.emailAddress,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please Enter Email';
                                            }

                                            // Regular expression for validating email
                                            final emailRegex = RegExp(
                                              r'^[^@]+@[^@]+\.[^@]+$',
                                              caseSensitive: false,
                                            );

                                            if (!emailRegex.hasMatch(value)) {
                                              return 'Please Enter a Valid Email Address';
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
                                          label:
                                          'Highest Education Qualification',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(
                                            value: 20, side: 'height'),
                                        DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            labelText: 'Select qualification',
                                            border: OutlineInputBorder(),
                                          ),
                                          value: schoolStaffVecController.selected2Designation,
                                          items: [
                                            DropdownMenuItem(
                                                value: 'Non Graduate',
                                                child: Text('Non Graduate')),
                                            DropdownMenuItem(
                                                value: 'Graduate',
                                                child: Text('Graduate')),
                                            DropdownMenuItem(
                                                value: 'Post Graduate',
                                                child: Text('Post Graduate')),
                                            DropdownMenuItem(
                                                value: 'Other',
                                                child: Text('Others')),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              schoolStaffVecController.selected2Designation = value;
                                            });
                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select a qualification';
                                            }
                                            return null;
                                          },
                                        ),
                                        CustomSizedBox(
                                            value: 20, side: 'height'),

                                    if (schoolStaffVecController.selected2Designation ==
                                    'Others') ...[
                                    LabelText(
                                    label: 'Please Specify Other',
                                    astrick: true,
                                    ),
                                    CustomSizedBox(
                                    value: 20, side: 'height'),
                                    CustomTextFormField(
                                    textController:
                                    schoolStaffVecController
                                        .QualSpecifyController,
                                    labelText: 'Write here...',
                                    maxlines: 2,
                                    validator: (value) {
                                    if (value!.isEmpty) {
                                    return 'Please fill this field';
                                    }

                                    if (value.length < 25) {
                                    return 'Must be at least 25 characters long';
                                    }
                                    return null;
                                    },
                                    showCharacterCount: true,
                                    ),
                                        ],
                                        LabelText(
                                          label: 'Total SMC VEC Staff',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(
                                            value: 20, side: 'height'),
                                        CustomTextFormField(
                                          textController:
                                          schoolStaffVecController
                                              .totalVecStaffController,
                                          labelText:
                                          'Enter Total SMC VEC member',
                                          textInputType: TextInputType.number,
                                          validator: (value) {
                                            if (value!.isEmpty) {
                                              return 'Write Number';
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
                                          label:
                                          'How often does the school hold an SMC/VEC meeting',
                                          astrick: true,
                                        ),
                                        CustomSizedBox(
                                            value: 20, side: 'height'),
                                        DropdownButtonFormField<String>(
                                          decoration: InputDecoration(
                                            labelText: 'Select frequency',
                                            border: OutlineInputBorder(),
                                          ),
                                          value: schoolStaffVecController.selected3Designation,
                                          items: [
                                            DropdownMenuItem(
                                                value: 'Once a month',
                                                child: Text('Once a month')),
                                            DropdownMenuItem(
                                                value: 'Once a quarter',
                                                child: Text('Once a quarter')),
                                            DropdownMenuItem(
                                                value: 'Once in 6 months',
                                                child: Text('Once in 6 months')),
                                            DropdownMenuItem(
                                                value: 'Once a year',
                                                child: Text('Once a year')),
                                            DropdownMenuItem(
                                                value: 'Other',
                                                child: Text('Others')),
                                          ],
                                          onChanged: (value) {
                                            setState(() {
                                              schoolStaffVecController.selected3Designation = value;

                                            });

                                          },
                                          validator: (value) {
                                            if (value == null) {
                                              return 'Please select a frequency';
                                            }
                                            return null;
                                          },
                                        ),
                                        CustomSizedBox(
                                            value: 20, side: 'height'),
                                        if (schoolStaffVecController.selected3Designation ==
                                            'Other') ...[
                                          LabelText(
                                            label: 'Please Specify Other',
                                            astrick: true,
                                          ),
                                          CustomSizedBox(
                                              value: 20, side: 'height'),
                                          CustomTextFormField(
                                            textController:
                                            schoolStaffVecController
                                                .QualSpecify2Controller,
                                            labelText: 'Write here...',
                                            maxlines: 2,
                                            validator: (value) {
                                              if (value!.isEmpty) {
                                                return 'Please fill this field';
                                              }

                                              if (value.length < 25) {
                                                return 'Must be at least 25 characters long';
                                              }
                                              return null;
                                            },
                                            showCharacterCount: true,
                                          ),
                                        ],
                                        Row(
                                          children: [
                                            CustomButton(
                                                title: 'Back',
                                                onPressedButton: () {
                                                  setState(() {
                                                    schoolStaffVecController.showStaffDetails = true;
                                                    schoolStaffVecController.showSmcVecDetails = false;
                                                  });
                                                }),
                                            const Spacer(),
                                            CustomButton(
                                                title: 'Submit',
                                                onPressedButton: () async {

                                                  setState(() {
                                                    schoolStaffVecController.radioFieldError3 =
                                                        schoolStaffVecController.selectedValue3 ==
                                                            null ||
                                                            schoolStaffVecController.selectedValue3!
                                                                .isEmpty;
                                                  });
                                                  if (_formKey.currentState!
                                                      .validate() &&
                                                      !schoolStaffVecController.radioFieldError3) {
                                                    print('Submit Vec Details');

                                                    DateTime now =
                                                    DateTime.now();
                                                    String formattedDate =
                                                    DateFormat('yyyy-MM-dd')
                                                        .format(now);
                                                    SchoolStaffVecRecords enrolmentCollectionObj = SchoolStaffVecRecords(
                                                        tourId: schoolStaffVecController.tourValue ??
                                                            '',
                                                        school: schoolStaffVecController.schoolValue ??
                                                            '',
                                                        udiseValue: schoolStaffVecController.selectedValue!,
                                                        correctUdise: schoolStaffVecController
                                                            .correctUdiseCodeController
                                                            .text,
                                                        headName: schoolStaffVecController
                                                            .nameOfHoiController.text,
                                                        headMobile: schoolStaffVecController
                                                            .staffPhoneNumberController
                                                            .text,
                                                        headEmail: schoolStaffVecController
                                                            .emailController.text,
                                                        totalTeachingStaff:
                                                        schoolStaffVecController
                                                            .totalTeachingStaffController
                                                            .text,
                                                        totalNonTeachingStaff:
                                                        schoolStaffVecController
                                                            .totalNonTeachingStaffController
                                                            .text,
                                                        totalStaff: schoolStaffVecController
                                                            .totalStaffController.text,
                                                        vecMobile: schoolStaffVecController.chairPhoneNumberController.text,
                                                        vecEmail: schoolStaffVecController.email2Controller.text,
                                                        vecTotal: schoolStaffVecController.totalVecStaffController.text,
                                                        otherQual: schoolStaffVecController.QualSpecifyController.text,
                                                        other: schoolStaffVecController.QualSpecify2Controller.text,
                                                        SmcVecName: schoolStaffVecController.nameOfchairpersonController.text,
                                                        headGender: schoolStaffVecController.selectedValue2!,
                                                        genderVec: schoolStaffVecController.selectedValue3!,
                                                        headDesignation: schoolStaffVecController.selectedDesignation!,
                                                        meetingDuration: schoolStaffVecController.selected3Designation!,
                                                        vecQualification: schoolStaffVecController.selected2Designation!,
                                                        createdAt: formattedDate.toString(),
                                                        createdBy: widget.userid.toString());



                                                    int result =
                                                    await LocalDbController()
                                                        .addData(
                                                        schoolStaffVecRecords:
                                                        enrolmentCollectionObj);
                                                    if (result > 0) {
                                                      schoolStaffVecController
                                                          .clearFields();
                                                      setState(() {
                                                        // Clear the image list
                                                        schoolStaffVecController.selectedValue = '';
                                                        schoolStaffVecController.selectedValue2 = '';
                                                        schoolStaffVecController.selectedValue3 = '';
                                                        schoolStaffVecController.correctUdiseCodeController.clear();
                                                        schoolStaffVecController.nameOfHoiController.clear();
                                                        schoolStaffVecController.staffPhoneNumberController.clear();
                                                        schoolStaffVecController.emailController.clear();
                                                        schoolStaffVecController.totalTeachingStaffController.clear();
                                                        schoolStaffVecController.totalNonTeachingStaffController.clear();
                                                        schoolStaffVecController.totalStaffController.clear();
                                                        schoolStaffVecController.nameOfchairpersonController.clear();
                                                        schoolStaffVecController.chairPhoneNumberController.clear();
                                                        schoolStaffVecController.totalVecStaffController.clear();
                                                        schoolStaffVecController.email2Controller.clear();
                                                        schoolStaffVecController.QualSpecifyController.clear();
                                                        schoolStaffVecController.QualSpecify2Controller.clear();
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
                                                          AppColors.onPrimary,
                                                          Icons.verified);

                                                      // Navigate to HomeScreen
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                            const HomeScreen()),
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
                                      ] // End of staff vec details
                                    ]);
                                  }));
                        })
                  ])))),
    );
  }
}


Future<void> saveDataToFile(SchoolStaffVecRecords data) async {
  try {
    // Request storage permissions (required for Android)
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // Determine the correct storage directory based on the platform
      Directory? directory;

      if (Platform.isAndroid) {
        // On Android, use external storage directory (typically for downloads)
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
        // On iOS, use the application documents directory
        directory = await getApplicationDocumentsDirectory();
      } else {
        // For any other platforms, we use the application documents directory
        directory = await getApplicationDocumentsDirectory();
      }

      // Create the directory if it doesn't exist
      if (directory != null && !await directory.exists()) {
        await directory.create(recursive: true);
      }

      // Construct the file path using a unique identifier (`createdBy`)
      final path = '${directory!.path}/school_vec_form_${data.createdBy}.txt';

      // Convert the SchoolStaffVecRecords object to a JSON string
      String jsonString = jsonEncode(data);

      // Write the JSON string to a file
      File file = File(path);
      await file.writeAsString(jsonString);

      // Log the success message
      print('Data saved to $path');
    } else {
      // Handle the case where storage permission is not granted
      print('Storage permission not granted');
    }
  } catch (e) {
    // Handle any errors that occur during the file saving process
    print('Error saving data: $e');
  }
}
