import 'dart:io';

import 'package:app17000ft_new/constants/color_const.dart';

import 'package:app17000ft_new/forms/school_facilities_&_mapping_form/school_facilities_modals.dart';
import 'package:app17000ft_new/forms/school_staff_vec_form/school_vec_modals.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../base_client/baseClient_controller.dart';


class SchoolStaffVecController extends GetxController with BaseController {
  var counterText = ''.obs;
  String? _tourValue;
  String? get tourValue => _tourValue;

  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  bool isLoading = false;

  final TextEditingController nameOfHoiController = TextEditingController();
  final TextEditingController staffPhoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController correctUdiseCodeController = TextEditingController();
  final TextEditingController totalTeachingStaffController = TextEditingController();
  final TextEditingController totalNonTeachingStaffController = TextEditingController();
  final TextEditingController totalStaffController = TextEditingController();
  final TextEditingController nameOfchairpersonController = TextEditingController();
  final TextEditingController chairPhoneNumberController = TextEditingController();
  final TextEditingController email2Controller = TextEditingController();
  final TextEditingController totalVecStaffController = TextEditingController();
  final TextEditingController QualSpecifyController = TextEditingController();
  final TextEditingController QualSpecify2Controller = TextEditingController();


  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get tourIdFocusNode => _tourIdFocusNode;

  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get schoolFocusNode => _schoolFocusNode;

  List<SchoolStaffVecRecords> _schoolStaffVecList = [];
  List<SchoolStaffVecRecords> get schoolStaffVecList => _schoolStaffVecList;



  void setSchool(String? value) {
    _schoolValue = value;


  }

  void setTour(String? value) {
    _tourValue = value;

  }


  void clearFields() {
    _tourValue = null;
    _schoolValue = null;
    correctUdiseCodeController.clear();
    nameOfHoiController.clear();
    staffPhoneNumberController.clear();
    emailController.clear();
    totalTeachingStaffController.clear();
    totalNonTeachingStaffController.clear();
    totalStaffController.clear();
    nameOfchairpersonController.clear();
    chairPhoneNumberController.clear();
    email2Controller.clear();
    totalVecStaffController.clear();
    QualSpecifyController.clear();
    QualSpecify2Controller.clear();



  }

  Future<void> fetchData() async {
    isLoading = true;
    update();
    _schoolStaffVecList = await LocalDbController().fetchLocalSchoolStaffVecRecords();
    isLoading = false;
    update();
  }
}