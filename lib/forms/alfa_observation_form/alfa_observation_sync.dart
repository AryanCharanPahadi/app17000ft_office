import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart'; // for MediaType
import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_dialog.dart';
import 'package:app17000ft_new/components/custom_snackbar.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/in_person_quantitative/in_person_quantitative_controller.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_controller.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:app17000ft_new/services/network_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;


import 'alfa_observation_controller.dart';



class AlfaObservationSync extends StatefulWidget {
  const AlfaObservationSync({super.key});

  @override
  State<AlfaObservationSync> createState() => _AlfaObservationSync();
}

class _AlfaObservationSync extends State<AlfaObservationSync> {
  final AlfaObservationController _alfaObservationController = Get.put(AlfaObservationController());
  final NetworkManager _networkManager = Get.put(NetworkManager());
  var isLoading = false.obs;
  var syncProgress = 0.0.obs; // Progress variable for syncing
  var hasError = false.obs; // Variable to track if syncing failed
  @override
  void initState() {
    super.initState();
    _alfaObservationController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop:  () async {
        IconData icon = Icons.check_circle;
        bool shouldExit = await showDialog(
            context: context,
            builder: (_) => Confirmation(
                iconname: icon,
                title: 'Confirm Exit',
                yes: 'Exit',
                no: 'Cancel',
                desc: 'Are you sure you want to Exit?',
                onPressed: () async {
                  Navigator.of(context).pop(true);
                }));
        return shouldExit;
      },
      child: Scaffold(
        appBar: const CustomAppbar(title: 'Alfa Observation Sync'),
        body: GetBuilder<AlfaObservationController>(
          builder: (alfaObservationController) {
            if (alfaObservationController.alfaObservationList.isEmpty) {
              return const Center(
                child: Text(
                  'No Records Found',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary),
                ),
              );
            }

            return Obx(() => isLoading.value
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: AppColors.primary),
                  const SizedBox(height: 20),
                  Text(
                    'Syncing: ${(syncProgress.value * 100).toStringAsFixed(0)}%',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            )
                : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    itemCount: alfaObservationController.alfaObservationList.length,
                    itemBuilder: (context, index) {
                      final item = alfaObservationController.alfaObservationList[index];
                      return ListTile(
                        title: Text(
                          "${index + 1}. Tour ID: ${item.tourId!}\nSchool: ${item.school!}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: MediaQuery.of(context).size.width * 0.04, // Dynamic font size based on screen width
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            IconButton(
                              color: _networkManager.connectionType.value == 0
                                  ? Colors.grey  // Grey out the button when offline
                                  : AppColors.primary,  // Regular color when online
                              icon: const Icon(Icons.sync),
                              onPressed: _networkManager.connectionType.value == 0
                                  ? null  // Disable the button when offline
                                  : () async {
                                // Proceed with sync logic when online
                                IconData icon = Icons.check_circle;
                                showDialog(
                                  context: context,
                                  builder: (_) => Confirmation(
                                    iconname: icon,
                                    title: 'Confirm',
                                    yes: 'Confirm',
                                    no: 'Cancel',
                                    desc: 'Are you sure you want to Sync?',
                                    onPressed: () async {
                                      setState(() {
                                        isLoading.value = true; // Show loading spinner
                                        syncProgress.value = 0.0; // Reset progress
                                        hasError.value = false; // Reset error state
                                      });

                                      if (_networkManager.connectionType.value == 1 ||
                                          _networkManager.connectionType.value == 2) {
                                        for (int i = 0; i <= 100; i++) {
                                          await Future.delayed(const Duration(milliseconds: 50));
                                          syncProgress.value = i / 100; // Update progress
                                        }

                                        // Call the insert function
                                        var rsp = await insertAlfaObservation(
                                          item.tourId,
                                          item.school,
                                          item.udiseValue,
                                          item.correctUdise,
                                          item.noStaffTrained,
                                          item.imgNurTimeTable,
                                          item.imgLKGTimeTable,
                                          item.imgUKGTimeTable,
                                          item.bookletValue,
                                          item.moduleValue,
                                          item.numeracyBooklet,
                                          item.numeracyValue,
                                          item.pairValue,
                                          item.alfaActivityValue,
                                          item.alfaGradeReport,
                                          item.imgAlfa,
                                          item.refresherTrainingValue,
                                          item.noTrainedTeacher,
                                          item.imgTraining,
                                          item.readingValue,
                                          item.libGradeReport,
                                          item.imgLibrary,
                                          item.tlmKitValue,
                                          item.imgTlm,
                                          item.classObservation,
                                          item.createdAt,
                                          item.submittedAt,
                                          item.createdBy,
                                          item.id,

                                          (progress) {
                                            syncProgress.value = progress; // Update sync progress
                                          },
                                        );

                                        if (rsp['status'] == 1) {
                                          customSnackbar(
                                            'Successfully',
                                            "${rsp['message']}",
                                            AppColors.secondary,
                                            AppColors.onSecondary,
                                            Icons.check,
                                          );
                                        } else {
                                          hasError.value = true; // Set error state if sync fails
                                          customSnackbar(
                                            "Error",
                                            "${rsp['message']}",
                                            AppColors.error,
                                            AppColors.onError,
                                            Icons.warning,
                                          );
                                        }
                                        setState(() {
                                          isLoading.value = false; // Hide loading spinner
                                        });
                                      }
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          alfaObservationController.alfaObservationList[index].tourId;
                        },
                      );
                    },
                  ),
                ),
              ],
            ));
          },
        ),
      ),
    );
  }
}


