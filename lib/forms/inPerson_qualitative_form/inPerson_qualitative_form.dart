import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:path_provider/path_provider.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_button.dart';
import 'package:app17000ft_new/components/custom_imagepreview.dart';
import 'package:app17000ft_new/components/custom_snackbar.dart';
import 'package:app17000ft_new/components/custom_textField.dart';
import 'package:app17000ft_new/components/error_text.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'dart:math';
import 'package:app17000ft_new/helper/responsive_helper.dart';
import 'package:app17000ft_new/tourDetails/tour_controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';

import 'package:intl/intl.dart';
import 'package:get/get.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:app17000ft_new/components/custom_dropdown.dart';
import 'package:app17000ft_new/components/custom_labeltext.dart';
import 'package:app17000ft_new/components/custom_sizedBox.dart';

import 'package:app17000ft_new/home/home_screen.dart';

import '../../components/custom_confirmation.dart';
import '../../helper/database_helper.dart';
import 'inPerson_qualitative_controller.dart';
import 'inPerson_qualitative_modal.dart';

class InPersonQualitativeForm extends StatefulWidget {
  String? userid;
  String? office;
  InPersonQualitativeForm({
    super.key,
    this.userid,
    this.office,
  });

  @override
  State<InPersonQualitativeForm> createState() =>
      _InPersonQualitativeFormState();
}

