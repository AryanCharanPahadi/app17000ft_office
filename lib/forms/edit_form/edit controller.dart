import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../base_client/baseClient_controller.dart';
import '../../home/home_controller.dart';
import 'edit_modal.dart';

class EditController extends GetxController with BaseController {
  var counterText = ''.obs;

  List<FormDataModel> localFormData = [];
  List<FormDataModel> get getLocalFormData => localFormData;

  String? _tourValue;
  String? get tourValue => _tourValue;

  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get tourIdFocusNode => _tourIdFocusNode;

  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get schoolFocusNode => _schoolFocusNode;

  // Initialize HomeController
  late HomeController homeController;

  @override
  void onInit() {
    super.onInit();
    homeController = Get.find<HomeController>(); // Find the HomeController
    // Now you can access homeController.empId
    print("Employee ID: ${homeController.empId}");
  }

  void setSchool(String? value) {
    _schoolValue = value;
  }

  void setTour(String? value) {
    _tourValue = value;
  }
  // Getter for empId
  String? get empId => homeController.empId;
  fetchTourDetails() async {
    // Your existing logic for fetching tour details
    update();
  }
}
