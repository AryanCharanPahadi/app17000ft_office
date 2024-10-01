import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart'; // For a safer directory path handling

import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_button.dart';
import 'package:app17000ft_new/components/custom_imagepreview.dart';
import 'package:app17000ft_new/components/custom_snackbar.dart';
import 'package:app17000ft_new/components/custom_textField.dart';
import 'package:app17000ft_new/components/error_text.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/alfa_observation_form/alfa_obervation_modal.dart';
import 'package:app17000ft_new/forms/fln_observation_form/fln_observation_modal.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_model.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
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
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_controller.dart';
import 'package:app17000ft_new/home/home_screen.dart';

import '../../components/custom_confirmation.dart';
import '../../utils/file_utils.dart';
import '../alfa_observation_form/alfa_observation_controller.dart';
import 'fln_observation_controller.dart';

class FlnObservationForm extends StatefulWidget {
  String? userid;
  String? office;
  FlnObservationForm({
    super.key,
    this.userid,
    this.office,
  });

  @override
  State<FlnObservationForm> createState() => _FlnObservationFormState();
}

class _FlnObservationFormState extends State<FlnObservationForm> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> splitSchoolLists = [];

  // Start of Basic Details
  bool showBasicDetails = true; // For show Basic Details
  bool showBaseLineAssessment = false; // For show Basic Details
  bool showFlnActivity = false; // For show Basic Details
  bool showReferesherTraining = false; // For show Basic Details
  bool showLibrary = false; // For show Basic Details
  bool showClassroom = false; // For show Basic Details

  // End of BasicDetails

  // For the image
  bool validateNursery = false; // for the nursery timetable
  final bool _isImageUploadedNursery = false; // for the nursery timetable

  bool validateLkg = false; // for the LKG timetable
  final bool _isImageUploadedLkg = false; // for the LKG timetable

  bool validateUkg = false; // for the UKG timetable
  final bool _isImageUploadedUkg = false; // for the UKG timetable

  bool validateActivityCorner = false; // for the UKG timetable
  final bool _isImageUploadedActivityCorner = false; // for the UKG timetable

  bool validateTlm = false; // for the UKG timetable
  final bool _isImageUploadedTlm = false; // for the UKG timetable

  bool validateFlnActivities = false; // for the UKG timetable
  final bool _isImageUploadedFlnActivities = false; // for the UKG timetable

  bool validateRefresherTraining = false; // for the UKG timetable
  final bool _isImageUploadedRefresherTraining = false; // for the UKG timetable

  bool validateLibrary = false; // for the UKG timetable
  final bool _isImageUploadedLibrary = false; // for the UKG timetable

  bool validateClassroom = false; // for the UKG timetable
  final bool _isImageUploadedClassroom = false; // for the UKG timetable

  final List<TextEditingController> boysControllers = [];
  final List<TextEditingController> girlsControllers = [];
  bool validateEnrolmentRecords = false;
  final List<ValueNotifier<int>> totalNotifiers = [];

  bool validateEnrolmentData() {
    for (int i = 0; i < grades.length; i++) {
      if (boysControllers[i].text.isNotEmpty ||
          girlsControllers[i].text.isNotEmpty) {
        return true; // At least one record is present
      }
    }
    return false; // No records present
  }

  final List<String> grades = [ '1st', '2nd', '3rd'];
  bool isInitialized = false;

  // ValueNotifiers for the grand totals
  final ValueNotifier<int> grandTotalBoys = ValueNotifier<int>(0);
  final ValueNotifier<int> grandTotalGirls = ValueNotifier<int>(0);
  final ValueNotifier<int> grandTotal = ValueNotifier<int>(0);
  var jsonData = <String, Map<String, String>>{};

  // Function to collect data and convert to JSON
  void collectData() {
    final data = <String, Map<String, String>>{};
    for (int i = 0; i < grades.length; i++) {
      data[grades[i]] = {
        'boys': boysControllers[i].text,
        'girls': girlsControllers[i].text,
      };
    }
    jsonData = data;
  }

  @override
  void initState() {
    super.initState();

    // Initialize controllers, notifiers, and add listeners
    for (int i = 0; i < grades.length; i++) {
      final boysController = TextEditingController();
      final girlsController = TextEditingController();
      final totalNotifier = ValueNotifier<int>(0);

      boysController.addListener(() {
        updateTotal(i);
        collectData();
      });
      girlsController.addListener(() {
        updateTotal(i);
        collectData();
      });

      boysControllers.add(boysController);
      girlsControllers.add(girlsController);
      totalNotifiers.add(totalNotifier);
    }

    // Initialize controllers and notifiers for Staff Details
    for (int i = 0; i < staffRoles.length; i++) {
      final teachingStaffController = TextEditingController();
      final nonTeachingStaffController = TextEditingController();
      final totalNotifier = ValueNotifier<int>(0);

      teachingStaffController.addListener(() {
        updateStaffTotal(i);
        collectStaffData();
      });
      nonTeachingStaffController.addListener(() {
        updateStaffTotal(i);
        collectStaffData();
      });

      teachingStaffControllers.add(teachingStaffController);
      nonTeachingStaffControllers.add(nonTeachingStaffController);
      staffTotalNotifiers.add(totalNotifier);
    }

    // Initialize controllers, notifiers, and add listeners
    for (int i = 0; i < grades2.length; i++) {
      final boysController2 = TextEditingController();
      final girlsController2 = TextEditingController();
      final totalNotifier2 = ValueNotifier<int>(0);

      boysController2.addListener(() {
        updateTotal2(i);
        collectData2();
      });
      girlsController2.addListener(() {
        updateTotal2(i);
        collectData2();
      });

      boysControllers2.add(boysController2);
      girlsControllers2.add(girlsController2);
      totalNotifiers2.add(totalNotifier2);
    }

    // Set the initialization flag to true after all controllers and notifiers are initialized
    setState(() {
      isInitialized = true;
    });
  }

  void updateTotal(int index) {
    final boysCount = int.tryParse(boysControllers[index].text) ?? 0;
    final girlsCount = int.tryParse(girlsControllers[index].text) ?? 0;
    totalNotifiers[index].value = boysCount + girlsCount;

    updateGrandTotal();
  }

  void updateGrandTotal() {
    int boysSum = 0;
    int girlsSum = 0;

    for (int i = 0; i < grades.length; i++) {
      boysSum += int.tryParse(boysControllers[i].text) ?? 0;
      girlsSum += int.tryParse(girlsControllers[i].text) ?? 0;
    }

    grandTotalBoys.value = boysSum;
    grandTotalGirls.value = girlsSum;
    grandTotal.value = boysSum + girlsSum;
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();

    // Dispose controllers and notifiers
    for (var controller in boysControllers) {
      controller.dispose();
    }
    for (var controller in girlsControllers) {
      controller.dispose();
    }
    for (var notifier in totalNotifiers) {
      notifier.dispose();
    }
    grandTotalBoys.dispose();
    grandTotalGirls.dispose();
    grandTotal.dispose();

    // Dispose controllers and notifiers
    for (var controller in boysControllers2) {
      controller.dispose();
    }
    for (var controller in girlsControllers2) {
      controller.dispose();
    }
    for (var notifier in totalNotifiers2) {
      notifier.dispose();
    }
    grandTotalBoys2.dispose();
    grandTotalGirls2.dispose();
    grandTotal2.dispose();

    for (var controller in teachingStaffControllers) {
      controller.dispose();
    }
    for (var controller in nonTeachingStaffControllers) {
      controller.dispose();
    }
    for (var notifier in staffTotalNotifiers) {
      notifier.dispose();
    }
    grandTotalTeachingStaff.dispose();
    grandTotalNonTeachingStaff.dispose();
    grandTotalStaff.dispose();




  }

  TableRow tableRowMethod(
      String classname,
      TextEditingController boyController,
      TextEditingController girlController,
      ValueNotifier<int> totalNotifier) {
    return TableRow(
      children: [
        TableCell(
          child: Center(
            child: Text(
              classname,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        TableCell(
          child: TextFormField(
            controller: boyController,
            decoration: const InputDecoration(border: InputBorder.none),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
              LengthLimitingTextInputFormatter(3), // Limit to 3 digits
            ],
          ),
        ),
        TableCell(
          child: TextFormField(
            controller: girlController,
            decoration: const InputDecoration(border: InputBorder.none),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
              LengthLimitingTextInputFormatter(3), // Limit to 3 digits
            ],
          ),
        ),
        TableCell(
          child: ValueListenableBuilder<int>(
            valueListenable: totalNotifier,
            builder: (context, total, child) {
              return Center(
                child: Text(
                  total.toString(),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Map<String, Map<String, int>> staffData = {};
  final List<TextEditingController> teachingStaffControllers = [];
  final List<TextEditingController> nonTeachingStaffControllers = [];
  bool validateStaffData = false;

  final List<ValueNotifier<int>> staffTotalNotifiers = [];

  final ValueNotifier<int> grandTotalTeachingStaff = ValueNotifier<int>(0);
  final ValueNotifier<int> grandTotalNonTeachingStaff = ValueNotifier<int>(0);
  final ValueNotifier<int> grandTotalStaff = ValueNotifier<int>(0);
  var staffJsonData = <String, Map<String, String>>{};

  final List<String> staffRoles = ['1st', '2nd', '3rd'];

  // Collecting Staff Data
  void collectStaffData() {
    final data = <String, Map<String, String>>{};
    for (int i = 0; i < staffRoles.length; i++) {
      data[staffRoles[i]] = {
        'boys': teachingStaffControllers[i].text,
        'girls': nonTeachingStaffControllers[i].text,
      };
    }
    staffJsonData = data;
  }

  void updateStaffTotal(int index) {
    final teachingCount =
        int.tryParse(teachingStaffControllers[index].text) ?? 0;
    final nonTeachingCount =
        int.tryParse(nonTeachingStaffControllers[index].text) ?? 0;
    staffTotalNotifiers[index].value = teachingCount + nonTeachingCount;

    updateGrandStaffTotal();
  }

  void updateGrandStaffTotal() {
    int teachingSum = 0;
    int nonTeachingSum = 0;

    for (int i = 0; i < staffRoles.length; i++) {
      teachingSum += int.tryParse(teachingStaffControllers[i].text) ?? 0;
      nonTeachingSum += int.tryParse(nonTeachingStaffControllers[i].text) ?? 0;
    }

    grandTotalTeachingStaff.value = teachingSum;
    grandTotalNonTeachingStaff.value = nonTeachingSum;
    grandTotalStaff.value = teachingSum + nonTeachingSum;
  }

  TableRow staffTableRowMethod(
      String roleName,
      TextEditingController teachingController,
      TextEditingController nonTeachingController,
      ValueNotifier<int> totalNotifier) {
    return TableRow(
      children: [
        TableCell(
          child: Center(
              child: Text(roleName,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold))),
        ),
        TableCell(
          child: TextFormField(
            controller: teachingController,
            keyboardType: TextInputType.number, // Set keyboard type to number
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
              LengthLimitingTextInputFormatter(3), // Limit to 3 digits
            ],
            decoration: const InputDecoration(border: InputBorder.none),
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: TextFormField(
            controller: nonTeachingController,
            keyboardType: TextInputType.number, // Set keyboard type to number
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
              LengthLimitingTextInputFormatter(3), // Limit to 3 digits
            ],
            decoration: const InputDecoration(border: InputBorder.none),
            textAlign: TextAlign.center,
          ),
        ),
        TableCell(
          child: ValueListenableBuilder<int>(
            valueListenable: totalNotifier,
            builder: (context, total, child) {
              return Center(
                  child: Text(total.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)));
            },
          ),
        ),
      ],
    );
  }

  Map<String, Map<String, int>> classData2 = {};
  final List<TextEditingController> boysControllers2 = [];
  final List<TextEditingController> girlsControllers2 = [];
  bool validateReading = false;
  final List<ValueNotifier<int>> totalNotifiers2 = [];

  bool validateReadingData() {
    for (int i = 0; i < grades2.length; i++) {
      if (boysControllers2[i].text.isNotEmpty ||
          girlsControllers2[i].text.isNotEmpty) {
        return true; // At least one record is present
      }
    }
    return false; // No records present
  }

  final List<String> grades2 = ['1st', '2nd', '3rd'];

  // ValueNotifiers for the grand totals
  final ValueNotifier<int> grandTotalBoys2 = ValueNotifier<int>(0);
  final ValueNotifier<int> grandTotalGirls2 = ValueNotifier<int>(0);
  final ValueNotifier<int> grandTotal2 = ValueNotifier<int>(0);
  var readingJson = <String, Map<String, String>>{};

  // Function to collect data and convert to JSON
  void collectData2() {
    final data2 = <String, Map<String, String>>{};
    for (int i = 0; i < grades2.length; i++) {
      data2[grades2[i]] = {
        'boys': boysControllers2[i].text,
        'girls': girlsControllers2[i].text,
      };
    }
    readingJson = data2;
  }

  void updateTotal2(int index) {
    final boysCount2 = int.tryParse(boysControllers2[index].text) ?? 0;
    final girlsCount2 = int.tryParse(girlsControllers2[index].text) ?? 0;
    totalNotifiers2[index].value = boysCount2 + girlsCount2;

    updateGrandTotal2();
  }

  void updateGrandTotal2() {
    int boysSum2 = 0;
    int girlsSum2 = 0;

    for (int i = 0; i < grades2.length; i++) {
      boysSum2 += int.tryParse(boysControllers2[i].text) ?? 0;
      girlsSum2 += int.tryParse(girlsControllers2[i].text) ?? 0;
    }

    grandTotalBoys2.value = boysSum2;
    grandTotalGirls2.value = girlsSum2;
    grandTotal2.value = boysSum2 + girlsSum2;
  }

  TableRow tableRowMethod2(
      String classname2,
      TextEditingController boyController2,
      TextEditingController girlController2,
      ValueNotifier<int> totalNotifier2) {
    return TableRow(
      children: [
        TableCell(
          child: Center(
              child: Text(classname2,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold))),
        ),
        TableCell(
          child: TextFormField(
            controller: boyController2,
            decoration: const InputDecoration(border: InputBorder.none),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number, // Set keyboard type to number
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
              LengthLimitingTextInputFormatter(3), // Limit to 3 digits
            ],
          ),
        ),
        TableCell(
          child: TextFormField(
            controller: girlController2,
            decoration: const InputDecoration(border: InputBorder.none),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number, // Set keyboard type to number
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly, // Allow only digits
              LengthLimitingTextInputFormatter(3), // Limit to 3 digits
            ],
          ),
        ),
        TableCell(
          child: ValueListenableBuilder<int>(
            valueListenable: totalNotifier2,
            builder: (context, total, child) {
              return Center(
                  child: Text(total.toString(),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)));
            },
          ),
        ),
      ],
    );
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
              title: 'FLN Observation Form',
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(children: [
                      GetBuilder<FlnObservationController>(
                          init: FlnObservationController(),
                          builder: (flnObservationController) {
                            return Form(
                                key: _formKey,
                                child: GetBuilder<TourController>(
                                    init: TourController(),
                                    builder: (tourController) {
                                      tourController.fetchTourDetails();
                                      return Column(children: [
                                        //show Basic Details
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
                                                  flnObservationController
                                                      .tourIdFocusNode,
                                              options: tourController
                                                  .getLocalTourList
                                                  .map((e) => e.tourId!)
                                                  .toList(),
                                              selectedOption:
                                                  flnObservationController
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
                                                  flnObservationController
                                                      .setSchool(null);
                                                  flnObservationController
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
                                                flnObservationController
                                                    .setSchool(value);
                                              });
                                            },
                                            selectedItem:
                                                flnObservationController
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'udiCode'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'udiCode', value);
                                                    if (value == 'Yes') {

                                                      flnObservationController.correctUdiseCodeController.clear();

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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'udiCode'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'udiCode', value);
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (flnObservationController
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
                                          if (flnObservationController
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
                                                  flnObservationController
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
                                                'Number of Staff trained by Master Trainer?',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          CustomTextFormField(
                                            textController:
                                                flnObservationController
                                                    .noOfStaffTrainedController,
                                            textInputType: TextInputType.number,
                                            labelText: 'Enter Number',
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
                                            label:
                                                'Upload photo of NURSERY timetable',
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
                                                      _isImageUploadedNursery ==
                                                              false
                                                          ? AppColors.primary
                                                          : AppColors.error),
                                            ),
                                            child: ListTile(
                                                title:
                                                    _isImageUploadedNursery ==
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
                                                          flnObservationController
                                                              .bottomSheet(
                                                                  context)));
                                                }),
                                          ),
                                          ErrorText(
                                            isVisible: validateNursery,
                                            message: 'Register Image Required',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),

                                          flnObservationController
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
                                                      flnObservationController
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
                                                                  flnObservationController
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
                                                                            CustomImagePreview.showImagePreview(flnObservationController.multipleImage[index].path,
                                                                                context);
                                                                          },
                                                                          child:
                                                                              Image.file(
                                                                            File(flnObservationController.multipleImage[index].path),
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
                                                                            flnObservationController.multipleImage.removeAt(index);
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
                                                'Upload photo of LKG timetable',
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
                                                  color: _isImageUploadedLkg ==
                                                          false
                                                      ? AppColors.primary
                                                      : AppColors.error),
                                            ),
                                            child: ListTile(
                                                title:
                                                    _isImageUploadedLkg == false
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
                                                          flnObservationController
                                                              .bottomSheet2(
                                                                  context)));
                                                }),
                                          ),
                                          ErrorText(
                                            isVisible: validateLkg,
                                            message:
                                                'library Register Image Required',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          flnObservationController
                                                  .multipleImage2.isNotEmpty
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
                                                      flnObservationController
                                                              .multipleImage2
                                                              .isEmpty
                                                          ? const Center(
                                                              child: Text(
                                                                  'No images selected.'),
                                                            )
                                                          : ListView.builder(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount:
                                                                  flnObservationController
                                                                      .multipleImage2
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
                                                                            CustomImagePreview2.showImagePreview2(flnObservationController.multipleImage2[index].path,
                                                                                context);
                                                                          },
                                                                          child:
                                                                              Image.file(
                                                                            File(flnObservationController.multipleImage2[index].path),
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
                                                                            flnObservationController.multipleImage2.removeAt(index);
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
                                                'upload photo of UKG timetable',
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
                                                  color: _isImageUploadedUkg ==
                                                          false
                                                      ? AppColors.primary
                                                      : AppColors.error),
                                            ),
                                            child: ListTile(
                                                title:
                                                    _isImageUploadedUkg == false
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
                                                          flnObservationController
                                                              .bottomSheet3(
                                                                  context)));
                                                }),
                                          ),
                                          ErrorText(
                                            isVisible: validateUkg,
                                            message:
                                                'library Register Image Required',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          flnObservationController
                                                  .multipleImage3.isNotEmpty
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
                                                      flnObservationController
                                                              .multipleImage3
                                                              .isEmpty
                                                          ? const Center(
                                                              child: Text(
                                                                  'No images selected.'),
                                                            )
                                                          : ListView.builder(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount:
                                                                  flnObservationController
                                                                      .multipleImage3
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
                                                                            CustomImagePreview3.showImagePreview3(flnObservationController.multipleImage3[index].path,
                                                                                context);
                                                                          },
                                                                          child:
                                                                              Image.file(
                                                                            File(flnObservationController.multipleImage3[index].path),
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
                                                                            flnObservationController.multipleImage3.removeAt(index);
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
                                            label: 'Lesson Plan available?',
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'lessonPlan'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'lessonPlan',
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'lessonPlan'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'lessonPlan',
                                                            value);
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (flnObservationController
                                              .getRadioFieldError('lessonPlan'))
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
                                            label: 'Activity Corner available?',
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'activityCorner'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'activityCorner',
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'activityCorner'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'activityCorner',
                                                            value);
                                                    if (value == 'No') {

                                                      flnObservationController.multipleImage4.clear();

                                                    }
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (flnObservationController
                                              .getRadioFieldError(
                                                  'activityCorner'))
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
                                          if (flnObservationController
                                                  .getSelectedValue(
                                                      'activityCorner') ==
                                              'Yes') ...[
                                            LabelText(
                                              label:
                                                  'Upload photos of Activity Corner',
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
                                                        _isImageUploadedActivityCorner ==
                                                                false
                                                            ? AppColors.primary
                                                            : AppColors.error),
                                              ),
                                              child: ListTile(
                                                  title:
                                                      _isImageUploadedActivityCorner ==
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
                                                            flnObservationController
                                                                .bottomSheet4(
                                                                    context)));
                                                  }),
                                            ),
                                            ErrorText(
                                              isVisible: validateActivityCorner,
                                              message: 'Image Required',
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            flnObservationController
                                                    .multipleImage4.isNotEmpty
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
                                                        flnObservationController
                                                                .multipleImage4
                                                                .isEmpty
                                                            ? const Center(
                                                                child: Text(
                                                                    'No images selected.'),
                                                              )
                                                            : ListView.builder(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemCount:
                                                                    flnObservationController
                                                                        .multipleImage4
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return SizedBox(
                                                                    height: 200,
                                                                    width: 200,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              CustomImagePreview4.showImagePreview4(flnObservationController.multipleImage4[index].path, context);
                                                                            },
                                                                            child:
                                                                                Image.file(
                                                                              File(flnObservationController.multipleImage4[index].path),
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
                                                                              flnObservationController.multipleImage4.removeAt(index);
                                                                            });
                                                                          },
                                                                          child:
                                                                              const Icon(
                                                                            Icons.delete,
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
                                          ],
                                          LabelText(
                                            label:
                                                'Upload photos of TLMs available',
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
                                                  color: _isImageUploadedTlm ==
                                                          false
                                                      ? AppColors.primary
                                                      : AppColors.error),
                                            ),
                                            child: ListTile(
                                                title:
                                                    _isImageUploadedTlm == false
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
                                                          flnObservationController
                                                              .bottomSheet5(
                                                                  context)));
                                                }),
                                          ),
                                          ErrorText(
                                            isVisible: validateTlm,
                                            message: 'Image Required',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          flnObservationController
                                                  .multipleImage5.isNotEmpty
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
                                                      flnObservationController
                                                              .multipleImage5
                                                              .isEmpty
                                                          ? const Center(
                                                              child: Text(
                                                                  'No images selected.'),
                                                            )
                                                          : ListView.builder(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount:
                                                                  flnObservationController
                                                                      .multipleImage5
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
                                                                            CustomImagePreview5.showImagePreview5(flnObservationController.multipleImage5[index].path,
                                                                                context);
                                                                          },
                                                                          child:
                                                                              Image.file(
                                                                            File(flnObservationController.multipleImage5[index].path),
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
                                                                            flnObservationController.multipleImage5.removeAt(index);
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
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          CustomButton(
                                            title: 'Next',
                                            onPressedButton: () {
                                              // Perform radio button validations
                                              final isRadioValid1 =
                                                  flnObservationController
                                                      .validateRadioSelection(
                                                          'udiCode');
                                              final isRadioValid2 =
                                                  flnObservationController
                                                      .validateRadioSelection(
                                                          'lessonPlan');
                                              final isRadioValid3 =
                                                  flnObservationController
                                                      .validateRadioSelection(
                                                          'activityCorner');

                                              setState(() {
                                                validateNursery =
                                                    flnObservationController
                                                        .multipleImage.isEmpty;
                                                validateLkg =
                                                    flnObservationController
                                                        .multipleImage2.isEmpty;
                                                validateUkg =
                                                    flnObservationController
                                                        .multipleImage3.isEmpty;

                                                if (flnObservationController
                                                        .getSelectedValue(
                                                            'activityCorner') ==
                                                    'Yes') {
                                                  validateActivityCorner =
                                                      flnObservationController
                                                          .multipleImage4
                                                          .isEmpty;
                                                } else {
                                                  validateActivityCorner =
                                                      false; // Skip validation
                                                }

                                                validateTlm =
                                                    flnObservationController
                                                        .multipleImage5.isEmpty;
                                              });

                                              if (_formKey.currentState!
                                                      .validate()
                                                  &&
                                                  isRadioValid1 &&
                                                  isRadioValid2 &&
                                                  isRadioValid3 &&
                                                  !validateNursery &&
                                                  !validateLkg &&
                                                  !validateUkg &&
                                                  !validateActivityCorner &&
                                                  !validateTlm
                                                  ) {
                                                setState(() {
                                                  showBasicDetails = false;
                                                  showBaseLineAssessment = true;
                                                });
                                              }
                                            },
                                          ),

                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                        ], // end of the basic details
                                        // Start of BaseLine Assessment
                                        if (showBaseLineAssessment) ...[
                                          LabelText(
                                            label: 'Baseline Assessment',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          LabelText(
                                            label: 'Baseline Assessment Done?',
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'baselineAssessment'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'baselineAssessment',
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'baselineAssessment'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'baselineAssessment',
                                                            value);
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (flnObservationController
                                              .getRadioFieldError(
                                                  'baselineAssessment'))
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
                                          if (flnObservationController
                                                  .getSelectedValue(
                                                      'baselineAssessment') ==
                                              'Yes') ...[
                                            // const MyTable(),
                                            Column(
                                              children: [
                                                Table(
                                                  border: TableBorder.all(),
                                                  children: [
                                                    const TableRow(
                                                      children: [
                                                        TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Grade',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                        TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Boys',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                        TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Girls',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                        TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Total',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                      ],
                                                    ),
                                                    for (int i = 0;
                                                        i < grades.length;
                                                        i++)
                                                      tableRowMethod(
                                                        grades[i],
                                                        boysControllers[i],
                                                        girlsControllers[i],
                                                        totalNotifiers[i],
                                                      ),
                                                    TableRow(
                                                      children: [
                                                        const TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Grand Total',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                        TableCell(
                                                          child:
                                                              ValueListenableBuilder<
                                                                  int>(
                                                            valueListenable:
                                                                grandTotalBoys,
                                                            builder: (context,
                                                                total, child) {
                                                              return Center(
                                                                  child: Text(
                                                                      total
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold)));
                                                            },
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child:
                                                              ValueListenableBuilder<
                                                                  int>(
                                                            valueListenable:
                                                                grandTotalGirls,
                                                            builder: (context,
                                                                total, child) {
                                                              return Center(
                                                                  child: Text(
                                                                      total
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold)));
                                                            },
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child:
                                                              ValueListenableBuilder<
                                                                  int>(
                                                            valueListenable:
                                                                grandTotal,
                                                            builder: (context,
                                                                total, child) {
                                                              return Center(
                                                                  child: Text(
                                                                      total
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold)));
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            ErrorText(
                                              isVisible:
                                                  validateEnrolmentRecords,
                                              message:
                                                  'Atleast one enrolment record is required',
                                            ),
                                            CustomSizedBox(
                                              value: 40,
                                              side: 'height',
                                            ),

                                            const Divider(),

                                            CustomSizedBox(
                                                side: 'height', value: 10),
                                          ],

                                          Row(
                                            children: [
                                              CustomButton(
                                                  title: 'Back',
                                                  onPressedButton: () {
                                                    setState(() {
                                                      showBasicDetails = true;
                                                      showBaseLineAssessment =
                                                          false;
                                                    });
                                                  }),
                                              const Spacer(),
                                              CustomButton(
                                                title: 'Next',
                                                onPressedButton: () {
                                                  final isRadioValid4 =
                                                      flnObservationController
                                                          .validateRadioSelection(
                                                              'baselineAssessment');

                                                  setState(() {
                                                    // Validate enrolment records only when 'refresherTrainingOnALFA' is 'Yes'
                                                    if (flnObservationController
                                                            .getSelectedValue(
                                                                'baselineAssessment') ==
                                                        'Yes') {
                                                      validateEnrolmentRecords =
                                                          jsonData.isEmpty;
                                                    } else {
                                                      validateEnrolmentRecords =
                                                          false; // Skip validation
                                                    }
                                                  });

                                                  if (_formKey.currentState!
                                                          .validate() &&
                                                      isRadioValid4 &&
                                                      !validateEnrolmentRecords) {
                                                    // Include image validation here
                                                    setState(() {
                                                      showBaseLineAssessment =
                                                          false;
                                                      showFlnActivity = true;
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
                                        ], // End of BaseLine Assessment

                                        // Start of FLN Activities

                                        if (showFlnActivity) ...[
                                          LabelText(
                                            label: 'FLN Activities',
                                          ),

                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          LabelText(
                                            label: 'FLN Activities conducted?',
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'flnActivities'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'flnActivities',
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'flnActivities'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'flnActivities',
                                                            value);
                                                    if (value == 'No') {

                                                      flnObservationController.multipleImage6.clear();

                                                    }
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (flnObservationController
                                              .getRadioFieldError(
                                                  'flnActivities'))
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
                                          if (flnObservationController
                                                  .getSelectedValue(
                                                      'flnActivities') ==
                                              'Yes') ...[
                                            Column(
                                              children: [
                                                // New Staff Details Table

                                                Table(
                                                  border: TableBorder.all(),
                                                  children: [
                                                    const TableRow(
                                                      children: [
                                                        TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Grade',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                        TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Boys',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                        TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Girls',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                        TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Total',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                      ],
                                                    ),
                                                    for (int i = 0;
                                                        i < staffRoles.length;
                                                        i++)
                                                      staffTableRowMethod(
                                                        staffRoles[i],
                                                        teachingStaffControllers[
                                                            i],
                                                        nonTeachingStaffControllers[
                                                            i],
                                                        staffTotalNotifiers[i],
                                                      ),
                                                    TableRow(
                                                      children: [
                                                        const TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Grand Total',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                        TableCell(
                                                          child:
                                                              ValueListenableBuilder<
                                                                  int>(
                                                            valueListenable:
                                                                grandTotalTeachingStaff,
                                                            builder: (context,
                                                                total, child) {
                                                              return Center(
                                                                  child: Text(
                                                                      total
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold)));
                                                            },
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child:
                                                              ValueListenableBuilder<
                                                                  int>(
                                                            valueListenable:
                                                                grandTotalNonTeachingStaff,
                                                            builder: (context,
                                                                total, child) {
                                                              return Center(
                                                                  child: Text(
                                                                      total
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold)));
                                                            },
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child:
                                                              ValueListenableBuilder<
                                                                  int>(
                                                            valueListenable:
                                                                grandTotalStaff,
                                                            builder: (context,
                                                                total, child) {
                                                              return Center(
                                                                  child: Text(
                                                                      total
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold)));
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            ErrorText(
                                              isVisible: validateStaffData,
                                              message:
                                                  'Atleast one enrolment record is required',
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            LabelText(
                                              label:
                                                  'Upload photo of FLN activities',
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
                                                        _isImageUploadedFlnActivities ==
                                                                false
                                                            ? AppColors.primary
                                                            : AppColors.error),
                                              ),
                                              child: ListTile(
                                                  title:
                                                      _isImageUploadedFlnActivities ==
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
                                                            flnObservationController
                                                                .bottomSheet6(
                                                                    context)));
                                                  }),
                                            ),
                                            ErrorText(
                                              isVisible: validateFlnActivities,
                                              message: 'Image Required',
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            flnObservationController
                                                    .multipleImage6.isNotEmpty
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
                                                        flnObservationController
                                                                .multipleImage6
                                                                .isEmpty
                                                            ? const Center(
                                                                child: Text(
                                                                    'No images selected.'),
                                                              )
                                                            : ListView.builder(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemCount:
                                                                    flnObservationController
                                                                        .multipleImage6
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return SizedBox(
                                                                    height: 200,
                                                                    width: 200,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              CustomImagePreview6.showImagePreview6(flnObservationController.multipleImage6[index].path, context);
                                                                            },
                                                                            child:
                                                                                Image.file(
                                                                              File(flnObservationController.multipleImage6[index].path),
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
                                                                              flnObservationController.multipleImage6.removeAt(index);
                                                                            });
                                                                          },
                                                                          child:
                                                                              const Icon(
                                                                            Icons.delete,
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
                                          ],

                                          Row(
                                            children: [
                                              CustomButton(
                                                  title: 'Back',
                                                  onPressedButton: () {
                                                    setState(() {
                                                      showBaseLineAssessment =
                                                          true;
                                                      showFlnActivity = false;
                                                    });
                                                  }),
                                              const Spacer(),
                                              CustomButton(
                                                title: 'Next',
                                                onPressedButton: () {
                                                  final isRadioValid5 =
                                                      flnObservationController
                                                          .validateRadioSelection(
                                                              'flnActivities');

                                                  setState(() {
                                                    // Validate staff data only when 'flnActivities' is 'Yes'
                                                    if (flnObservationController
                                                            .getSelectedValue(
                                                                'flnActivities') ==
                                                        'Yes') {
                                                      validateStaffData =
                                                          staffJsonData.isEmpty;
                                                      validateFlnActivities =
                                                          flnObservationController
                                                              .multipleImage6
                                                              .isEmpty; // Include image validation here
                                                    } else {
                                                      validateEnrolmentRecords =
                                                          false; // Skip enrolment records validation
                                                      validateFlnActivities =
                                                          false; // Skip image validation if 'Yes' is not selected
                                                    }
                                                  });

                                                  if (_formKey.currentState!
                                                          .validate() &&
                                                      isRadioValid5 &&
                                                      !validateEnrolmentRecords &&
                                                      !validateFlnActivities) {
                                                    // Include image validation in the final check
                                                    setState(() {
                                                      showFlnActivity = false;
                                                      showReferesherTraining =
                                                          true;
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          ),

                                          // Ends of DigiLab Schedule
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                        ], // End of FLN Activities
                                        // Start of Refresher Training
                                        if (showReferesherTraining) ...[
                                          LabelText(
                                            label: 'Refresher Training',
                                          ),

                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),

                                          LabelText(
                                            label:
                                                'Refresher Training conducted?',
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'refresherTraining'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'refresherTraining',
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'refresherTraining'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'refresherTraining',
                                                            value);
                                                    if (value == 'No') {

                                                      flnObservationController.multipleImage7.clear();
                                                      flnObservationController.noOfTeacherTrainedController.clear();

                                                    }
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (flnObservationController
                                              .getRadioFieldError(
                                                  'refresherTraining'))
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

                                          if (flnObservationController
                                                  .getSelectedValue(
                                                      'refresherTraining') ==
                                              'Yes') ...[
                                            LabelText(
                                              label:
                                                  'Number of Teacher Trained',
                                              astrick: true,
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            CustomTextFormField(
                                              textController:
                                                  flnObservationController
                                                      .noOfTeacherTrainedController,
                                              textInputType:
                                                  TextInputType.number,
                                              labelText: 'Enter Number',
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
                                              label:
                                                  'Upload photo of Refresher Training',
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
                                                        _isImageUploadedRefresherTraining ==
                                                                false
                                                            ? AppColors.primary
                                                            : AppColors.error),
                                              ),
                                              child: ListTile(
                                                  title:
                                                      _isImageUploadedRefresherTraining ==
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
                                                            flnObservationController
                                                                .bottomSheet7(
                                                                    context)));
                                                  }),
                                            ),
                                            ErrorText(
                                              isVisible:
                                                  validateRefresherTraining,
                                              message: 'Image Required',
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            flnObservationController
                                                    .multipleImage7.isNotEmpty
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
                                                        flnObservationController
                                                                .multipleImage7
                                                                .isEmpty
                                                            ? const Center(
                                                                child: Text(
                                                                    'No images selected.'),
                                                              )
                                                            : ListView.builder(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemCount:
                                                                    flnObservationController
                                                                        .multipleImage7
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return SizedBox(
                                                                    height: 200,
                                                                    width: 200,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              CustomImagePreview7.showImagePreview7(flnObservationController.multipleImage7[index].path, context);
                                                                            },
                                                                            child:
                                                                                Image.file(
                                                                              File(flnObservationController.multipleImage7[index].path),
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
                                                                              flnObservationController.multipleImage7.removeAt(index);
                                                                            });
                                                                          },
                                                                          child:
                                                                              const Icon(
                                                                            Icons.delete,
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
                                          ],

                                          Row(
                                            children: [
                                              CustomButton(
                                                  title: 'Back',
                                                  onPressedButton: () {
                                                    setState(() {
                                                      showFlnActivity = true;
                                                      showReferesherTraining =
                                                          false;
                                                    });
                                                  }),
                                              const Spacer(),
                                              CustomButton(
                                                title: 'Next',
                                                onPressedButton: () {
                                                  final isRadioValid6 =
                                                      flnObservationController
                                                          .validateRadioSelection(
                                                              'refresherTraining');

                                                  setState(() {
                                                    // Validate enrolment records only when 'refresherTrainingOnALFA' is 'Yes'
                                                    if (flnObservationController
                                                            .getSelectedValue(
                                                                'refresherTraining') ==
                                                        'Yes') {
                                                      validateRefresherTraining =
                                                          flnObservationController
                                                              .multipleImage7
                                                              .isEmpty;
                                                    } else {
                                                      validateRefresherTraining =
                                                          false; // Skip validation
                                                    }
                                                  });

                                                  if (_formKey.currentState!
                                                          .validate() &&
                                                      isRadioValid6 &&
                                                      !validateRefresherTraining) {
                                                    // Include image validation here
                                                    setState(() {
                                                      showReferesherTraining =
                                                          false;
                                                      showLibrary = true;
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ], // End of Refresher Training
// Start of Library
                                        if (showLibrary) ...[
                                          LabelText(
                                            label: 'Library Reading',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          LabelText(
                                            label:
                                                'Reading Activities conducted?',
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'reading'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'reading', value);
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'reading'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'reading', value);
                                                    if (value == 'No') {

                                                      flnObservationController.multipleImage8.clear();


                                                    }
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (flnObservationController
                                              .getRadioFieldError('reading'))
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
                                          if (flnObservationController
                                                  .getSelectedValue(
                                                      'reading') ==
                                              'Yes') ...[
                                            Column(
                                              children: [
                                                Table(
                                                  border: TableBorder.all(),
                                                  children: [
                                                    const TableRow(
                                                      children: [
                                                        TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Grade',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                        TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Boys',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                        TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Girls',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                        TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Total',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                      ],
                                                    ),
                                                    for (int i = 0;
                                                        i < grades2.length;
                                                        i++)
                                                      tableRowMethod(
                                                        grades2[i],
                                                        boysControllers2[i],
                                                        girlsControllers2[i],
                                                        totalNotifiers2[i],
                                                      ),
                                                    TableRow(
                                                      children: [
                                                        const TableCell(
                                                            child: Center(
                                                                child: Text(
                                                                    'Grand Total',
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.bold)))),
                                                        TableCell(
                                                          child:
                                                              ValueListenableBuilder<
                                                                  int>(
                                                            valueListenable:
                                                                grandTotalBoys2,
                                                            builder: (context,
                                                                total, child) {
                                                              return Center(
                                                                  child: Text(
                                                                      total
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold)));
                                                            },
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child:
                                                              ValueListenableBuilder<
                                                                  int>(
                                                            valueListenable:
                                                                grandTotalGirls2,
                                                            builder: (context,
                                                                total, child) {
                                                              return Center(
                                                                  child: Text(
                                                                      total
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold)));
                                                            },
                                                          ),
                                                        ),
                                                        TableCell(
                                                          child:
                                                              ValueListenableBuilder<
                                                                  int>(
                                                            valueListenable:
                                                                grandTotal2,
                                                            builder: (context,
                                                                total, child) {
                                                              return Center(
                                                                  child: Text(
                                                                      total
                                                                          .toString(),
                                                                      style: const TextStyle(
                                                                          fontSize:
                                                                              18,
                                                                          fontWeight:
                                                                              FontWeight.bold)));
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            ErrorText(
                                              isVisible: validateReading,
                                              message:
                                                  'Atleast one enrolment record is required',
                                            ),
                                            CustomSizedBox(
                                              value: 40,
                                              side: 'height',
                                            ),
                                            const Divider(),
                                            CustomSizedBox(
                                                side: 'height', value: 10),
                                            LabelText(
                                              label:
                                                  'Upload photo of Library Reading',
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
                                                        _isImageUploadedLibrary ==
                                                                false
                                                            ? AppColors.primary
                                                            : AppColors.error),
                                              ),
                                              child: ListTile(
                                                  title:
                                                      _isImageUploadedLibrary ==
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
                                                            flnObservationController
                                                                .bottomSheet8(
                                                                    context)));
                                                  }),
                                            ),
                                            ErrorText(
                                              isVisible: validateLibrary,
                                              message: 'Image Required',
                                            ),
                                            CustomSizedBox(
                                              value: 20,
                                              side: 'height',
                                            ),
                                            flnObservationController
                                                    .multipleImage8.isNotEmpty
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
                                                        flnObservationController
                                                                .multipleImage8
                                                                .isEmpty
                                                            ? const Center(
                                                                child: Text(
                                                                    'No images selected.'),
                                                              )
                                                            : ListView.builder(
                                                                scrollDirection:
                                                                    Axis.horizontal,
                                                                itemCount:
                                                                    flnObservationController
                                                                        .multipleImage8
                                                                        .length,
                                                                itemBuilder:
                                                                    (context,
                                                                        index) {
                                                                  return SizedBox(
                                                                    height: 200,
                                                                    width: 200,
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsets
                                                                              .all(
                                                                              8.0),
                                                                          child:
                                                                              GestureDetector(
                                                                            onTap:
                                                                                () {
                                                                              CustomImagePreview8.showImagePreview8(flnObservationController.multipleImage8[index].path, context);
                                                                            },
                                                                            child:
                                                                                Image.file(
                                                                              File(flnObservationController.multipleImage8[index].path),
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
                                                                              flnObservationController.multipleImage8.removeAt(index);
                                                                            });
                                                                          },
                                                                          child:
                                                                              const Icon(
                                                                            Icons.delete,
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
                                          ],
                                          Row(
                                            children: [
                                              CustomButton(
                                                  title: 'Back',
                                                  onPressedButton: () {
                                                    setState(() {
                                                      showReferesherTraining =
                                                          true;
                                                      showLibrary = false;
                                                    });
                                                  }),
                                              const Spacer(),
                                              CustomButton(
                                                title: 'Next',
                                                onPressedButton: () {
                                                  final isRadioValid7 =
                                                      flnObservationController
                                                          .validateRadioSelection(
                                                              'reading');

                                                  setState(() {
                                                    // Validate enrolment records only when 'refresherTrainingOnALFA' is 'Yes'
                                                    if (flnObservationController
                                                            .getSelectedValue(
                                                                'reading') ==
                                                        'Yes') {
                                                      validateReading =
                                                          readingJson.isEmpty;
                                                      validateLibrary =
                                                          flnObservationController
                                                              .multipleImage8
                                                              .isEmpty;
                                                    } else {
                                                      validateLibrary = false;
                                                      validateReading =
                                                          false; // Skip validation
                                                    }
                                                  });

                                                  if (_formKey.currentState!
                                                          .validate() &&
                                                      isRadioValid7 &&
                                                      !validateLibrary &&
                                                      !validateReading) {
                                                    // Include image validation here
                                                    setState(() {
                                                      showLibrary = false;
                                                      showClassroom = true;
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ], // End of Library

                                        // Start od Classroom

                                        if (showClassroom) ...[
                                          LabelText(
                                            label: 'Classroom Observation',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),

                                          LabelText(
                                              label:
                                                  'Note** Observe an English or Maths class being conducted in Grade 1 , 2 or 3 by a Teacher who has attended Centralized Training conducted by 17000ft',
                                              textColor: Colors.purple),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          LabelText(
                                            label:
                                                'Is the teacher using Active Learning methodology?',
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'classroom'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'classroom', value);
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
                                                      flnObservationController
                                                          .getSelectedValue(
                                                              'classroom'),
                                                  onChanged: (value) {
                                                    flnObservationController
                                                        .setRadioValue(
                                                            'classroom', value);
                                                  },
                                                ),
                                                const Text('No'),
                                              ],
                                            ),
                                          ),
                                          if (flnObservationController
                                              .getRadioFieldError('classroom'))
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
                                            label: 'Upload photo of class',
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
                                                      _isImageUploadedClassroom ==
                                                              false
                                                          ? AppColors.primary
                                                          : AppColors.error),
                                            ),
                                            child: ListTile(
                                                title:
                                                    _isImageUploadedClassroom ==
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
                                                          flnObservationController
                                                              .bottomSheet9(
                                                                  context)));
                                                }),
                                          ),
                                          ErrorText(
                                            isVisible: validateClassroom,
                                            message: 'Image Required',
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          flnObservationController
                                                  .multipleImage9.isNotEmpty
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
                                                      flnObservationController
                                                              .multipleImage9
                                                              .isEmpty
                                                          ? const Center(
                                                              child: Text(
                                                                  'No images selected.'),
                                                            )
                                                          : ListView.builder(
                                                              scrollDirection:
                                                                  Axis.horizontal,
                                                              itemCount:
                                                                  flnObservationController
                                                                      .multipleImage9
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
                                                                            CustomImagePreview9.showImagePreview9(flnObservationController.multipleImage9[index].path,
                                                                                context);
                                                                          },
                                                                          child:
                                                                              Image.file(
                                                                            File(flnObservationController.multipleImage9[index].path),
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
                                                                            flnObservationController.multipleImage9.removeAt(index);
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
                                                'Observation about taching methods used and student response',
                                            astrick: true,
                                          ),
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),
                                          CustomTextFormField(
                                            textController:
                                                flnObservationController
                                                    .remarksController,
                                            labelText: 'Write here..',
                                            maxlines: 3,
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
                                          CustomSizedBox(
                                            value: 20,
                                            side: 'height',
                                          ),

                                          Row(
                                            children: [
                                              CustomButton(
                                                  title: 'Back',
                                                  onPressedButton: () {
                                                    setState(() {
                                                      showLibrary = true;
                                                      showClassroom = false;
                                                    });
                                                  }),
                                              const Spacer(),
                                              CustomButton(
                                                title: 'Submit',
                                                onPressedButton: () async {
                                                  final isRadioValid8 = flnObservationController.validateRadioSelection('baselineAssessment');

                                                  setState(() {
                                                    // Validate enrolment records only when 'refresherTrainingOnALFA' is 'Yes'
                                                    validateClassroom = flnObservationController.multipleImage9.isEmpty;
                                                  });

                                                  if (_formKey.currentState!.validate() && isRadioValid8 && !validateClassroom) {
                                                    DateTime now = DateTime.now();
                                                    String formattedDate = DateFormat('yyyy-MM-dd').format(now);

                                                    List<File> nurTimeTableFiles = [];
                                                    for (var imagePath in flnObservationController.imagePaths) {
                                                      nurTimeTableFiles.add(File(imagePath)); // Convert image path to File
                                                    }

                                                    List<File> lkgTimeTableFiles = [];
                                                    for (var imagePath2 in flnObservationController.imagePaths2) {
                                                      lkgTimeTableFiles.add(File(imagePath2)); // Convert image path to File
                                                    }

                                                    List<File> ukgTimeTableFiles = [];
                                                    for (var imagePath3 in flnObservationController.imagePaths3) {
                                                      ukgTimeTableFiles.add(File(imagePath3)); // Convert image path to File
                                                    }

                                                    List<File> activityImgFiles = [];
                                                    for (var imagePath4 in flnObservationController.imagePaths4) {
                                                      activityImgFiles.add(File(imagePath4)); // Convert image path to File
                                                    }

                                                    List<File> tlmImgFiles = [];
                                                    for (var imagePath5 in flnObservationController.imagePaths5) {
                                                      tlmImgFiles.add(File(imagePath5)); // Convert image path to File
                                                    }

                                                    List<File> flnImgFiles = [];
                                                    for (var imagePath6 in flnObservationController.imagePaths6) {
                                                      flnImgFiles.add(File(imagePath6)); // Convert image path to File
                                                    }

                                                    List<File> trainingImgFiles = [];
                                                    for (var imagePath7 in flnObservationController.imagePaths7) {
                                                      trainingImgFiles.add(File(imagePath7)); // Convert image path to File
                                                    }

                                                    List<File> libImgFiles = [];
                                                    for (var imagePath8 in flnObservationController.imagePaths8) {
                                                      libImgFiles.add(File(imagePath8)); // Convert image path to File
                                                    }

                                                    List<File> classImgFiles = [];
                                                    for (var imagePath9 in flnObservationController.imagePaths9) {
                                                      classImgFiles.add(File(imagePath9)); // Convert image path to File
                                                    }

                                                    String nurTimeTableFilePaths = nurTimeTableFiles.map((file) => file.path).join(',');
                                                    String lkgTimeTableFilePaths = lkgTimeTableFiles.map((file) => file.path).join(',');
                                                    String ukgTimeTableFilePaths = ukgTimeTableFiles.map((file) => file.path).join(',');
                                                    String activityImgFilesPaths = activityImgFiles.map((file) => file.path).join(',');
                                                    String trainingImgFilesPaths = trainingImgFiles.map((file) => file.path).join(',');
                                                    String libImgFilesPaths = libImgFiles.map((file) => file.path).join(',');
                                                    String tlmImgFilesPaths = tlmImgFiles.map((file) => file.path).join(',');
                                                    String classImgFilesPaths = classImgFiles.map((file) => file.path).join(',');
                                                    String flnImgFilesPaths = flnImgFiles.map((file) => file.path).join(',');


                                                    print('Image Paths: ${nurTimeTableFiles.map((file) => file.path).toList()}');
                                                    print('Image Paths: ${lkgTimeTableFiles.map((file) => file.path).toList()}');
                                                    print('Image Paths: ${ukgTimeTableFiles.map((file) => file.path).toList()}');
                                                    print('Image Paths: ${activityImgFiles.map((file) => file.path).toList()}');
                                                    print('Image Paths: ${trainingImgFiles.map((file) => file.path).toList()}');
                                                    print('Image Paths: ${libImgFiles.map((file) => file.path).toList()}');
                                                    print('Image Paths: ${tlmImgFiles.map((file) => file.path).toList()}');
                                                    print('Image Paths: ${classImgFiles.map((file) => file.path).toList()}');
                                                    print('Image Paths: ${flnImgFiles.map((file) => file.path).toList()}');


                                                    // Create the enrolment collection object
                                                    FlnObservationModel flnObservationModel = FlnObservationModel(
                                                        tourId: flnObservationController.tourValue ?? '',
                                                        school: flnObservationController.schoolValue ?? '',
                                                        udiseValue: flnObservationController.getSelectedValue('udiCode') ?? '',
                                                        correctUdise: flnObservationController.correctUdiseCodeController.text,
                                                        noStaffTrained: flnObservationController.noOfStaffTrainedController.text,
                                                        imgNurTimeTable: nurTimeTableFilePaths,
                                                        imgLKGTimeTable: lkgTimeTableFilePaths,
                                                        imgUKGTimeTable: ukgTimeTableFilePaths,
                                                        lessonPlanValue: flnObservationController.getSelectedValue('lessonPlan') ?? '',
                                                        activityValue: flnObservationController.getSelectedValue('activityCorner') ?? '',
                                                        imgActivity: activityImgFilesPaths,
                                                        imgTLM: tlmImgFilesPaths,
                                                        baselineValue: flnObservationController.getSelectedValue('baselineAssessment') ?? '',
                                                        baselineGradeReport: jsonEncode(jsonData),
                                                        flnConductValue: flnObservationController.getSelectedValue('flnActivities') ?? '',
                                                        flnGradeReport: jsonEncode(staffJsonData),
                                                        imgFLN: flnImgFilesPaths,
                                                        refresherValue: flnObservationController.getSelectedValue('refresherTraining') ?? '',
                                                        numTrainedTeacher: flnObservationController.noOfTeacherTrainedController.text,
                                                        imgTraining: trainingImgFilesPaths,
                                                        readingValue: flnObservationController.getSelectedValue('reading') ?? '',
                                                        libGradeReport: jsonEncode(readingJson),
                                                        imgLib: libImgFilesPaths,
                                                        methodologyValue: flnObservationController.getSelectedValue('classroom') ?? '',
                                                        imgClass: classImgFilesPaths,
                                                        observation: flnObservationController.remarksController.text,
                                                        createdAt: formattedDate.toString(),
                                                        submittedAt: formattedDate.toString(),
                                                        created_by: widget.userid.toString()
                                                    );

                                                    int result = await LocalDbController().addData(flnObservationModel: flnObservationModel);
                                                    if (result > 0) {
                                                      flnObservationController.clearFields();
                                                      setState(() {
                                                        jsonData = {};
                                                        staffJsonData = {};
                                                        readingJson = {};
                                                      });

                                                      // Save the data to a file as JSON
                                                      await saveDataToFile(flnObservationModel).then((_) {
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


                                                      customSnackbar('Submitted Successfully', 'Submitted', AppColors.primary, AppColors.onPrimary, Icons.verified);

                                                      // Navigate to HomeScreen
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(builder: (context) => HomeScreen()),
                                                      );
                                                    } else {
                                                      customSnackbar('Error', 'Something went wrong', AppColors.error, Colors.white, Icons.error);
                                                    }
                                                  } else {
                                                    FocusScope.of(context).requestFocus(FocusNode());
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ], // End od Classroom
                                      ]);
                                    }));
                          })
                    ])))));
  }
}



Future<void> saveDataToFile(FlnObservationModel data) async {
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
        await directory.create(recursive: true); // Create the directory if it doesn't exist
      }

      final path = '${directory!.path}/fln_observation_form_${data.created_by}.txt';
      print('Saving file to: $path'); // Debugging output

      // Convert the EnrolmentCollectionModel object to a JSON string
      String jsonString = jsonEncode(data);

      // Handle Base64 conversion for images
      List<String> base64Images = [];
      for (String imagePath in data.imgNurTimeTable!.split(',')) {
        File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          List<int> imageBytes = await imageFile.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          base64Images.add(base64Image);
        } else {
          print('Image not found: $imagePath');
        }
      }

      for (String imagePath in data.imgLKGTimeTable!.split(',')) {
        File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          List<int> imageBytes = await imageFile.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          base64Images.add(base64Image);
        } else {
          print('Image not found: $imagePath');
        }
      }

      for (String imagePath in data.imgUKGTimeTable!.split(',')) {
        File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          List<int> imageBytes = await imageFile.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          base64Images.add(base64Image);
        } else {
          print('Image not found: $imagePath');
        }
      }

      for (String imagePath in data.imgClass!.split(',')) {
        File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          List<int> imageBytes = await imageFile.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          base64Images.add(base64Image);
        } else {
          print('Image not found: $imagePath');
        }
      }

      for (String imagePath in data.imgLib!.split(',')) {
        File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          List<int> imageBytes = await imageFile.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          base64Images.add(base64Image);
        } else {
          print('Image not found: $imagePath');
        }
      }

      for (String imagePath in data.imgTraining!.split(',')) {
        File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          List<int> imageBytes = await imageFile.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          base64Images.add(base64Image);
        } else {
          print('Image not found: $imagePath');
        }
      }

      for (String imagePath in data.imgFLN!.split(',')) {
        File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          List<int> imageBytes = await imageFile.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          base64Images.add(base64Image);
        } else {
          print('Image not found: $imagePath');
        }
      }

      for (String imagePath in data.imgActivity!.split(',')) {
        File imageFile = File(imagePath);
        if (await imageFile.exists()) {
          List<int> imageBytes = await imageFile.readAsBytes();
          String base64Image = base64Encode(imageBytes);
          base64Images.add(base64Image);
        } else {
          print('Image not found: $imagePath');
        }
      }

      for (String imagePath in data.imgTLM!.split(',')) {
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
      updatedData['imgNurTimeTable'] = base64Images; // Store Base64 instead of file paths
      updatedData['imgLKGTimeTable'] = base64Images; // Store Base64 instead of file paths
      updatedData['imgUKGTimeTable'] = base64Images; // Store Base64 instead of file paths
      updatedData['imgClass'] = base64Images; // Store Base64 instead of file paths
      updatedData['imgLib'] = base64Images; // Store Base64 instead of file paths
      updatedData['imgTraining'] = base64Images; // Store Base64 instead of file paths
      updatedData['imgFLN'] = base64Images; // Store Base64 instead of file paths
      updatedData['imgActivity'] = base64Images; // Store Base64 instead of file paths
      updatedData['imgTLM'] = base64Images; // Store Base64 instead of file paths

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
