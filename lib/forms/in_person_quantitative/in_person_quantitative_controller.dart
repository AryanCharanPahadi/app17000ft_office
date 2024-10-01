import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_model.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_sync.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../base_client/baseClient_controller.dart';
import 'in_person_quantitative.dart';
import 'in_person_quantitative_modal.dart';
class InPersonQuantitativeController extends GetxController with BaseController {
  var counterText = ''.obs;
  String? _tourValue;
  String? get tourValue => _tourValue;

  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  bool isLoading = false;
  final TextEditingController tourIdController = TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final TextEditingController noOfEnrolledStudentAsOnDateController = TextEditingController();
  final TextEditingController remarksOnDigiLabSchedulingController = TextEditingController();
  final TextEditingController digiLabAdminNameController = TextEditingController();
  final TextEditingController digiLabAdminPhoneNumberController = TextEditingController();
  final TextEditingController correctUdiseCodeController = TextEditingController();
  final TextEditingController instructionProvidedRegardingClassSchedulingController = TextEditingController();
  final TextEditingController staafAttendedTrainingController = TextEditingController();
  final TextEditingController otherTopicsController = TextEditingController();
  final TextEditingController reasonForNotGivenpracticalDemoController = TextEditingController();
  final TextEditingController additionalCommentOnteacherCapacityController = TextEditingController();
  final TextEditingController howOftenDataBeingSyncedController = TextEditingController();
  final TextEditingController additionalObservationOnLibraryController = TextEditingController();
  final TextEditingController writeIssueController = TextEditingController();
  final TextEditingController writeResolutionController = TextEditingController();
  final TextEditingController participantsNameController = TextEditingController();

  void clearTrainingInputs() {

    correctUdiseCodeController.clear();
    update(); // Update the UI after clearing
  }

  void clearTrainingInputs2() {

    correctUdiseCodeController.clear();
    update(); // Update the UI after clearing
  }

  // Map to store selected values for radio buttons
  final Map<String, String?> _selectedValues = {};
  String? getSelectedValue(String key) => _selectedValues[key];

  // Map to store error states for radio buttons
  final Map<String, bool> _radioFieldErrors = {};
  bool getRadioFieldError(String key) => _radioFieldErrors[key] ?? false;

  // Method to set the selected value and clear any previous error
  void setRadioValue(String key, String? value) {
    _selectedValues[key] = value;
    _radioFieldErrors[key] = false; // Clear error when a value is selected
    update(); // Update the UI
  }

  // Method to clear the selected value for a given key
  void clearRadioValue(String key) {
    _selectedValues[key] = null; // Clear the value
    update(); // Update the UI
  }

  // Method to validate radio button selection
  bool validateRadioSelection(String key) {
    if (_selectedValues[key] == null) {
      _radioFieldErrors[key] = true;
      update(); // Update the UI
      return false;
    }
    _radioFieldErrors[key] = false;
    update(); // Update the UI
    return true;
  }
  List<String> splitSchoolLists = [];


  bool showBasicDetails = true; // For show Basic Details
  bool showDigiLabSchedule = false; // For show and hide DigiLab Schedule
  bool showTeacherCapacity = false; // For show and hide Teacher Capacity
  bool showSchoolRefresherTraining =
  false; // For show and hide School Refresher training
  bool showDigiLabClasses = false; // For show and hide DigiLab Classes
  bool showLibrary = false; // For show and hide Library

  bool checkboxValue1 = false;
  bool checkboxValue2 = false;
  bool checkboxValue3 = false;
  bool checkboxValue4 = false;
  bool checkboxValue5 = false;
  bool checkboxValue6 = false;
  bool checkboxValue7 = false;
  bool checkboxValue8 = false;

  bool checkBoxError = false; //for checkbox error

  String? selectedValue = ''; // For the UDISE code
  String? selectedValue2 = ''; // For the DigiLab timetable available
  String? selectedValue3 = ''; // For the class scheduled for 2 hours per week
  String? selectedValue4 = ''; // For the DigiLab admin appointed
  String? selectedValue5 = ''; // For the Digilab admin trained
  String? selectedValue6 = ''; // For the subject teacher trained
  String? selectedValue7 = ''; // For the subject teacher Ids been created
  String? selectedValue8 = ''; // For the teachers comfortable using the tabs
  String? selectedValue9 = ''; // For the practical demo given
  String? selectedValue10 = ''; // For the children comfortable using the tabs
  String? selectedValue11 =
      ''; // For the children able to understand the content
  String? selectedValue12 =
      ''; // For the post-tests being completed by children
  String? selectedValue13 =
      ''; // For the teachers able to help children resolve doubts
  String? selectedValue14 = ''; // For the digiLab logs being filled
  String? selectedValue15 = ''; // For the the logs being filled correctly
  String? selectedValue16 =
      ''; // For the the "Send Report" being done on each used tab
  String? selectedValue17 =
      ''; // For the the Facilitator App installed and functioning
  String? selectedValue18 = ''; // For the the Library timetable available
  String? selectedValue19 = ''; // For the the timetable being followed
  String? selectedValue20 = ''; // For the the Library register updated

  String? isResolved;


  void updateIsResolved(String? value) {
    isResolved = value;
    update(); // This will call the builder again to reflect changes
  }

  final TextEditingController dateController = TextEditingController();
  bool dateFieldError = false;




  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get tourIdFocusNode => _tourIdFocusNode;

  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get schoolFocusNode => _schoolFocusNode;

