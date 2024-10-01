import 'dart:convert';
import 'dart:io';
import 'package:http_parser/http_parser.dart'; // for MediaType
import 'package:app17000ft_new/base_client/base_client.dart';
import 'package:app17000ft_new/components/custom_appBar.dart';
import 'package:app17000ft_new/components/custom_dialog.dart';
import 'package:app17000ft_new/components/custom_snackbar.dart';
import 'package:app17000ft_new/constants/color_const.dart';
import 'package:app17000ft_new/helper/database_helper.dart';
import 'package:app17000ft_new/services/network_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import 'cab_meter_tracing_controller.dart';

class CabTracingSync extends StatefulWidget {
  const CabTracingSync({super.key});

  @override
  State<CabTracingSync> createState() => _CabTracingSyncState();
}

class _CabTracingSyncState extends State<CabTracingSync> {
  final CabMeterTracingController _cabMeterTracingController = Get.put(CabMeterTracingController());
  final NetworkManager _networkManager = Get.put(NetworkManager());
  var isLoading = false.obs;
  var syncProgress = 0.0.obs; // Progress variable for syncing
  var hasError = false.obs; // Variable to track if syncing failed

  @override
  void initState() {
    super.initState();
    _cabMeterTracingController.fetchData();
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
        appBar: const CustomAppbar(title: 'Cab Meter Tracing Sync'),
        body: GetBuilder<CabMeterTracingController>(
          builder: (cabMeterTracingController) {
            if (cabMeterTracingController.cabMeterTracingList.isEmpty) {
              return const Center(
                child: Text(
                  'No Records Found',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
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
                    itemCount: cabMeterTracingController.cabMeterTracingList.length,
                    itemBuilder: (context, index) {
                      final item = cabMeterTracingController.cabMeterTracingList[index];
                      return ListTile(
                        title: Text(
                          "${index + 1}. Tour ID: ${item.tour_id}\n"
                              "Vehicle No.: ${item.vehicle_num}\n"
                              "Driver Name: ${item.driver_name}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,  // Adjust text alignment if needed
                          maxLines: 3,  // Limit the lines, or remove this if you don't want a limit
                          overflow: TextOverflow.ellipsis,  // Handles overflow gracefully
                        ),
                        trailing: Obx(() => Row(
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
                                        var rsp = await insertCabMeterTracing(
                                          item.id,
                                          item.status,
                                          item.vehicle_num,
                                          item.driver_name,
                                          item.meter_reading,
                                          item.image,
                                          item.user_id,
                                          item.place_visit,
                                          item.remarks,
                                          item.created_at,
                                          item.office,
                                          item.version,
                                          item.uniqueId,
                                          item.tour_id,
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
                        )),
                        onTap: () {
                          cabMeterTracingController.cabMeterTracingList[index].tour_id;
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

var baseurl = "https://mis.17000ft.org/apis/fast_apis/insert_cabMeter.php";

// Update the insertCabMeterTracing function to accept a progress callback
Future<Map<String, dynamic>> insertCabMeterTracing(
    int? id,
    String? status,
    String? vehicle_num,
    String? driver_name,
    String? meter_reading,
    String? image,
    String? user_id,
    String? place_visit,
    String? remarks,
    String? created_at,
    String? office,
    String? version,
    String? uniqueId,
    String? tour_id,
    Function(double) updateProgress, // Progress callback
    ) async {
  var request = http.MultipartRequest('POST', Uri.parse(baseurl));
  request.headers["Accept"] = "application/json";

  request.fields.addAll({
    'id': id?.toString() ?? '',
    'status': status ?? '',
    'vehicle_num': vehicle_num ?? '',
    'driver_name': driver_name ?? '',
    'meter_reading': meter_reading ?? '',
    'user_id': user_id ?? '',
    'place_visit': place_visit ?? '',
    'remarks': remarks ?? '',
    'created_at': created_at ?? '',
    'office': office ?? '',
    'version': version ?? '1.0',
    'uniqueId': uniqueId ?? '',
    'tour_id': tour_id ?? '',
  });

  // Attach multiple image files
  if ( image!= null && image.isNotEmpty) {
    List<String> imagePaths = image.split(',');

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
    var parsedResponse = json.decode(responseBody);

    if (parsedResponse['status'] == 1) {
      await SqfliteDatabaseHelper().queryDelete(arg: id.toString(), table: 'cabMeter_tracing', field: 'id');
      return parsedResponse;
    } else {
      return {"status": 0, "message": "Error in API response"};
    }
  } catch (e) {
    return {"status": 0, "message": e.toString()};
  }
}
