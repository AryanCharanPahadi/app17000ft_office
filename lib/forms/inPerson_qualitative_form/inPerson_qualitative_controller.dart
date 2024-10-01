
import 'dart:convert';
import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/alfa_observation_form/alfa_obervation_modal.dart';
import 'package:app17000ft_new/forms/fln_observation_form/fln_observation_modal.dart';
import 'package:app17000ft_new/forms/inPerson_qualitative_form/inPerson_qualitative_modal.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_model.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_sync.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../base_client/baseClient_controller.dart';
class InpersonQualitativeController extends GetxController with BaseController{

  String? _tourValue;
  String? get tourValue => _tourValue;

  //school Value
  String? _schoolValue;
  String? get schoolValue => _schoolValue;

  bool isLoading = false;

  final TextEditingController remarksController = TextEditingController();
  final TextEditingController correctUdiseCodeController = TextEditingController();
  final TextEditingController schoolRoutineController = TextEditingController();
  final TextEditingController componentsController = TextEditingController();
  final TextEditingController programInitiatedController = TextEditingController();
  final TextEditingController digiLabSessionController = TextEditingController();
  final TextEditingController alexaEchoController = TextEditingController();
  final TextEditingController servicesController = TextEditingController();
  final TextEditingController suggestionsController = TextEditingController();
  final TextEditingController allowingTabletsController = TextEditingController();
  final TextEditingController alexaSessionsController = TextEditingController();
  final TextEditingController improveProgramController = TextEditingController();
  final TextEditingController notAbleController = TextEditingController();
  final TextEditingController operatingDigiLabController = TextEditingController();
  final TextEditingController difficultiesController = TextEditingController();
  final TextEditingController improvementController = TextEditingController();
  final TextEditingController studentLearningController = TextEditingController();
  final TextEditingController negativeImpactController = TextEditingController();
  final TextEditingController teacherFeelsLessController = TextEditingController();
  final TextEditingController factorsPreventingController = TextEditingController();
  final TextEditingController additionalSubjectsController = TextEditingController();
  final TextEditingController feedbackController = TextEditingController();
  final TextEditingController notAbleTeacherInterviewController = TextEditingController();
  final TextEditingController navigatingDigiLabController = TextEditingController();
  final TextEditingController componentsDigiLabController = TextEditingController();
  final TextEditingController timeDigiLabController = TextEditingController();
  final TextEditingController booksReadingController = TextEditingController();
  final TextEditingController LibraryController = TextEditingController();
  final TextEditingController playingplaygroundController = TextEditingController();
  final TextEditingController questionsAlexaController = TextEditingController();
  final TextEditingController questionsAlexaNotAbleController = TextEditingController();
  final TextEditingController additionalTypeController = TextEditingController();
  final TextEditingController interviewStudentsNotController = TextEditingController();
  final TextEditingController administrationSchoolController = TextEditingController();
  final TextEditingController issuesResolveController = TextEditingController();
  final TextEditingController fearsController = TextEditingController();
  final TextEditingController easeController = TextEditingController();
  final TextEditingController guidanceController = TextEditingController();
  final TextEditingController feedbackDigiLabController = TextEditingController();
  final TextEditingController effectiveDigiLabController = TextEditingController();
  final TextEditingController suggestionsProgramController = TextEditingController();
  final TextEditingController playgroundAllowedController = TextEditingController();









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

  // Method to clear the selected value for a given key
  void clearRadioValue(String key) {
    _selectedValues[key] = null; // Clear the value
    update(); // Update the UI
  }



  //Focus nodes
  final FocusNode _tourIdFocusNode = FocusNode();
  FocusNode get  tourIdFocusNode => _tourIdFocusNode;
  final FocusNode _schoolFocusNode = FocusNode();
  FocusNode get  schoolFocusNode => _schoolFocusNode;

  List<InPersonQualitativeRecords> _inPersonQualitativeList =[];
  List<InPersonQualitativeRecords> get inPersonQualitativeList => _inPersonQualitativeList;

  List<XFile> _multipleImage = [];
  List<XFile> get multipleImage => _multipleImage;
  List<String> _imagePaths = [];
  List<String> get imagePaths => _imagePaths;


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






  setSchool(value)
  {
    _schoolValue = value;
    // update();
  }

  setTour(value){
    _tourValue = value;
    // update();

  }
  Widget bottomSheet(BuildContext context) {
    String? imagePicked;
    PickedFile? imageFile;
    final ImagePicker picker = ImagePicker();
    XFile? image;
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
              // ignore: deprecated_member_use
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
                onPressed: () async {
                  imagePicked = await takePhoto(ImageSource.camera);

                  // uploadFile(userdata.read('customerID'));
                  Get.back();
                  //  update();
                },
                child: const Text(
                  'Camera',
                  style: TextStyle(
                      fontSize: 20.0, color: AppColors.primary),
                ),
              ),
              const SizedBox(
                width: 30,
              ),

            ],
          )
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



  //Clear fields
  void clearFields() {

    update();
  }

  fetchData() async {
    isLoading = true;

    _inPersonQualitativeList = [];
    _inPersonQualitativeList = await LocalDbController().fetchLocalInPersonQualitativeRecords();

    update();
  }

//

//Update the UI


}