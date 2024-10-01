import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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

import '../../components/custom_snackbar.dart';
import '../../helper/database_helper.dart';
import '../../home/home_screen.dart';
import 'cab_meter_tracing_modal.dart';

class CabMeterTracingForm extends StatefulWidget {
  String? userid;
  String? office;
  CabMeterTracingForm({super.key, this.userid, this.office});

  @override
  State<CabMeterTracingForm> createState() => _CabMeterTracingFormState();
}

class _CabMeterTracingFormState extends State<CabMeterTracingForm> {

  bool _isImageUploaded = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();
  bool validateRegister = false;
  List<String> splitSchoolLists = [];



  var jsonData = <String, Map<String, String>>{};


  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    return Scaffold(
      appBar: const CustomAppbar(
        title: 'Cab Meter Tracing Form',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              GetBuilder<CabMeterTracingController>(
                init: CabMeterTracingController(),
                builder: (cabMeterController) {
                  return Form(
                    key: _formKey,
                    child: GetBuilder<TourController>(
                      init: TourController(),
                      builder: (tourController) {
                        tourController.fetchTourDetails();

                        return Column(children: [
                          LabelText(
                            label: 'Tour ID',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomDropdownFormField(
                            focusNode: cabMeterController.tourIdFocusNode,
                            options: tourController.getLocalTourList
                                .map((e) => e.tourId!)
                                .toList(),
                            selectedOption: cabMeterController.tourValue,
                            onChanged: (value) {
                              splitSchoolLists = tourController.getLocalTourList
                                  .where((e) => e.tourId == value)
                                  .map((e) => e.allSchool!.split('|').toList())
                                  .expand((x) => x)
                                  .toList();
                              setState(() {
                                cabMeterController.setSchool(null);
                                cabMeterController.setTour(value);
                              });
                            },
                            labelText: "Select Tour ID",
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Place Visited',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomTextFormField(
                            textController: cabMeterController.placeVisitedController,
                            labelText: 'Place Visited',
                            textCapitalization: TextCapitalization.characters, // This makes the keyboard capitalize all characters
                            onChanged: (value) {
                              // Automatically convert the input to uppercase
                              cabMeterController.placeVisitedController.value =
                                  TextEditingValue(
                                    text: value.toUpperCase(),
                                    selection: cabMeterController.placeVisitedController.selection,
                                  );
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Place Visited';
                              }
                              return null;
                            },
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Vehicle Number',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomTextFormField(
                            textController:
                            cabMeterController.VehicleNumberController,
                            labelText: 'Vehicle Number',
                            textCapitalization: TextCapitalization.characters, // This makes the keyboard capitalize all characters

                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Vehicle Number';
                              }
                              // Regex pattern for validating Indian vehicle number plate
                              final regExp =
                              RegExp(r"^[a-zA-Z]{2}[a-zA-Z0-9]*[0-9]{4}$");
                              if (!regExp.hasMatch(value)) {
                                return 'Please Enter a valid Vehicle Number';
                              }
                              return null;
                            },
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Driver Name',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomTextFormField(
                            textController:
                            cabMeterController.driverNameController,
                            textCapitalization: TextCapitalization.characters, // This makes the keyboard capitalize all characters

                            labelText: 'Driver Name',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Driver Name';
                              }
                              return null;
                            },
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Meter reading',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomTextFormField(
                            textController: cabMeterController.meterReadingController,
                            textInputType: TextInputType.number,
                            labelText: 'Meter reading',
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please Enter Meter Reading';
                              }
                              if (double.tryParse(value) == 0) {
                                return 'Meter Reading cannot be 0';
                              }
                              return null;
                            },
                          ),

                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Click Images:',
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
                                  _isImageUploaded ==
                                      false
                                      ? AppColors.primary
                                      : AppColors.error),
                            ),
                            child: ListTile(
                                title:
                                _isImageUploaded ==
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
                                          cabMeterController
                                              .bottomSheet(
                                              context)));
                                }),
                          ),
                          ErrorText(
                            isVisible: validateRegister,
                            message: 'Register Image Required',
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),

                          cabMeterController
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
                            cabMeterController
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
                              cabMeterController
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
                                            CustomImagePreview.showImagePreview(cabMeterController.multipleImage[index].path,
                                                context);
                                          },
                                          child:
                                          Image.file(
                                            File(cabMeterController.multipleImage[index].path),
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
                                                cabMeterController.multipleImage.removeAt(index);
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
                            label: 'Choose Options:',
                            astrick: true,
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 300),
                            child: Row(
                              children: [
                                Radio(
                                  value: 'Start',
                                  groupValue: cabMeterController
                                      .getSelectedValue('meter'),
                                  onChanged: (value) {
                                    cabMeterController.setRadioValue(
                                        'meter', value);
                                  },
                                ),
                                const Text('Start'),
                              ],
                            ),
                          ),
                          CustomSizedBox(
                            value: 150,
                            side: 'width',
                          ),
                          // make it that user can also edit the tourId and school
                          Padding(
                            padding: const EdgeInsets.only(right: 300),
                            child: Row(
                              children: [
                                Radio(
                                  value: 'End',
                                  groupValue: cabMeterController
                                      .getSelectedValue('meter'),
                                  onChanged: (value) {
                                    cabMeterController.setRadioValue(
                                        'meter', value);
                                  },
                                ),
                                const Text('End'),
                              ],
                            ),
                          ),
                          if (cabMeterController.getRadioFieldError('meter'))
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Please select an option',
                                  style: TextStyle(color: Colors.red),
                                ),
                              ),
                            ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          LabelText(
                            label: 'Remarks',
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomTextFormField(
                            textController:
                                cabMeterController.remarksController,
                            labelText: 'Remarks Here',
                            validator: (value) {
                              if (value != null && value.length > 30) {
                                return 'Text must not be more than 30 characters';
                              }
                              return null;
                            },
                          ),
                          CustomSizedBox(
                            value: 20,
                            side: 'height',
                          ),
                          CustomButton(
                            title: 'Submit',
                            onPressedButton: () async {
                              final isRadioValid1 = cabMeterController.validateRadioSelection('meter');
                              setState(() {
                                validateRegister =
                                    cabMeterController
                                        .multipleImage.isEmpty;
                              });

                              if (_formKey.currentState!.validate() &&
                              !validateRegister && isRadioValid1) {
                                List<File> cabImageFiles = [];
                                for (var imagePath in cabMeterController.imagePaths) {
                                  cabImageFiles.add(File(imagePath)); // Convert image path to File
                                }

                                // Generate a unique ID
                                String generateUniqueId(int length) {
                                  const _chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
                                  Random _rnd = Random();
                                  return String.fromCharCodes(Iterable.generate(
                                      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
                                }

                                String uniqueId = generateUniqueId(6);
                                DateTime now = DateTime.now();
                                String formattedDate = DateFormat('yyyy-MM-dd').format(now);

                                String cabImageFilePaths = cabImageFiles.map((file) => file.path).join(',');

                                // Create CabMeterTracingRecords object
                                CabMeterTracingRecords enrolmentCollectionObj = CabMeterTracingRecords(
                                  status: cabMeterController.getSelectedValue('meter') ?? '',
                                  place_visit: cabMeterController.placeVisitedController.text,
                                  remarks: cabMeterController.remarksController.text,
                                  vehicle_num: cabMeterController.VehicleNumberController.text,
                                  driver_name: cabMeterController.driverNameController.text,
                                  meter_reading: cabMeterController.meterReadingController.text,
                                  image:  cabImageFilePaths,
                                  user_id:widget.userid ?? '',
                                  office: widget.office ?? '',
                                  tour_id: cabMeterController.tourValue ?? '',
                                  created_at: formattedDate,
                                  uniqueId: uniqueId,
                                );

                                // Save data to local database
                                int result = await LocalDbController().addData(
                                  cabMeterTracingRecords: enrolmentCollectionObj,
                                );

                                if (result > 0) {
                                  cabMeterController.clearFields();
                                  setState(() {
                                    jsonData = {};

                                    _isImageUploaded = false;

                                  });

                                  // Save the data to a file as JSON
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
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HomeScreen(),
                                    ),
                                  );
                                  customSnackbar(
                                    'Submitted Successfully',
                                    'submitted',
                                    AppColors.primary,
                                    AppColors.onPrimary,
                                    Icons.verified,
                                  );
                                } else {
                                  customSnackbar(
                                    'Error',
                                    'Something went wrong',
                                    AppColors.primary,
                                    AppColors.onPrimary,
                                    Icons.error,
                                  );
                                }
                              }
                              FocusScope.of(context).requestFocus(FocusNode());
                            },
                          )

                        ]);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Function to save JSON data to a file
