import 'dart:convert';
import 'dart:io';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment.dart';
import 'package:http_parser/http_parser.dart'; // for MediaType
import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_dialog.dart';
import 'package:app17000ft_new/components/custom_snackbar.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/school_enrolment/school_enrolment_controller.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:app17000ft_new/services/network_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class EnrolmentSync extends StatefulWidget {
  const EnrolmentSync({super.key});

  @override
  State<EnrolmentSync> createState() => _EnrolmentSyncState();
}

class _EnrolmentSyncState extends State<EnrolmentSync> {
  final SchoolEnrolmentController _schoolEnrolmentController = Get.put(SchoolEnrolmentController());
  final NetworkManager _networkManager = Get.put(NetworkManager());
  var isLoading = false.obs;
  var syncProgress = 0.0.obs; // Progress variable for syncing
  var hasError = false.obs; // Variable to track if syncing failed

  @override
  void initState() {
    super.initState();
    _schoolEnrolmentController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
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
        appBar: const CustomAppbar(title: 'Enrollment Sync'),
        body: GetBuilder<SchoolEnrolmentController>(
          builder: (schoolEnrolmentController) {
            if (schoolEnrolmentController.enrolmentList.isEmpty) {
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
                  if (hasError.value) // Show error message if syncing failed
                    const Text(
                      'Syncing failed. Please try again.',
                      style: TextStyle(color: Colors.red, fontSize: 16),
                    ),
                ],
              ),
            )
                : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                    itemCount: schoolEnrolmentController.enrolmentList.length,
                    itemBuilder: (context, index) {
                      final item = schoolEnrolmentController.enrolmentList[index];
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
                            // IconButton(
                            //   color: AppColors.primary,
                            //   icon: const Icon(Icons.edit),
                            //   onPressed: () async {
                            //     final existingRecord =
                            //     schoolEnrolmentController.enrolmentList[index];
                            //
                            //     // Show confirmation dialog before navigating
                            //     bool? shouldNavigate = await showDialog<bool>(
                            //       context: context,
                            //       builder: (_) => Confirmation(
                            //         iconname: Icons.edit,
                            //         title: 'Confirm Update',
                            //         yes: 'Confirm',
                            //         no: 'Cancel',
                            //         desc: 'Are you sure you want to Update this record?',
                            //         onPressed: () {
                            //           Navigator.of(context).pop(true);
                            //         },
                            //       ),
                            //     );
                            //
                            //     if (shouldNavigate == true) {
                            //       await Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //           builder: (context) => SchoolEnrollmentForm(
                            //             userid: 'userid',
                            //             existingRecord: existingRecord,
                            //           ),
                            //         ),
                            //       );
                            //     }
                            //   },
                            // ),
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
                                        var rsp = await insertEnrolment(
                                          item.tourId,
                                          item.school,
                                          item.registerImage, // Multiple paths now handled
                                          item.enrolmentData,
                                          item.remarks,
                                          item.createdAt,
                                          item.submittedBy,
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
                          schoolEnrolmentController.enrolmentList[index].tourId;
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

// Insert Enrollment with multiple image paths handling
const String baseUrl = "https://mis.17000ft.org/apis/fast_apis/enrollmentCollection.php";

Future<Map<String, dynamic>> insertEnrolment(
    String? tourId,
    String? school,
    String? registerImagePaths, // Multiple image paths
    String? enrolmentData,
    String? remarks,
    String? createdAt,
    String? submittedBy,
    int? id,
    Function(double) updateProgress, // Progress callback
    ) async {
  print('Starting School Enrollment Data Insertion');

  var request = http.MultipartRequest('POST', Uri.parse(baseUrl));
  request.headers["Accept"] = "application/json";

  // Add fields
  request.fields.addAll({
    'id': id?.toString() ?? '',
    'tourId': tourId ?? '',
    'school': school ?? '',
    'enrolmentData': enrolmentData ?? '',
    'remarks': remarks ?? '',
    'createdAt': createdAt ?? '',
    'submittedBy': submittedBy ?? '',
  });

  // Attach multiple image files
  if (registerImagePaths != null && registerImagePaths.isNotEmpty) {
    List<String> imagePaths = registerImagePaths.split(',');

    for (String path in imagePaths) {
      File imageFile = File(path.trim());
      if (imageFile.existsSync()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'registerImage[]', // Use array-like name for multiple images
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

  print('Server Response Body: $responseBody');

  if (response.statusCode == 200) {
    try {
      var parsedResponse = json.decode(responseBody);
      if (parsedResponse['status'] == 1) {
        // Delete local record if sync is successful
        await SqfliteDatabaseHelper().queryDelete(
          arg: id.toString(),
          table: 'schoolEnrolment',
          field: 'id',
        );
        print("Record with id $id deleted from local database.");

        // Refresh data
        await Get.find<SchoolEnrolmentController>().fetchData();
        return parsedResponse;
      } else {
        print('Error: ${parsedResponse['message']}');
        return {"status": 0, "message": parsedResponse['message'] ?? 'Failed to insert data'};
      }
    } catch (e) {
      print('Error parsing response: $e');
      return {"status": 0, "message": "Invalid response format"};
    }
  } else {
    print('Server error: ${response.statusCode}');
    return {"status": 0, "message": "Server returned error $responseBody"};
  }
}
