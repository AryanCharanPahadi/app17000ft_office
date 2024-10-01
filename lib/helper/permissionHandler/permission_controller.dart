import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionController extends GetxController {
  var storagePermissionStatus = Rx<PermissionStatus>(PermissionStatus.denied);

  @override
  void onInit() {
    super.onInit();
    checkStoragePermission();
  }

  Future<void> checkStoragePermission() async {
    var status = await Permission.storage.status;
    storagePermissionStatus.value = status;
  }

    // Method to request storage permissions
  Future<bool> requestStoragePermission() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

}
