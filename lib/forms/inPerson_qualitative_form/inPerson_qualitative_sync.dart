import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart'; // for MediaType
import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_dialog.dart';
import 'package:app17000ft_new/components/custom_snackbar.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/forms/fln_observation_form/fln_observation_controller.dart';
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

import 'inPerson_qualitative_controller.dart';

class InpersonQualitativeSync extends StatefulWidget {
  const InpersonQualitativeSync({super.key});

  @override
  State<InpersonQualitativeSync> createState() => _InpersonQualitativeSync();
}

class _InpersonQualitativeSync extends State<InpersonQualitativeSync> {
  final InpersonQualitativeController _inpersonQualitativeController =
  Get.put(InpersonQualitativeController());
  final NetworkManager _networkManager = Get.put(NetworkManager());
  var isLoading = false.obs;
  var syncProgress = 0.0.obs; // Progress variable for syncing
  var hasError = false.obs; // Variable to track if syncing failed

  @override
  void initState() {
    super.initState();
    _inpersonQualitativeController.fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        bool shouldPop =
        await BaseClient().showLeaveConfirmationDialog(context);
        return shouldPop;
      },
      child: Scaffold(
        appBar: const CustomAppbar(title: 'In-Person Qualitative Sync'),
        body: GetBuilder<InpersonQualitativeController>(
          builder: (inpersonQualitativeController) {
            if (inpersonQualitativeController.inPersonQualitativeList.isEmpty) {
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
                    separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
                    itemCount: inpersonQualitativeController
                        .inPersonQualitativeList.length,
                    itemBuilder: (context, index) {
                      final item = inpersonQualitativeController
                          .inPersonQualitativeList[index];
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
                                        var rsp = await insertInPersonQualitative(
                                          item.tourId,
                                          item.school,
                                          item.udicevalue,
                                          item.correct_udice,
                                          item.imgPath,
                                          item.school_digiLab,
                                          item.school_library,
                                          item.school_playground,
                                          item.hm_interview,
                                          item.hm_reason,
                                          item.hmques1,
                                          item.hmques2,
                                          item.hmques3,
                                          item.hmques4,
                                          item.hmques5,
                                          item.hmques6,
                                          item.hmques6_1,
                                          item.hmques7,
                                          item.hmques8,
                                          item.hmques9,
                                          item.hmques10,
                                          item.steacher_interview,
                                          item.steacher_reason,
                                          item.stques1,
                                          item.stques2,
                                          item.stques3,
                                          item.stques4,
                                          item.stques5,
                                          item.stques6,
                                          item.stques6_1,
                                          item.stques7,
                                          item.stques7_1,
                                          item.stques8,
                                          item.stques8_1,
                                          item.stques9,
                                          item.student_interview,
                                          item.student_reason,
                                          item.stuques1,
                                          item.stuques2,
                                          item.stuques3,
                                          item.stuques4,
                                          item.stuques5,
                                          item.stuques6,
                                          item.stuques7,
                                          item.stuques8,
                                          item.stuques9,
                                          item.stuques10,
                                          item.stuques11,
                                          item.stuques11_1,
                                          item.stuques11_2,
                                          item.stuques11_3,
                                          item.stuques12,
                                          item.smc_interview,
                                          item.smc_reason,
                                          item.smcques1,
                                          item.smcques2,
                                          item.smcques3,
                                          item.smcques3_1,
                                          item.smcques3_2,
                                          item.smcques_4,
                                          item.smcques4_1,
                                          item.smcques_5,
                                          item.smcques_6,
                                          item.smcques_7,
                                          item.created_at,
                                          item.submitted_at,
                                          item.submitted_by,
                                          item.unique_id,
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
                          inpersonQualitativeController
                              .inPersonQualitativeList[index].tourId;
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


var baseurl = "https://mis.17000ft.org/apis/fast_apis/insert_qualitative.php";



Future insertInPersonQualitative(
    String? tourId,
    String? school,
    String? udicevalue,
    String? correct_udice,
    String? imgPath,
    String? school_digiLab,
    String? school_library,
    String? school_playground,
    String? hm_interview,
    String? hm_reason,
    String? hmques1,
    String? hmques2,
    String? hmques3,
    String? hmques4,
    String? hmques5,
    String? hmques6,
    String? hmques6_1,
    String? hmques7,
    String? hmques8,
    String? hmques9,
    String? hmques10,
    String? steacher_interview,
    String? steacher_reason,
    String? stques1,
    String? stques2,
    String? stques3,
    String? stques4,
    String? stques5,
    String? stques6,
    String? stques6_1,
    String? stques7,
    String? stques7_1,
    String? stques8,
    String? stques8_1,
    String? stques9,
    String? student_interview,
    String? student_reason,
    String? stuques1,
    String? stuques2,
    String? stuques3,
    String? stuques4,
    String? stuques5,
    String? stuques6,
    String? stuques7,
    String? stuques8,
    String? stuques9,
    String? stuques10,
    String? stuques11,
    String? stuques11_1,
    String? stuques11_2,
    String? stuques11_3,
    String? stuques12,
    String? smc_interview,
    String? smc_reason,
    String? smcques1,
    String? smcques2,
    String? smcques3,
    String? smcques3_1,
    String? smcques3_2,
    String? smcques_4,
    String? smcques4_1,
    String? smcques_5,
    String? smcques_6,
    String? smcques_7,
    String? created_at,
    String? submitted_at,
    String? submitted_by,
    String? unique_id,
    int? id,
    Function(double) updateProgress, // Progress callback
    ) async {
  if (kDebugMode) {
    print('This is InPerson Qualitative Data');
    print('Tour ID: $tourId');
    print('School: $school');
    print('UDICE Value: $udicevalue');
    print('Correct UDICE: $correct_udice');
    print('Base64 Images: $imgPath');
    print('School Digital Lab: $school_digiLab');
    print('School Library: $school_library');
    print('School Playground: $school_playground');
    print('HM Interview: $hm_interview');
    print('HM Reason: $hm_reason');
    print('HM Question 1: $hmques1');
    print('HM Question 2: $hmques2');
    print('HM Question 3: $hmques3');
    print('HM Question 4: $hmques4');
    print('HM Question 5: $hmques5');
    print('HM Question 6: $hmques6');
    print('HM Question 6_1: $hmques6_1');
    print('HM Question 7: $hmques7');
    print('HM Question 8: $hmques8');
    print('HM Question 9: $hmques9');
    print('HM Question 10: $hmques10');
    print('STeacher Interview: $steacher_interview');
    print('STeacher Reason: $steacher_reason');
    print('STeacher Question 1: $stques1');
    print('STeacher Question 2: $stques2');
    print('STeacher Question 3: $stques3');
    print('STeacher Question 4: $stques4');
    print('STeacher Question 5: $stques5');
    print('STeacher Question 6: $stques6');
    print('STeacher Question 6_1: $stques6_1');
    print('STeacher Question 7: $stques7');
    print('STeacher Question 7_1: $stques7_1');
    print('STeacher Question 8: $stques8');
    print('STeacher Question 8_1: $stques8_1');
    print('STeacher Question 9: $stques9');
    print('Student Interview: $student_interview');
    print('Student Reason: $student_reason');
    print('Student Question 1: $stuques1');
    print('Student Question 2: $stuques2');
    print('Student Question 3: $stuques3');
    print('Student Question 4: $stuques4');
    print('Student Question 5: $stuques5');
    print('Student Question 6: $stuques6');
    print('Student Question 7: $stuques7');
    print('Student Question 8: $stuques8');
    print('Student Question 9: $stuques9');
    print('Student Question 10: $stuques10');
    print('Student Question 11: $stuques11');
    print('Student Question 11_1: $stuques11_1');
    print('Student Question 11_2: $stuques11_2');
    print('Student Question 11_3: $stuques11_3');
    print('Student Question 12: $stuques12');
    print('SMC Interview: $smc_interview');
    print('SMC Reason: $smc_reason');
    print('SMC Question 1: $smcques1');
    print('SMC Question 2: $smcques2');
    print('SMC Question 3: $smcques3');
    print('SMC Question 3_1: $smcques3_1');
    print('SMC Question 3_2: $smcques3_2');
    print('SMC Question 4: $smcques_4');
    print('SMC Question 4_1: $smcques4_1');
    print('SMC Question 5: $smcques_5');
    print('SMC Question 6: $smcques_6');
    print('SMC Question 7: $smcques_7');
    print('Created At: $created_at');
    print('Submitted At: $submitted_at');
    print('Submitted By: $submitted_by');
    print('Unique ID: $unique_id');
    print('ID: $id');

  }

  var request = http.MultipartRequest('POST', Uri.parse(baseurl));
  request.headers["Accept"] = "application/json";

  // Add form fields with null checks
  request.fields.addAll({
    'tourId': tourId ?? '',
    'school': school ?? '',
    'udicevalue': udicevalue ?? '',
    'correct_udice': correct_udice ?? '',
    'school_digiLab': school_digiLab ?? '',
    'school_library': school_library ?? '',
    'school_playground': school_playground ?? '',
    'hm_interview': hm_interview ?? '',
    'hm_reason': hm_reason ?? '',
    'hmques1': hmques1 ?? '',
    'hmques2': hmques2 ?? '',
    'hmques3': hmques3 ?? '',
    'hmques4': hmques4 ?? '',
    'hmques5': hmques5 ?? '',
    'hmques6': hmques6 ?? '',
    'hmques6_1': hmques6_1 ?? '',
    'hmques7': hmques7 ?? '',
    'hmques8': hmques8 ?? '',
    'hmques9': hmques9 ?? '',
    'hmques10': hmques10 ?? '',
    'steacher_interview': steacher_interview ?? '',
    'steacher_reason': steacher_reason ?? '',
    'stques1': stques1 ?? '',
    'stques2': stques2 ?? '',
    'stques3': stques3 ?? '',
    'stques4': stques4 ?? '',
    'stques5': stques5 ?? '',
    'stques6': stques6 ?? '',
    'stques6_1': stques6_1 ?? '',
    'stques7': stques7 ?? '',
    'stques7_1': stques7_1 ?? '',
    'stques8': stques8 ?? '',
    'stques8_1': stques8_1 ?? '',
    'stques9': stques9 ?? '',
    'student_interview': student_interview ?? '',
    'student_reason': student_reason ?? '',
    'stuques1': stuques1 ?? '',
    'stuques2': stuques2 ?? '',
    'stuques3': stuques3 ?? '',
    'stuques4': stuques4 ?? '',
    'stuques5': stuques5 ?? '',
    'stuques6': stuques6 ?? '',
    'stuques7': stuques7 ?? '',
    'stuques8': stuques8 ?? '',
    'stuques9': stuques9 ?? '',
    'stuques10': stuques10 ?? '',
    'stuques11': stuques11 ?? '',
    'stuques11_1': stuques11_1 ?? '',
    'stuques11_2': stuques11_2 ?? '',
    'stuques11_3': stuques11_3 ?? '',
    'stuques12': stuques12 ?? '',
    'smc_interview': smc_interview ?? '',
    'smc_reason': smc_reason ?? '',
    'smcques1': smcques1 ?? '',
    'smcques2': smcques2 ?? '',
    'smcques3': smcques3 ?? '',
    'smcques3_1': smcques3_1 ?? '',
    'smcques3_2': smcques3_2 ?? '',
    'smcques_4': smcques_4 ?? '',
    'smcques4_1': smcques4_1 ?? '',
    'smcques_5': smcques_5 ?? '',
    'smcques_6': smcques_6 ?? '',
    'smcques_7': smcques_7 ?? '',
    'created_at': created_at ?? '',
    'submitted_at': submitted_at ?? '',
    'submitted_by': submitted_by ?? '',
    'unique_id': unique_id ?? '',
    'id': id?.toString() ?? '',
  });


  if ( imgPath!= null && imgPath.isNotEmpty) {
    List<String> imagePaths = imgPath.split(',');

    for (String path in imagePaths) {
      File imageFile = File(path.trim());
      if (imageFile.existsSync()) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'image[]', // Use array-like name for multiple images
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

  try {
    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    print('Raw response body: $responseBody');

    // Check if the response body contains HTML (which suggests an issue with the server)
    if (responseBody.contains('<br />') || responseBody.contains('<b>')) {
      print("HTML error response detected.");
      return {"status": 0, "message": "Server returned HTML instead of JSON. Please check the API."};
    }

    // Try parsing the response as JSON
    var parsedResponse = json.decode(responseBody);

    if (parsedResponse['status'] == 1) {
      // If successfully inserted, delete from local database
      await SqfliteDatabaseHelper().queryDelete(
        arg: id.toString(),
        table: 'inPerson_Qualitative',
        field: 'id',
      );
      print("Record with id $id deleted from local database.");
      await Get.find<InpersonQualitativeController>().fetchData();
    }

    return parsedResponse;
  } catch (responseBody) {
    print("Error: $responseBody");
    return {"status": 0, "message": "Something went wrong, Please contact Admin $responseBody"};
  }
}