  List<InPersonQuantitativeRecords> _inPersonQuantitativeList = [];
  List<InPersonQuantitativeRecords> get inPersonQuantitative => _inPersonQuantitativeList;


  final List<XFile> _multipleImage = [];
  List<XFile> get multipleImage => _multipleImage;
  List<String> _imagePaths = [];
  List<String> get imagePaths => _imagePaths;


  final List<XFile> _multipleImage2 = [];
  List<XFile> get multipleImage2 => _multipleImage2;
  List<String> _imagePaths2 = [];
  List<String> get imagePaths2 => _imagePaths2;


  Future<String> takePhoto(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    List<XFile> selectedImages = [];
    XFile? pickedImage;

    if (source == ImageSource.gallery) {
      selectedImages = await picker.pickMultiImage();
      for (var selectedImage in selectedImages) {
        // Compress each selected image
        String compressedPath = await compressImage(selectedImage.path);
        _multipleImage.add(XFile(compressedPath));
        _imagePaths.add(compressedPath);
      }
      update();
    } else if (source == ImageSource.camera) {
      pickedImage = await picker.pickImage(source: source);
      if (pickedImage != null) {
        // Compress the picked image
        String compressedPath = await compressImage(pickedImage.path);
        _multipleImage.add(XFile(compressedPath));
        _imagePaths.add(compressedPath);
      }
      update();
    }

    return _imagePaths.toString();
  }


  Future<String> takePhoto2(ImageSource source) async {
    final ImagePicker picker2 = ImagePicker();
    List<XFile> selectedImages2 = [];
    XFile? pickedImage;

    if (source == ImageSource.gallery) {
      selectedImages2 = await picker2.pickMultiImage();
      for (var selectedImage2 in selectedImages2) {
        // Compress each selected image
        String compressedPath = await compressImage(selectedImage2.path);
        _multipleImage2.add(XFile(compressedPath));
        _imagePaths2.add(compressedPath);
      }
      update();
    } else if (source == ImageSource.camera) {
      pickedImage = await picker2.pickImage(source: source);
      if (pickedImage != null) {
        // Compress the picked image
        String compressedPath = await compressImage(pickedImage.path);
        _multipleImage2.add(XFile(compressedPath));
        _imagePaths2.add(compressedPath);
      }
      update();
    }

    return _imagePaths2.toString();
  }

  Future<String> compressImage(String imagePath) async {
    // Load the image
    final File imageFile = File(imagePath);
    final img.Image? originalImage = img.decodeImage(imageFile.readAsBytesSync());

    if (originalImage == null) return imagePath; // Return original path if decoding fails

    // Resize the image (optional) and compress
    final img.Image resizedImage = img.copyResize(originalImage, width: 768); // Change the width as needed
    final List<int> compressedImage = img.encodeJpg(resizedImage, quality: 12); // Adjust quality (0-100)

    // Save the compressed image to a new file
    final Directory appDir = await getTemporaryDirectory();
    final String compressedImagePath = '${appDir.path}/compressed_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final File compressedFile = File(compressedImagePath);
    await compressedFile.writeAsBytes(compressedImage);

    return compressedImagePath; // Return the path of the compressed image
  }


  void setSchool(String? value) {
    _schoolValue = value;

  }

  void setTour(String? value) {
    _tourValue = value;

  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: <Widget>[
          const Text(
            "Select Image",
            style: TextStyle(fontSize: 20.0, color: Colors.white),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto(ImageSource.camera);
                  Get.back();
                },
                child: const Text(
                  'Camera',
                  style: TextStyle(fontSize: 20.0, color: AppColors.primary),
                ),
              ),
              const SizedBox(
                width: 30,
              ),

            ],
          ),
        ],
      ),
    );
  }

  Widget bottomSheet2(BuildContext context) {
    return Container(
      color: AppColors.primary,
      height: 100,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: <Widget>[
          const Text("Select Image", style: TextStyle(fontSize: 20.0, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  await takePhoto2(ImageSource.camera);
                  Get.back();
                },
                child: const Text('Camera', style: TextStyle(fontSize: 20.0, color: AppColors.primary)),
              ),
              const SizedBox(width: 30),

            ],
          ),
        ],
      ),
    );
  }


  void showImagePreview(String imagePath, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.file(
                File(imagePath),
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }

  void clearFields() {
    _tourValue = null;
    _schoolValue = null;
    remarksController.clear();
    noOfEnrolledStudentAsOnDateController.clear();
    remarksOnDigiLabSchedulingController.clear();
    digiLabAdminNameController.clear();
    digiLabAdminPhoneNumberController.clear();
    correctUdiseCodeController.clear();
    instructionProvidedRegardingClassSchedulingController.clear();
    staafAttendedTrainingController.clear();
    otherTopicsController.clear();
    reasonForNotGivenpracticalDemoController.clear();
    additionalCommentOnteacherCapacityController.clear();
    howOftenDataBeingSyncedController.clear();
    additionalObservationOnLibraryController.clear();
    writeIssueController.clear();
    writeResolutionController.clear();
    participantsNameController.clear();
    update();
  }

  Future<void> fetchData() async {
    isLoading = true;
    update();
    _inPersonQuantitativeList = await LocalDbController().fetchLocalInPersonQuantitativeRecords();
    isLoading = false;
    update();
  }
}