//
// Future<void> saveDataToFile(CabMeterTracingRecords data) async {
//   try {
//     // Request storage permissions
//     var status = await Permission.storage.request();
//     if (status.isGranted) {
//       // Get the user's downloads directory
//       final directory = Directory('/storage/emulated/0/Download');
//       if (!await directory.exists()) {
//         print('Download directory not found');
//         return;
//       }
//
//       final path = '${directory.path}/cab_Meter_Tracing${data.uniqueId}.txt';
//
//       // Convert the CabMeterTracingRecords object to a JSON string
//       String jsonString = jsonEncode(data);
//
//       // Write the JSON string to a file
//       File file = File(path);
//       await file.writeAsString(jsonString);
//
//       print('Data saved to $path');
//     } else {
//       print('Storage permission not granted');
//       // Optionally, handle what happens if permission is denied
//     }
//   } catch (e) {
//     print('Error saving data: $e');
//   }
// }
//



Future<void> saveDataToFile(CabMeterTracingRecords data) async {
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

      final path = '${directory!.path}/cab_meter_form_${data.uniqueId}.txt';
      print('Saving file to: $path'); // Debugging output

      // Convert the EnrolmentCollectionModel object to a JSON string
      String jsonString = jsonEncode(data);

      // Handle Base64 conversion for images
      List<String> base64Images = [];
      for (String imagePath in data.image!.split(',')) {
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
      updatedData['image'] = base64Images; // Store Base64 instead of file paths

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