var baseurl = "https://mis.17000ft.org/17000ft_apis/alfaObservation/insert_alfa.php";


Future<Map<String, dynamic>> insertAlfaObservation(
    String? tourId,
    String? school,
    String? udiseValue,
    String? correctUdise,
    String? noStaffTrained,
    String? imgNurTimeTable,
    String? imgLKGTimeTable,
    String? imgUKGTimeTable,
    String? bookletValue,
    String? moduleValue,
    String? numeracyBooklet,
    String? numeracyValue,
    String? pairValue,
    String? alfaActivityValue,
    String? alfaGradeReport,
    String? imgAlfa,
    String? refresherTrainingValue,
    String? noTrainedTeacher,
    String? imgTraining,
    String? readingValue,
    String? libGradeReport,
    String? imgLibrary,
    String? tlmKitValue,
    String? imgTLM,
    String? classObservation,
    String? createdAt,
    String? submittedAt,
    String? createdBy,
    int? id,
    Function(double) updateProgress, // Progress callback
    ) async {
  if (kDebugMode) {
    print('Inserting Alfa Observation Data');
    print('tourId: $tourId');
    print('school: $school');
    print('id: $id');
    print('udiseValue: $udiseValue');
    print('correctUdise: $correctUdise');
    print('noStaffTrained: $noStaffTrained');
    print('imgNurTimeTable: $imgNurTimeTable');
    print('imgLKGTimeTable: $imgLKGTimeTable');
    print('imgUKGTimeTable: $imgUKGTimeTable');
    print('bookletValue: $bookletValue');
    print('moduleValue: $moduleValue');
    print('numeracyBooklet: $numeracyBooklet');
    print('numeracyValue: $numeracyValue');
    print('pairValue: $pairValue');
    print('alfaActivityValue: $alfaActivityValue');
    print('alfaGradeReport: $alfaGradeReport');
    print('imgAlfa: $imgAlfa');
    print('refresherTrainingValue: $refresherTrainingValue');
    print('noTrainedTeacher: $noTrainedTeacher');
    print('imgTraining: $imgTraining');
    print('readingValue: $readingValue');
    print('libGradeReport: $libGradeReport');
    print('imgLibrary: $imgLibrary');
    print('tlmKitValue: $tlmKitValue');
    print('imgTLM: $imgTLM');
    print('classObservation: $classObservation');
    print('createdAt: $createdAt');
    print('submittedAt: $submittedAt');
    print('createdBy: $createdBy');

  }

  var request = http.MultipartRequest(
    'POST',
    Uri.parse(baseurl),
  );
  request.headers["Accept"] = "Application/json";


  // Ensure enrolmentData is a valid JSON string
  final String alfaGradeReportJsonData = alfaGradeReport ?? '';
  final String libGradeReportJsonData = libGradeReport ?? '';

  // Add text fields
  request.fields.addAll({

    'tourId': tourId ?? '',
    'school': school ?? '',
    'udiseValue': udiseValue ?? '',
    'correctUdise': correctUdise ?? '',
    'noStaffTrained': noStaffTrained ?? '',
    'bookletValue': bookletValue ?? '',
    'moduleValue': moduleValue ?? '',
    'numeracyBooklet': numeracyBooklet ?? '',
    'numeracyValue': numeracyValue ?? '',
    'pairValue': pairValue ?? '',
    'alfaActivityValue': alfaActivityValue ?? '',
    'alfaGradeReport': alfaGradeReportJsonData ?? '',
    'refresherTrainingValue': refresherTrainingValue ?? '',
    'noTrainedTeacher': noTrainedTeacher ?? '',
    'readingValue': readingValue ?? '',
    'libGradeReport': libGradeReportJsonData ?? '',
    'tlmKitValue': tlmKitValue ?? '',
    'classObservation': classObservation ?? '',
    'createdAt': createdAt ?? '',
    'submittedAt': submittedAt ?? '',
    'createdBy': createdBy ?? '',
    'id': id?.toString() ?? '',

  });

  try {
    if ( imgNurTimeTable!= null && imgNurTimeTable.isNotEmpty) {
      List<String> imagePaths = imgNurTimeTable.split(',');

      for (String path in imagePaths) {
        File imageFile = File(path.trim());
        if (imageFile.existsSync()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'imgNurTimeTable[]', // Use array-like name for multiple images
              imageFile.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
          print("Image file $path attached successfully.");
        } else {
          print('Image file does not exist at the path: $path');
          return {"status": 0, "message": "Image file not found at $path."};
        }
      }
    } else {
      print('No image file path provided.');
    }

    if ( imgLKGTimeTable!= null && imgLKGTimeTable.isNotEmpty) {
      List<String> imagePaths = imgLKGTimeTable.split(',');

      for (String path in imagePaths) {
        File imageFile = File(path.trim());
        if (imageFile.existsSync()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'imgLKGTimeTable[]', // Use array-like name for multiple images
              imageFile.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
          print("Image file $path attached successfully.");
        } else {
          print('Image file does not exist at the path: $path');
          return {"status": 0, "message": "Image file not found at $path."};
        }
      }
    } else {
      print('No image file path provided.');
    }


    if ( imgUKGTimeTable!= null && imgUKGTimeTable.isNotEmpty) {
      List<String> imagePaths = imgUKGTimeTable.split(',');

      for (String path in imagePaths) {
        File imageFile = File(path.trim());
        if (imageFile.existsSync()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'imgUKGTimeTable[]', // Use array-like name for multiple images
              imageFile.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
          print("Image file $path attached successfully.");
        } else {
          print('Image file does not exist at the path: $path');
          return {"status": 0, "message": "Image file not found at $path."};
        }
      }
    } else {
      print('No image file path provided.');
    }



    if ( imgAlfa!= null && imgAlfa.isNotEmpty) {
      List<String> imagePaths = imgAlfa.split(',');

      for (String path in imagePaths) {
        File imageFile = File(path.trim());
        if (imageFile.existsSync()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'imgAlfa[]', // Use array-like name for multiple images
              imageFile.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
          print("Image file $path attached successfully.");
        } else {
          print('Image file does not exist at the path: $path');
          return {"status": 0, "message": "Image file not found at $path."};
        }
      }
    } else {
      print('No image file path provided.');
    }


    if ( imgTraining!= null && imgTraining.isNotEmpty) {
      List<String> imagePaths = imgTraining.split(',');

      for (String path in imagePaths) {
        File imageFile = File(path.trim());
        if (imageFile.existsSync()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'imgTraining[]', // Use array-like name for multiple images
              imageFile.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
          print("Image file $path attached successfully.");
        } else {
          print('Image file does not exist at the path: $path');
          return {"status": 0, "message": "Image file not found at $path."};
        }
      }
    } else {
      print('No image file path provided.');
    }



    if ( imgLibrary!= null && imgLibrary.isNotEmpty) {
      List<String> imagePaths = imgLibrary.split(',');

      for (String path in imagePaths) {
        File imageFile = File(path.trim());
        if (imageFile.existsSync()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'imgLibrary[]', // Use array-like name for multiple images
              imageFile.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
          print("Image file $path attached successfully.");
        } else {
          print('Image file does not exist at the path: $path');
          return {"status": 0, "message": "Image file not found at $path."};
        }
      }
    } else {
      print('No image file path provided.');
    }

    if ( imgTLM!= null && imgTLM.isNotEmpty) {
      List<String> imagePaths = imgTLM.split(',');

      for (String path in imagePaths) {
        File imageFile = File(path.trim());
        if (imageFile.existsSync()) {
          request.files.add(
            await http.MultipartFile.fromPath(
              'imgTLM[]', // Use array-like name for multiple images
              imageFile.path,
              contentType: MediaType('image', 'jpeg'),
            ),
          );
          print("Image file $path attached successfully.");
        } else {
          print('Image file does not exist at the path: $path');
          return {"status": 0, "message": "Image file not found at $path."};
        }
      }
    } else {
      print('No image file path provided.');
    }


    // Send the request to the server
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    print('Server Response Body: $responseBody'); // Print the raw response

    if (response.statusCode == 200) {
      if (responseBody.isEmpty) {
        return {"status": 0, "message": "Empty response from server"};
      }

      try {
        var parsedResponse = json.decode(responseBody);

        if (parsedResponse['status'] == 1) {
          // Remove record from local database
          await SqfliteDatabaseHelper().queryDelete(
            arg: id.toString(),
            table: 'alfaObservation',
            field: 'id',
          );
          print("Record with id $id deleted from local database.");

          // Refresh data
          await Get.find<AlfaObservationController>().fetchData();

          return parsedResponse;
        } else {
          print('Server Response Error: ${parsedResponse['message']}');
          return {"status": 0, "message": parsedResponse['message'] ?? 'Failed to insert data'};
        }
      } catch (e) {
        print('Error decoding JSON: $e');
        return {"status": 0, "message": "Invalid response format $e"};
      }
    } else {
      print('Server Error Response Code: ${response.statusCode}');
      print('Server Error Response Body: $responseBody');
      return {"status": 0, "message": "Server returned an error $responseBody"};
    }
  } catch (error) {
    print("Error: $error");
    return {"status": 0, "message": "Something went wrong, Please contact Admin $error"};
  }
}