class _InPersonQualitativeFormState extends State<InPersonQualitativeForm> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> splitSchoolLists = [];

  // Start of Showing
  bool showBasicDetails = true; // For show Basic Details
  bool showInputs = false; // For show Inputs Details
  bool showSchoolTeacher = false; // For show showSchoolTeacher
  bool showInputStudents = false; // For show showInputStudents
  bool showSmcMember = false; // For show showSmcMember
  // End of Showing
  bool _isImageUploadedSchoolBoard = false;
  bool validateSchoolBoard = false;

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
              title: 'In-Person Qualitative',
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(children: [
                      GetBuilder<InpersonQualitativeController>(
                          init: InpersonQualitativeController(),
                          builder: (inpersonQualitativeController) {
                            return Form(
                                key: _formKey,
                                child: GetBuilder<TourController>(
                                    init: TourController(),
                                    builder: (tourController) {
                                      tourController.fetchTourDetails();
                                      return Column(children: [
                                        // Start of Basic Details
                                        if (showBasicDetails) ...[
                                          LabelText(label: 'Basic Details'),
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
                                              focusNode:
                                                  inpersonQualitativeController
                                                      .tourIdFocusNode,
                                              options: tourController
                                                  .getLocalTourList
                                                  .map((e) => e.tourId!)
                                                  .toList(),
                                              selectedOption:
                                                  inpersonQualitativeController
                                                      .tourValue,
                                              onChanged: (value) {
                                                splitSchoolLists =
                                                    tourController
                                                        .getLocalTourList
                                                        .where((e) =>
                                                            e.tourId == value)
                                                        .map((e) => e.allSchool!
                                                            .split('|')
                                                            .toList())
                                                        .expand((x) => x)
                                                        .toList();
                                                setState(() {
                                                  inpersonQualitativeController
                                                      .setSchool(null);
                                                  inpersonQualitativeController
                                                      .setTour(value);
                                                });
                                              },
                                              labelText: "Select Tour ID"),
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
                                          DropdownSearch<String>(
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return "Please Select School";
                                              }
                                              return null;
                                            },
                                            popupProps: PopupProps.menu(
                                              showSelectedItems: true,
                                              showSearchBox: true,
                                              disabledItemFn: (String s) =>
                                                  s.startsWith('I'),
                                            ),
                                            items: splitSchoolLists,
                                            dropdownDecoratorProps:
                                                const DropDownDecoratorProps(
                                              dropdownSearchDecoration:
                                                  InputDecoration(
                                                labelText: "Select School",
                                                hintText: "Select School ",
                                              ),
                                            ),
                                            onChanged: (value) {
                                              setState(() {
                                                inpersonQualitativeController
                                                    .setSchool(value);
                                              });
                                            },
                                            selectedItem:
                                                inpersonQualitativeController
                                                    .schoolValue,
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
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'udiCode'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'udiCode', value);
                                                    if (value == 'Yes') {

                                                      inpersonQualitativeController.correctUdiseCodeController.clear();


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
                                            padding: const EdgeInsets.only(
                                                right: 300),
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: 'No',
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'udiCode'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'udiCode', value);
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (inpersonQualitativeController
                                              .getRadioFieldError('udiCode'))
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
                                          if (inpersonQualitativeController
                                                  .getSelectedValue(
                                                      'udiCode') ==
                                              'No') ...[
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
                                                  inpersonQualitativeController
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
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                          ],
                                          LabelText(
                                            label:
                                                'Click Image of School Board',
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
                                                  BorderRadius.circular(10.0),
                                              border: Border.all(
                                                  width: 2,
                                                  color:
                                                      _isImageUploadedSchoolBoard ==
                                                              false
                                                          ? AppColors.primary
                                                          : AppColors.error),
                                            ),
                                            child: ListTile(
                                                title:
                                                    _isImageUploadedSchoolBoard ==
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
                                                    color:
                                                        AppColors.onBackground),
                                                onTap: () {
                                                  showModalBottomSheet(
                                                      backgroundColor:
                                                          AppColors.primary,
                                                      context: context,
                                                      builder: ((builder) =>
                                                          inpersonQualitativeController
                                                              .bottomSheet(
                                                                  context)));
                                                }),
                                          ),
                                          ErrorText(
                                            isVisible: validateSchoolBoard,
                                            message: 'Register Image Required',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),

                                          inpersonQualitativeController
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
                                                        BorderRadius.circular(
                                                            10),
                                                  ),
                                                  child:
                                                      inpersonQualitativeController
                                                              .multipleImage
                                                              .isEmpty
                                                          ? const Center(
                                                              child: Text(
                                                                  'No images selected.'),
                                                            )
                                                          : ListView.builder(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount:
                                                                  inpersonQualitativeController
                                                                      .multipleImage
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                return SizedBox(
                                                                  height: 200,
                                                                  width: 200,
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .all(
                                                                            8.0),
                                                                        child:
                                                                            GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            CustomImagePreview.showImagePreview(inpersonQualitativeController.multipleImage[index].path,
                                                                                context);
                                                                          },
                                                                          child:
                                                                              Image.file(
                                                                            File(inpersonQualitativeController.multipleImage[index].path),
                                                                            width:
                                                                                190,
                                                                            height:
                                                                                120,
                                                                            fit:
                                                                                BoxFit.fill,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            inpersonQualitativeController.multipleImage.removeAt(index);
                                                                          });
                                                                        },
                                                                        child:
                                                                            const Icon(
                                                                          Icons
                                                                              .delete,
                                                                          color:
                                                                              Colors.red,
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
                                            value: 20,
                                            side: 'height',
                                          ),
                                          LabelText(
                                            label:
                                                'Does this school have DigiLab?',
                                            astrick: true,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 300),
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: 'Yes',
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'schoolDigiLab'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'schoolDigiLab',
                                                            value);
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
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'schoolDigiLab'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'schoolDigiLab',
                                                            value);
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (inpersonQualitativeController
                                              .getRadioFieldError(
                                                  'schoolDigiLab'))
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
                                          LabelText(
                                            label:
                                                'Does this school have Library?',
                                            astrick: true,
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 300),
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: 'Yes',
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'schoolLibrary'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'schoolLibrary',
                                                            value);
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
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'schoolLibrary'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'schoolLibrary',
                                                            value);
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (inpersonQualitativeController
                                              .getRadioFieldError(
                                                  'schoolLibrary'))
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
                                          LabelText(
                                            label:
                                                'Does this school have Playground?',
                                            astrick: true,
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 300),
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: 'Yes',
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'schoolPlayground'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'schoolPlayground',
                                                            value);
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
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'schoolPlayground'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'schoolPlayground',
                                                            value);
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (inpersonQualitativeController
                                              .getRadioFieldError(
                                                  'schoolPlayground'))
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

                                          CustomButton(
                                            title: 'Next',
                                            onPressedButton: () {
                                              // Perform radio button validations
                                              final isRadioValid1 =
                                                  inpersonQualitativeController
                                                      .validateRadioSelection(
                                                          'udiCode');
                                              final isRadioValid2 =
                                                  inpersonQualitativeController
                                                      .validateRadioSelection(
                                                          'schoolDigiLab');
                                              final isRadioValid3 =
                                                  inpersonQualitativeController
                                                      .validateRadioSelection(
                                                          'schoolLibrary');
                                              final isRadioValid4 =
                                                  inpersonQualitativeController
                                                      .validateRadioSelection(
                                                          'schoolPlayground');

                                              // Update the state for validateSchoolBoard based on _isImageUploadedSchoolBoard
                                              setState(() {
                                                validateSchoolBoard =
                                                    inpersonQualitativeController
                                                        .multipleImage.isEmpty;
                                              });

                                              if (_formKey.currentState!
                                                      .validate() &&
                                                  !validateSchoolBoard && // Ensure that at least one image is uploaded
                                                  isRadioValid1 &&
                                                  isRadioValid2 &&
                                                  isRadioValid3 &&
                                                  isRadioValid4) {
                                                setState(() {
                                                  // Proceed with the next step
                                                  showBasicDetails = false;
                                                  showInputs = true;
                                                });
                                              }
                                            },
                                          ),

                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                        ], // End of Basic Details

                                        // Show Inputs HM/In charge

                                        if (showInputs) ...[
                                          LabelText(
                                            label:
                                                'Qualitative Inputs HM/ In Charge',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          LabelText(
                                            label:
                                                'Were you able to Interview HM/In charge?',
                                            astrick: true,
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 300),
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: 'Yes',
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'HmIncharge'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'HmIncharge',
                                                            value);
                                                    if (value == 'Yes') {

                                                      inpersonQualitativeController.notAbleController.clear();

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
                                            padding: const EdgeInsets.only(
                                                right: 300),
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: 'No',
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'HmIncharge'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'HmIncharge',
                                                            value);
                                                    if (value == 'No') {

                                                      inpersonQualitativeController.schoolRoutineController.clear();
                                                      inpersonQualitativeController.componentsController.clear();
                                                      inpersonQualitativeController.programInitiatedController.clear();
                                                      inpersonQualitativeController.digiLabSessionController.clear();
                                                      inpersonQualitativeController.alexaEchoController.clear();
                                                      inpersonQualitativeController.servicesController.clear();
                                                      inpersonQualitativeController.suggestionsController.clear();
                                                      inpersonQualitativeController.allowingTabletsController.clear();
                                                      inpersonQualitativeController.alexaSessionsController.clear();
                                                      inpersonQualitativeController.playgroundAllowedController.clear();
                                                      inpersonQualitativeController.improveProgramController.clear();


                                                    }

                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (inpersonQualitativeController
                                              .getRadioFieldError('HmIncharge'))
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

                                          if (inpersonQualitativeController
                                                  .getSelectedValue(
                                                      'HmIncharge') ==
                                              'Yes') ...[

                                      if (inpersonQualitativeController
                                          .getSelectedValue(
                                      'schoolDigiLab') ==
                                      'Yes') ...[

                                            LabelText(
                                              label:
                                                  '1. What challenges does the school face in integrating the DigiLab sessions with the normal school routine?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .schoolRoutineController,
                                              labelText: 'Write here...',
                                              maxlines: 2,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            ],
                                            LabelText(
                                              label:
                                                  '2. What difficulties do teachers and students face in effectively using the program components? ',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .componentsController,
                                              labelText: 'Write here...',
                                              maxlines: 2,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '3. What are the changes (positive or negative) observed in teachers or students since the program was initiated? ',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .programInitiatedController,
                                              labelText: 'Write here...',
                                              maxlines: 2,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                      if (inpersonQualitativeController
                                          .getSelectedValue(
                                      'schoolDigiLab') ==
                                      'Yes') ...[
                                            LabelText(
                                              label:
                                                  '4. Have any steps been taken to encourage DigiLab sessions and its activities? ',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .digiLabSessionController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            ],
                                            LabelText(
                                              label:
                                                  '5. Has there been any improvement n learning levels (DigiLab), reading levels (Library) or communication skills (Alexa Echo)? ',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .alexaEchoController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '6. What feedback has been received from parents about these new services in the school? ',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .servicesController,
                                              labelText: 'Write here...',
                                              maxlines: 2,
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '6.1 Are there any suggestions they have made?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .suggestionsController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                      if (inpersonQualitativeController
                                          .getSelectedValue(
                                      'schoolDigiLab') ==
                                      'Yes') ...[
                                            LabelText(
                                              label:
                                                  '7. Are you open to allowing students to take DigiLab tablets home with them for "at home learning"? If no,why not?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .allowingTabletsController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            ],
                                            LabelText(
                                              label:
                                                  '8. How often are children allowed to play in the playground? Is there any schedule/timetable for this?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .playgroundAllowedController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '9. What challenges is the school facing, if any, in implementing the library/DigiLab/Alexa sessions?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .alexaSessionsController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '10. Are there any suggestions/feedback to further improve the program?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .improveProgramController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                          ],
                                          if (inpersonQualitativeController
                                                  .getSelectedValue(
                                                      'HmIncharge') ==
                                              'No') ...[
                                            LabelText(
                                              label:
                                                  'Why were you not able to interview HM/In charge',
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .notAbleController,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 25) {
                                                  return 'Must be at least 25 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
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
                                                      showInputs = false;
                                                    });
                                                  }),
                                              const Spacer(),
                                              CustomButton(
                                                title: 'Next',
                                                onPressedButton: () {
                                                  final isRadioValid5 =
                                                      inpersonQualitativeController
                                                          .validateRadioSelection(
                                                              'HmIncharge');

                                                  if (_formKey.currentState!
                                                          .validate() &&
                                                      isRadioValid5) {
                                                    // Include image validation here
                                                    setState(() {
                                                      showInputs = false;
                                                      showSchoolTeacher = true;
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          ),

                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                        ], // End Inputs HM/In charge

                                        // Start of showSchoolTeacher

                                        if (showSchoolTeacher) ...[
                                          LabelText(
                                            label:
                                                'Qualitative Inputs School Teachers',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          LabelText(
                                            label:
                                                'Were you able to interview School Teachers?',
                                            astrick: true,
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 300),
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: 'Yes',
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'schoolTeacherInterview'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'schoolTeacherInterview',
                                                            value);
                                                    if (value == 'Yes') {

                                                      inpersonQualitativeController.notAbleTeacherInterviewController.clear();

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
                                            padding: const EdgeInsets.only(
                                                right: 300),
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: 'No',
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'schoolTeacherInterview'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'schoolTeacherInterview',
                                                            value);
                                                    if (value == 'No') {

                                                      inpersonQualitativeController.operatingDigiLabController.clear();
                                                      inpersonQualitativeController.difficultiesController.clear();
                                                      inpersonQualitativeController.improvementController.clear();
                                                      inpersonQualitativeController.studentLearningController.clear();
                                                      inpersonQualitativeController.negativeImpactController.clear();
                                                      inpersonQualitativeController.clearRadioValue('digiLabTeachers');
                                                      inpersonQualitativeController.teacherFeelsLessController.clear();
                                                      inpersonQualitativeController.clearRadioValue('logsDifficulties');
                                                      inpersonQualitativeController.factorsPreventingController.clear();
                                                      inpersonQualitativeController.clearRadioValue('additionalSubjects');
                                                      inpersonQualitativeController.additionalSubjectsController.clear();
                                                      inpersonQualitativeController.feedbackController.clear();
                                                    }
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (inpersonQualitativeController
                                              .getRadioFieldError(
                                                  'schoolTeacherInterview'))
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
                                          if (inpersonQualitativeController
                                                  .getSelectedValue(
                                                      'schoolTeacherInterview') ==
                                              'Yes') ...[
                                            LabelText(
                                              label:
                                                  '1. What difficulties do you face in operating the DigiLab?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .operatingDigiLabController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '2. Has it made teaching more difficult? Please elaborate? ',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .difficultiesController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '3. Have they observed any improvement in student learning levels since they started using the DigiLab?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .improvementController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '4. Has the DigiLab content and Alexa echo helped in students learning & communication skills?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .studentLearningController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '5. Has there been any negative impact on traditional classroom learning due to the digiLab? Please elaborate?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .negativeImpactController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '6. Has DigiLab made teachers feel less important in the school?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'digiLabTeachers'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'digiLabTeachers',
                                                              value);
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
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'digiLabTeachers'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'digiLabTeachers',
                                                              value);
                                                      if (value == 'No') {

                                                        inpersonQualitativeController.teacherFeelsLessController.clear();

                                                      }
                                                    },

                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (inpersonQualitativeController
                                                .getRadioFieldError(
                                                    'digiLabTeachers'))
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
                                            if (inpersonQualitativeController
                                                    .getSelectedValue(
                                                        'digiLabTeachers') ==
                                                'Yes') ...[
                                              LabelText(
                                                label:
                                                    '6.1. Why DigiLab made teachers feel less important in the school?',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                              CustomTextFormField(
                                                textController:
                                                    inpersonQualitativeController
                                                        .teacherFeelsLessController,
                                                maxlines: 2,
                                                labelText: 'Write here...',
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill this field';
                                                  }
                                                  if (value.length < 50) {
                                                    return 'Must be at least 50 characters long';
                                                  }
                                                  return null;
                                                },
                                                showCharacterCount: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                            ],
                                            LabelText(
                                              label:
                                                  '7. Do you face any difficulties in filling the DigiLab logs and calculating average learning improvement levels?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'logsDifficulties'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'logsDifficulties',
                                                              value);
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
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'logsDifficulties'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'logsDifficulties',
                                                              value);
                                                      if (value == 'No') {

                                                        inpersonQualitativeController.factorsPreventingController.clear();

                                                      }
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (inpersonQualitativeController
                                                .getRadioFieldError(
                                                    'logsDifficulties'))
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
                                            if (inpersonQualitativeController
                                                    .getSelectedValue(
                                                        'logsDifficulties') ==
                                                'Yes') ...[
                                              LabelText(
                                                label:
                                                    '7.1. What are the factors which are preventing you from being able to do this?',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                              CustomTextFormField(
                                                textController:
                                                    inpersonQualitativeController
                                                        .factorsPreventingController,
                                                maxlines: 2,
                                                labelText: 'Write here...',
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill this field';
                                                  }
                                                  if (value.length < 50) {
                                                    return 'Must be at least 50 characters long';
                                                  }
                                                  return null;
                                                },
                                                showCharacterCount: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                            ],
                                            LabelText(
                                              label:
                                                  '8. Is there any additional type of content or subjects that you would like to be included in the DigiLab curriculum?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'additionalSubjects'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'additionalSubjects',
                                                              value);
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
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'additionalSubjects'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'additionalSubjects',
                                                              value);
                                                      if (value == 'No') {

                                                        inpersonQualitativeController.additionalSubjectsController.clear();

                                                      }
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (inpersonQualitativeController
                                                .getRadioFieldError(
                                                    'additionalSubjects'))
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
                                            if (inpersonQualitativeController
                                                    .getSelectedValue(
                                                        'additionalSubjects') ==
                                                'Yes') ...[
                                              LabelText(
                                                label:
                                                    '8.1. Please Elaborate additional type of content or subjects that you would like to be included in the DigiLab curriculum',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                              CustomTextFormField(
                                                textController:
                                                    inpersonQualitativeController
                                                        .additionalSubjectsController,
                                                maxlines: 2,
                                                labelText: 'Write here...',
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill this field';
                                                  }
                                                  if (value.length < 50) {
                                                    return 'Must be at least 50 characters long';
                                                  }
                                                  return null;
                                                },
                                                showCharacterCount: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                            ],
                                            LabelText(
                                              label:
                                                  '9. Are there any suggestions/feedback to further improve the program?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .feedbackController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                          ],
                                          if (inpersonQualitativeController
                                                  .getSelectedValue(
                                                      'schoolTeacherInterview') ==
                                              'No') ...[
                                            LabelText(
                                              label:
                                                  'Why were you not able to interview School and Teachers',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .notAbleTeacherInterviewController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 25) {
                                                  return 'Must be at least 25 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                          ],
                                          Row(
                                            children: [
                                              CustomButton(
                                                  title: 'Back',
                                                  onPressedButton: () {
                                                    setState(() {
                                                      showInputs = true;
                                                      showSchoolTeacher = false;
                                                    });
                                                  }),
                                              const Spacer(),
                                              CustomButton(
                                                title: 'Next',
                                                onPressedButton: () {
                                                  // Validate all form fields and radio selections
                                                  bool isFormValid = _formKey
                                                      .currentState!
                                                      .validate();
                                                  bool
                                                      isSchoolTeacherInterviewValid =
                                                      inpersonQualitativeController
                                                          .validateRadioSelection(
                                                              'schoolTeacherInterview');
                                                  bool isDigiLabTeachersValid =
                                                      inpersonQualitativeController
                                                          .validateRadioSelection(
                                                              'digiLabTeachers');
                                                  bool isLogsDifficultiesValid =
                                                      inpersonQualitativeController
                                                          .validateRadioSelection(
                                                              'logsDifficulties');
                                                  bool
                                                      isAdditionalSubjectsValid =
                                                      inpersonQualitativeController
                                                          .validateRadioSelection(
                                                              'additionalSubjects');

                                                  // Check if all validations pass
                                                  if (isFormValid &&
                                                      isSchoolTeacherInterviewValid) {
                                                    // If 'Yes' is selected for 'schoolTeacherInterview', validate further options
                                                    if (inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'schoolTeacherInterview') ==
                                                        'Yes') {
                                                      if (isDigiLabTeachersValid &&
                                                          isLogsDifficultiesValid &&
                                                          isAdditionalSubjectsValid) {
                                                        // All validations passed, move to the next step
                                                        setState(() {
                                                          showSchoolTeacher =
                                                              false;
                                                          showInputStudents =
                                                              true;
                                                        });
                                                      } else {
                                                        // Handle error for unselected radio options (e.g., show error message)
                                                        // This can be done by triggering UI updates via setState or similar methods
                                                      }
                                                    } else {
                                                      // 'No' was selected for 'schoolTeacherInterview', no need for further validation
                                                      setState(() {
                                                        showSchoolTeacher =
                                                            false;
                                                        showInputStudents =
                                                            true;
                                                      });
                                                    }
                                                  }
                                                },
                                              ),
                                            ],
                                          ),

                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                        ], // End of showSchoolTeacher

                                        // Start of showInputStudents
                                        if (showInputStudents) ...[
                                          LabelText(
                                            label:
                                                'Qualitative Inputs Students',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),

                                          LabelText(
                                            label:
                                                'Were you able to interview Students',
                                            astrick: true,
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 300),
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: 'Yes',
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'studentInterview'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'studentInterview',
                                                            value);

                                                    if (value == 'Yes') {

                                                      inpersonQualitativeController.interviewStudentsNotController.clear();


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
                                            padding: const EdgeInsets.only(
                                                right: 300),
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: 'No',
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'studentInterview'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'studentInterview',
                                                            value);
                                                    if (value == 'No') {

                                                      inpersonQualitativeController.navigatingDigiLabController.clear();
                                                      inpersonQualitativeController.componentsDigiLabController.clear();
                                                      inpersonQualitativeController.timeDigiLabController.clear();
                                                      inpersonQualitativeController.booksReadingController.clear();
                                                      inpersonQualitativeController.LibraryController.clear();
                                                      inpersonQualitativeController.LibraryController.clear();
                                                      inpersonQualitativeController.questionsAlexaController.clear();
                                                      inpersonQualitativeController.additionalTypeController.clear();
                                                      inpersonQualitativeController.questionsAlexaNotAbleController.clear();
                                                      inpersonQualitativeController.playingplaygroundController.clear();
                                                      inpersonQualitativeController.clearRadioValue('continuousAssistance');
                                                      inpersonQualitativeController.clearRadioValue('enoughtime');
                                                      inpersonQualitativeController.clearRadioValue('favoriteRead');
                                                      inpersonQualitativeController.clearRadioValue('regularlyMotivate');
                                                      inpersonQualitativeController.clearRadioValue('answersQuestions');
                                                      inpersonQualitativeController.clearRadioValue('AlexaEcho');

                                                    }
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (inpersonQualitativeController
                                              .getRadioFieldError(
                                                  'studentInterview'))
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
                                          if (inpersonQualitativeController
                                                  .getSelectedValue(
                                                      'studentInterview') ==
                                              'Yes') ...[

                                      if (inpersonQualitativeController
                                          .getSelectedValue(
                                      'schoolDigiLab') ==
                                      'Yes') ...[

                                            LabelText(
                                              label:
                                                  '1. What challenges do you face in navigating through the DigiLab content?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .navigatingDigiLabController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '2. Do you require continuous assistance from your teachers?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'continuousAssistance'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'continuousAssistance',
                                                              value);
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
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'continuousAssistance'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'continuousAssistance',
                                                              value);
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (inpersonQualitativeController
                                                .getRadioFieldError(
                                                    'continuousAssistance'))
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
                                                  '3. What components of the DigiLab do you find not be useful and why is this so?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .componentsDigiLabController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '4. How much time are able to spend in the DigiLab?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .timeDigiLabController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '5. Is this time enough to complete your assigned work?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'enoughtime'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'enoughtime',
                                                              value);
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
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'enoughtime'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'enoughtime',
                                                              value);
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (inpersonQualitativeController
                                                .getRadioFieldError(
                                                    'enoughtime'))
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
                                            ],
                                      if (inpersonQualitativeController
                                          .getSelectedValue(
                                      'schoolLibrary') ==
                                      'Yes') ...[
                                            LabelText(
                                              label:
                                                  '6. Which type of books do you enjoy reading the most in the Library?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .booksReadingController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '7. How much time do you usually spend in the Library every week?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .LibraryController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '8. Is this time enough to read your favorite books?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'favoriteRead'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'favoriteRead',
                                                              value);
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
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'favoriteRead'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'favoriteRead',
                                                              value);
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (inpersonQualitativeController
                                                .getRadioFieldError(
                                                    'favoriteRead'))
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
                                            ],

                                      if (inpersonQualitativeController
                                          .getSelectedValue(
                                      'schoolPlayground') ==
                                      'Yes') ...[
                                            LabelText(
                                              label:
                                                  '9. How much time do you spend daily playing in the playground?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .playingplaygroundController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '10. Does this motivate you to come more regularly to school',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'regularlyMotivate'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'regularlyMotivate',
                                                              value);
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
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'regularlyMotivate'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'regularlyMotivate',
                                                              value);
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (inpersonQualitativeController
                                                .getRadioFieldError(
                                                    'regularlyMotivate'))
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
                                            ],

                                            LabelText(
                                              label:
                                                  '11. Has this school been provided with Alexa Echo Dot device?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'AlexaEcho'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'AlexaEcho',
                                                              value);
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
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'AlexaEcho'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'AlexaEcho',
                                                              value);
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (inpersonQualitativeController
                                                .getRadioFieldError(
                                                    'AlexaEcho'))
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
                                            if (inpersonQualitativeController
                                                    .getSelectedValue(
                                                        'AlexaEcho') ==
                                                'Yes') ...[
                                              LabelText(
                                                label:
                                                    '11.1. What sort of questions do you ask Alexa?',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                              CustomTextFormField(
                                                textController:
                                                    inpersonQualitativeController
                                                        .questionsAlexaController,
                                                maxlines: 2,
                                                labelText: 'Write here...',
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill this field';
                                                  }
                                                  if (value.length < 25) {
                                                    return 'Must be at least 25 characters long';
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
                                                    '11.2. Are you able to get answers to all of your questions?',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 300),
                                                child: Row(
                                                  children: [
                                                    Radio(
                                                      value: 'Yes',
                                                      groupValue:
                                                          inpersonQualitativeController
                                                              .getSelectedValue(
                                                                  'answersQuestions'),
                                                      onChanged: (value) {
                                                        inpersonQualitativeController
                                                            .setRadioValue(
                                                                'answersQuestions',
                                                                value);
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
                                                      groupValue:
                                                          inpersonQualitativeController
                                                              .getSelectedValue(
                                                                  'answersQuestions'),
                                                      onChanged: (value) {
                                                        inpersonQualitativeController
                                                            .setRadioValue(
                                                                'answersQuestions',
                                                                value);
                                                      },
                                                    ),
                                                    const Text('No'),
                                                  ],
                                                ),
                                              ),
                                              if (inpersonQualitativeController
                                                  .getRadioFieldError(
                                                      'answersQuestions'))
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 16.0),
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
                                              if (inpersonQualitativeController
                                                      .getSelectedValue(
                                                          'answersQuestions') ==
                                                  'No') ...[
                                                LabelText(
                                                  label:
                                                      '11.3. Which Questions is Alexa not able to answer?',
                                                  astrick: true,
                                                ),
                                                CustomSizedBox(
                                                  value: 20,
                                                  side: 'height',
                                                ),
                                                CustomTextFormField(
                                                  textController:
                                                      inpersonQualitativeController
                                                          .questionsAlexaNotAbleController,
                                                  maxlines: 2,
                                                  labelText: 'Write here...',
                                                  validator: (value) {
                                                    if (value == null ||
                                                        value.isEmpty) {
                                                      return 'Please fill this field';
                                                    }
                                                    if (value.length < 50) {
                                                      return 'Must be at least 50 characters long';
                                                    }
                                                    return null;
                                                  },
                                                  showCharacterCount: true,
                                                ),
                                                CustomSizedBox(
                                                  value: 20,
                                                  side: 'height',
                                                ),
                                              ]
                                            ],
                                            LabelText(
                                              label:
                                                  '12. Is there any additional type of content or subjects that you would like to be included in the DigiLab curriculum?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .additionalTypeController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                          ],
                                          if (inpersonQualitativeController
                                                  .getSelectedValue(
                                                      'studentInterview') ==
                                              'No') ...[
                                            LabelText(
                                              label:
                                                  'Why were you not able to interview Students',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .interviewStudentsNotController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 25) {
                                                  return 'Must be at least 25 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                          ],
                                          Row(
                                            children: [
                                              CustomButton(
                                                  title: 'Back',
                                                  onPressedButton: () {
                                                    setState(() {
                                                      showSchoolTeacher = true;
                                                      showInputStudents = false;
                                                    });
                                                  }),
                                              const Spacer(),
                                              CustomButton(
                                                title: 'Next',
                                                onPressedButton: () {
                                                  // Validate all form fields
                                                  bool isFormValid = _formKey
                                                      .currentState!
                                                      .validate();
                                                  bool
                                                      isSchoolTeacherInterviewValid =
                                                      inpersonQualitativeController
                                                          .validateRadioSelection(
                                                              'schoolTeacherInterview');

                                                  // Check if all validations pass
                                                  if (isFormValid &&
                                                      isSchoolTeacherInterviewValid) {
                                                    // If 'Yes' is selected for 'schoolTeacherInterview', validate additional questions
                                                    if (inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'schoolTeacherInterview') ==
                                                        'Yes') {
                                                      bool
                                                          isContinuousAssistanceValid =
                                                          inpersonQualitativeController
                                                              .validateRadioSelection(
                                                                  'continuousAssistance');
                                                      bool isEnoughTimeValid =
                                                          inpersonQualitativeController
                                                              .validateRadioSelection(
                                                                  'enoughtime');
                                                      bool isFavoriteReadValid =
                                                          inpersonQualitativeController
                                                              .validateRadioSelection(
                                                                  'favoriteRead');
                                                      bool
                                                          isRegularlyMotivateValid =
                                                          inpersonQualitativeController
                                                              .validateRadioSelection(
                                                                  'regularlyMotivate');
                                                      bool isAlexaEchoValid =
                                                          inpersonQualitativeController
                                                              .validateRadioSelection(
                                                                  'AlexaEcho');
                                                      bool
                                                          isAnswersQuestionsValid =
                                                          inpersonQualitativeController
                                                              .validateRadioSelection(
                                                                  'answersQuestions');

                                                      // If all additional radio selections are valid, move to the next step
                                                      if (isContinuousAssistanceValid &&
                                                          isEnoughTimeValid &&
                                                          isFavoriteReadValid &&
                                                          isRegularlyMotivateValid &&
                                                          isAlexaEchoValid &&
                                                          isAnswersQuestionsValid) {
                                                        setState(() {
                                                          showInputStudents =
                                                              false;
                                                          showSmcMember = true;
                                                        });
                                                      } else {
                                                        // Handle error for unselected radio options
                                                        // This can be done by triggering UI updates via setState or similar methods
                                                      }
                                                    } else {
                                                      // If 'No' was selected for 'schoolTeacherInterview', proceed to the next step
                                                      setState(() {
                                                        showInputStudents =
                                                            false;
                                                        showSmcMember = true;
                                                      });
                                                    }
                                                  }
                                                },
                                              ),
                                            ],
                                          ),

                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                        ], // End of showInputStudents

                                        // Start of showSmcMember

                                        if (showSmcMember) ...[
                                          LabelText(
                                            label:
                                                'Qualitative Inputs SMC Member/VEC',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          LabelText(
                                            label:
                                                'Were you able to interview SMC/VEC Charge?',
                                            astrick: true,
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 300),
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: 'Yes',
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'interviewSmc'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'interviewSmc',
                                                            value);
                                                    if (value == 'Yes') {

                                                      inpersonQualitativeController.suggestionsProgramController.clear();

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
                                            padding: const EdgeInsets.only(
                                                right: 300),
                                            child: Row(
                                              children: [
                                                Radio(
                                                  value: 'No',
                                                  groupValue:
                                                      inpersonQualitativeController
                                                          .getSelectedValue(
                                                              'interviewSmc'),
                                                  onChanged: (value) {
                                                    inpersonQualitativeController
                                                        .setRadioValue(
                                                            'interviewSmc',
                                                            value);
                                                    if (value == 'No') {

                                                      inpersonQualitativeController.administrationSchoolController.clear();
                                                      inpersonQualitativeController.issuesResolveController.clear();
                                                      inpersonQualitativeController.fearsController.clear();
                                                      inpersonQualitativeController.easeController.clear();
                                                      inpersonQualitativeController.guidanceController.clear();
                                                      inpersonQualitativeController.feedbackDigiLabController.clear();
                                                      inpersonQualitativeController.effectiveDigiLabController.clear();
                                                      inpersonQualitativeController.suggestionsProgramController.clear();

                                                      inpersonQualitativeController.clearRadioValue('communityResistance');
                                                      inpersonQualitativeController.clearRadioValue('digiLabSessions');


                                                    }
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (inpersonQualitativeController
                                              .getRadioFieldError(
                                                  'interviewSmc'))
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
                                          if (inpersonQualitativeController
                                                  .getSelectedValue(
                                                      'interviewSmc') ==
                                              'Yes') ...[
                                            LabelText(
                                              label:
                                                  '1. What challenges has the school administration faced in incorporating the DigiLab and Library?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .administrationSchoolController,
                                              maxlines: 2,
                                              labelText: 'Write here...',


                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '2. How have you tried to resolve these issues?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .issuesResolveController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                      if (inpersonQualitativeController
                                          .getSelectedValue(
                                      'schoolDigiLab') ==
                                      'Yes') ...[
                                            LabelText(
                                              label:
                                                  '3. Has there been any resistance from the community or school management or teachers about use of technology for student learning?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'communityResistance'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'communityResistance',
                                                              value);
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
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'communityResistance'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'communityResistance',
                                                              value);
                                                      if (value == 'No') {

                                                        inpersonQualitativeController.fearsController.clear();
                                                        inpersonQualitativeController.easeController.clear();

                                                      }
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (inpersonQualitativeController
                                                .getRadioFieldError(
                                                    'communityResistance'))
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
                                            if (inpersonQualitativeController
                                                    .getSelectedValue(
                                                        'communityResistance') ==
                                                'Yes') ...[
                                              LabelText(
                                                label:
                                                    '3.1. What are their fears?',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                              CustomTextFormField(
                                                textController:
                                                    inpersonQualitativeController
                                                        .fearsController,
                                                maxlines: 2,
                                                labelText: 'Write here...',
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill this field';
                                                  }
                                                  if (value.length < 50) {
                                                    return 'Must be at least 50 characters long';
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
                                                    '3.2. How have you tried to put them at ease?',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                              CustomTextFormField(
                                                textController:
                                                    inpersonQualitativeController
                                                        .easeController,
                                                maxlines: 2,
                                                labelText: 'Write here...',
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill this field';
                                                  }
                                                  if (value.length < 50) {
                                                    return 'Must be at least 50 characters long';
                                                  }
                                                  return null;
                                                },
                                                showCharacterCount: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                            ],
                                            LabelText(
                                              label:
                                                  '4. Have you observed any DigiLab sessions?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 300),
                                              child: Row(
                                                children: [
                                                  Radio(
                                                    value: 'Yes',
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'digiLabSessions'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'digiLabSessions',
                                                              value);
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
                                                    groupValue:
                                                        inpersonQualitativeController
                                                            .getSelectedValue(
                                                                'digiLabSessions'),
                                                    onChanged: (value) {
                                                      inpersonQualitativeController
                                                          .setRadioValue(
                                                              'digiLabSessions',
                                                              value);
                                                      if (value == 'No') {

                                                        inpersonQualitativeController.guidanceController.clear();


                                                      }
                                                    },
                                                  ),
                                                  const Text('No'),
                                                ],
                                              ),
                                            ),
                                            if (inpersonQualitativeController
                                                .getRadioFieldError(
                                                    'digiLabSessions'))
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
                                            if (inpersonQualitativeController
                                                    .getSelectedValue(
                                                        'digiLabSessions') ==
                                                'Yes') ...[
                                              LabelText(
                                                label:
                                                    '4.1. What support or guidance do the teachers/students need to make these sessions more effective?',
                                                astrick: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                              CustomTextFormField(
                                                textController:
                                                    inpersonQualitativeController
                                                        .guidanceController,
                                                maxlines: 2,
                                                labelText: 'Write here...',
                                                validator: (value) {
                                                  if (value == null ||
                                                      value.isEmpty) {
                                                    return 'Please fill this field';
                                                  }
                                                  if (value.length < 50) {
                                                    return 'Must be at least 50 characters long';
                                                  }
                                                  return null;
                                                },
                                                showCharacterCount: true,
                                              ),
                                              CustomSizedBox(
                                                value: 20,
                                                side: 'height',
                                              ),
                                            ],
                                            ],
                                            LabelText(
                                              label:
                                                  '5. What sort of feedback have you received about the DigiLab & Library from students,parents & teachers?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .feedbackDigiLabController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '6. What more can we done to make the DigiLab & Library more effective for student learning?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .effectiveDigiLabController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
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
                                                  '7. Are there any suggestions/feedback to further improve the program?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .suggestionsProgramController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 50) {
                                                  return 'Must be at least 50 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                          ],
                                          if (inpersonQualitativeController
                                                  .getSelectedValue(
                                                      'interviewSmc') ==
                                              'No') ...[
                                            LabelText(
                                              label:
                                                  'Why were you not able to interview SMC Member/VEC?',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  inpersonQualitativeController
                                                      .suggestionsProgramController,
                                              maxlines: 2,
                                              labelText: 'Write here...',
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please fill this field';
                                                }
                                                if (value.length < 25) {
                                                  return 'Must be at least 25 characters long';
                                                }
                                                return null;
                                              },
                                              showCharacterCount: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                          ],

                                          Row(
                                            children: [
                                              CustomButton(
                                                  title: 'Back',
                                                  onPressedButton: () {
                                                    setState(() {
                                                      showInputStudents = true;
                                                      showSmcMember = false;
                                                    });
                                                  }),
                                              const Spacer(),
                                              CustomButton(
                                                  title: 'Submit',
                                                  onPressedButton: () async {
                                                    // Get the value of 'interviewSmc'
                                                    final interviewSmcValue =
                                                        inpersonQualitativeController
                                                            .validateRadioSelection(
                                                                'interviewSmc');

                                                    bool isRadioValid17 =
                                                        interviewSmcValue ==
                                                            'Yes';
                                                    bool isRadioValid18 =
                                                        true; // Default to true
                                                    bool isRadioValid19 =
                                                        true; // Default to true

                                                    // Only validate 'communityResistance' and 'digiLabSessions' if 'interviewSmc' is 'Yes'
                                                    if (isRadioValid17) {
                                                      isRadioValid18 =
                                                          inpersonQualitativeController
                                                                  .validateRadioSelection(
                                                                      'communityResistance') !=
                                                              null;
                                                      isRadioValid19 =
                                                          inpersonQualitativeController
                                                                  .validateRadioSelection(
                                                                      'digiLabSessions') !=
                                                              null;
                                                    }

                                                    if (_formKey.currentState!
                                                            .validate() &&
                                                        (interviewSmcValue !=
                                                                'Yes' ||
                                                            (isRadioValid18 &&
                                                                isRadioValid19))) {
                                                      String generateUniqueId(
                                                          int length) {
                                                        const _chars =
                                                            'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
                                                        Random _rnd = Random();
                                                        return String.fromCharCodes(
                                                            Iterable.generate(
                                                                length,
                                                                (_) => _chars.codeUnitAt(
                                                                    _rnd.nextInt(
                                                                        _chars
                                                                            .length))));
                                                      }

                                                      List<File>
                                                          imagePathFiles = [];
                                                      for (var imagePath
                                                          in inpersonQualitativeController
                                                              .imagePaths) {
                                                        imagePathFiles.add(File(
                                                            imagePath)); // Convert image path to File
                                                      }

                                                      print(
                                                          'Image Paths: ${imagePathFiles.map((file) => file.path).toList()}');

                                                      String uniqueId =
                                                          generateUniqueId(6);
                                                      DateTime now =
                                                          DateTime.now();
                                                      String formattedDate =
                                                          DateFormat(
                                                                  'yyyy-MM-dd')
                                                              .format(now);

                                                      String
                                                          imagePathFilesPaths =
                                                          imagePathFiles
                                                              .map((file) =>
                                                                  file.path)
                                                              .join(',');

                                                      InPersonQualitativeRecords
                                                          inPersonQualitativeRecords =
                                                          InPersonQualitativeRecords(
                                                        tourId:
                                                            inpersonQualitativeController
                                                                    .tourValue ??
                                                                '',
                                                        school:
                                                            inpersonQualitativeController
                                                                    .schoolValue ??
                                                                '',
                                                        udicevalue: inpersonQualitativeController
                                                                .getSelectedValue(
                                                                    'udiCode') ??
                                                            '',
                                                        correct_udice:
                                                            inpersonQualitativeController
                                                                .correctUdiseCodeController
                                                                .text,
                                                        imgPath:
                                                            imagePathFilesPaths, // Store images as a comma-separated string of Base64
                                                        school_digiLab:
                                                            inpersonQualitativeController
                                                                    .getSelectedValue(
                                                                        'schoolDigiLab') ??
                                                                '',
                                                        school_library:
                                                            inpersonQualitativeController
                                                                    .getSelectedValue(
                                                                        'schoolLibrary') ??
                                                                '',
                                                        school_playground:
                                                            inpersonQualitativeController
                                                                    .getSelectedValue(
                                                                        'schoolPlayground') ??
                                                                '',
                                                        hm_interview:
                                                            inpersonQualitativeController
                                                                    .getSelectedValue(
                                                                        'HmIncharge') ??
                                                                '',
                                                        hm_reason:
                                                            inpersonQualitativeController
                                                                .notAbleController
                                                                .text,
                                                        hmques1:
                                                            inpersonQualitativeController
                                                                .schoolRoutineController
                                                                .text,
                                                        hmques2:
                                                            inpersonQualitativeController
                                                                .componentsController
                                                                .text,
                                                        hmques3:
                                                            inpersonQualitativeController
                                                                .programInitiatedController
                                                                .text,
                                                        hmques4:
                                                            inpersonQualitativeController
                                                                .digiLabSessionController
                                                                .text,
                                                        hmques5:
                                                            inpersonQualitativeController
                                                                .alexaEchoController
                                                                .text,
                                                        hmques6:
                                                            inpersonQualitativeController
                                                                .servicesController
                                                                .text,
                                                        hmques6_1:
                                                            inpersonQualitativeController
                                                                .suggestionsController
                                                                .text,
                                                        hmques7:
                                                            inpersonQualitativeController
                                                                .allowingTabletsController
                                                                .text,
                                                        hmques8:
                                                            inpersonQualitativeController
                                                                .playgroundAllowedController
                                                                .text,
                                                        hmques9:
                                                            inpersonQualitativeController
                                                                .alexaSessionsController
                                                                .text,
                                                        hmques10:
                                                            inpersonQualitativeController
                                                                .improveProgramController
                                                                .text,
                                                        steacher_interview:
                                                            inpersonQualitativeController
                                                                    .getSelectedValue(
                                                                        'schoolTeacherInterview') ??
                                                                '',
                                                        steacher_reason:
                                                            inpersonQualitativeController
                                                                .notAbleTeacherInterviewController
                                                                .text,
                                                        stques1:
                                                            inpersonQualitativeController
                                                                .operatingDigiLabController
                                                                .text,
                                                        stques2:
                                                            inpersonQualitativeController
                                                                .difficultiesController
                                                                .text,
                                                        stques3:
                                                            inpersonQualitativeController
                                                                .improvementController
                                                                .text,
                                                        stques4:
                                                            inpersonQualitativeController
                                                                .studentLearningController
                                                                .text,
                                                        stques5:
                                                            inpersonQualitativeController
                                                                .negativeImpactController
                                                                .text,
                                                        stques6: inpersonQualitativeController
                                                                .getSelectedValue(
                                                                    'digiLabTeachers') ??
                                                            '',
                                                        stques6_1:
                                                            inpersonQualitativeController
                                                                .teacherFeelsLessController
                                                                .text,
                                                        stques7: inpersonQualitativeController
                                                                .getSelectedValue(
                                                                    'logsDifficulties') ??
                                                            '',
                                                        stques7_1:
                                                            inpersonQualitativeController
                                                                .factorsPreventingController
                                                                .text,
                                                        stques8: inpersonQualitativeController
                                                                .getSelectedValue(
                                                                    'additionalSubjects') ??
                                                            '',
                                                        stques8_1:
                                                            inpersonQualitativeController
                                                                .additionalSubjectsController
                                                                .text,
                                                        stques9:
                                                            inpersonQualitativeController
                                                                .feedbackController
                                                                .text,
                                                        student_interview:
                                                            inpersonQualitativeController
                                                                    .getSelectedValue(
                                                                        'studentInterview') ??
                                                                '',
                                                        student_reason:
                                                            inpersonQualitativeController
                                                                .interviewStudentsNotController
                                                                .text,
                                                        stuques1:
                                                            inpersonQualitativeController
                                                                .navigatingDigiLabController
                                                                .text,
                                                        stuques2: inpersonQualitativeController
                                                                .getSelectedValue(
                                                                    'continuousAssistance') ??
                                                            '',
                                                        stuques3:
                                                            inpersonQualitativeController
                                                                .componentsDigiLabController
                                                                .text,
                                                        stuques4:
                                                            inpersonQualitativeController
                                                                .timeDigiLabController
                                                                .text,
                                                        stuques5: inpersonQualitativeController
                                                                .getSelectedValue(
                                                                    'enoughtime') ??
                                                            '',
                                                        stuques6:
                                                            inpersonQualitativeController
                                                                .booksReadingController
                                                                .text,
                                                        stuques7:
                                                            inpersonQualitativeController
                                                                .LibraryController
                                                                .text,
                                                        stuques8: inpersonQualitativeController
                                                                .getSelectedValue(
                                                                    'favoriteRead') ??
                                                            '',
                                                        stuques9:
                                                            inpersonQualitativeController
                                                                .playingplaygroundController
                                                                .text,
                                                        stuques10: inpersonQualitativeController
                                                                .getSelectedValue(
                                                                    'regularlyMotivate') ??
                                                            '',
                                                        stuques11: inpersonQualitativeController
                                                                .getSelectedValue(
                                                                    'AlexaEcho') ??
                                                            '',
                                                        stuques11_1:
                                                            inpersonQualitativeController
                                                                .questionsAlexaController
                                                                .text,
                                                        stuques11_2:
                                                            inpersonQualitativeController
                                                                    .getSelectedValue(
                                                                        'answersQuestions') ??
                                                                '',
                                                        stuques11_3:
                                                            inpersonQualitativeController
                                                                .questionsAlexaNotAbleController
                                                                .text,
                                                        stuques12:
                                                            inpersonQualitativeController
                                                                .additionalTypeController
                                                                .text,
                                                        smc_interview:
                                                            inpersonQualitativeController
                                                                    .getSelectedValue(
                                                                        'interviewSmc') ??
                                                                '',
                                                        smc_reason:
                                                            inpersonQualitativeController
                                                                .suggestionsProgramController
                                                                .text,
                                                        smcques1:
                                                            inpersonQualitativeController
                                                                .administrationSchoolController
                                                                .text,
                                                        smcques2:
                                                            inpersonQualitativeController
                                                                .issuesResolveController
                                                                .text,
                                                        smcques3: inpersonQualitativeController
                                                                .getSelectedValue(
                                                                    'communityResistance') ??
                                                            '',
                                                        smcques3_1:
                                                            inpersonQualitativeController
                                                                .fearsController
                                                                .text,
                                                        smcques3_2:
                                                            inpersonQualitativeController
                                                                .easeController
                                                                .text,
                                                        smcques_4: inpersonQualitativeController
                                                                .getSelectedValue(
                                                                    'digiLabSessions') ??
                                                            '',
                                                        smcques4_1:
                                                            inpersonQualitativeController
                                                                .guidanceController
                                                                .text,
                                                        smcques_5:
                                                            inpersonQualitativeController
                                                                .feedbackDigiLabController
                                                                .text,
                                                        smcques_6:
                                                            inpersonQualitativeController
                                                                .effectiveDigiLabController
                                                                .text,
                                                        smcques_7:
                                                            inpersonQualitativeController
                                                                .suggestionsProgramController
                                                                .text,
                                                        created_at:
                                                            formattedDate
                                                                .toString(),
                                                        submitted_at:
                                                            formattedDate
                                                                .toString(),
                                                        submitted_by: widget
                                                            .userid
                                                            .toString(),
                                                        unique_id: uniqueId,
                                                      );

                                                      int result =
                                                          await LocalDbController()
                                                              .addData(
                                                                  inPersonQualitativeRecords:
                                                                      inPersonQualitativeRecords);

                                                      if (result > 0) {
                                                        inpersonQualitativeController
                                                            .clearFields();
                                                        setState(() {});

                                                        // Save the data to a file as JSON
                                                        await saveDataToFile(
                                                                inPersonQualitativeRecords)
                                                            .then((_) {
                                                          // If successful, show a snackbar indicating the file was downloaded
                                                          customSnackbar(
                                                            'File downloaded successfully',
                                                            'downloaded',
                                                            AppColors.primary,
                                                            AppColors.onPrimary,
                                                            Icons
                                                                .file_download_done,
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
                                                        Navigator
                                                            .pushReplacement(
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
                                                  })
                                            ],
                                          ),
                                        ], // End of showSmcMember
                                      ]);
                                    }));
                          })
                    ])))));
  }
}

Future<void> saveDataToFile(InPersonQualitativeRecords data) async {
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
          '${directory!.path}/fln_observation_form_${data.unique_id}.txt';
      print('Saving file to: $path'); // Debugging output

      // Convert the EnrolmentCollectionModel object to a JSON string
      String jsonString = jsonEncode(data);

      // Handle Base64 conversion for images
      List<String> base64Images = [];
      for (String imagePath in data.imgPath!.split(',')) {
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
      updatedData['imgPath'] =
          base64Images; // Store Base64 instead of file paths

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
