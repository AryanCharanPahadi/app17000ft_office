
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  Future<String> getDownloadDirectory() async {
    if (Platform.isAndroid) {
      Directory directory = Directory('/storage/emulated/0/Download');
      if (await directory.exists()) {
        return directory.path;
      } else {
        // In case the directory doesn't exist, create it
        directory = await Directory('/storage/emulated/0/Download').create(recursive: true);
        return directory.path;
      }
    } else if (Platform.isIOS) {
      // On iOS, using the application documents directory
      Directory directory = await getApplicationDocumentsDirectory();
      return directory.path;
    }
    throw UnsupportedError('Unsupported platform');
  }
    static Future<String> getExternalDocumentPath() async { 
    // To check whether permission is given for this app or not. 
    var status = await Permission.storage.status; 
    if (!status.isGranted) { 
      // If not we will ask for permission first 
      await Permission.storage.request(); 
    } 
    Directory directory = Directory(""); 
    if (Platform.isAndroid) { 
      // Redirects it to download folder in android 
      directory = Directory("/storage/emulated/0/Download"); 
    } else { 
      directory = await getApplicationDocumentsDirectory(); 
    } 

    final exPath = directory.path; 
    print("Saved Path: $exPath"); 
    await Directory(exPath).create(recursive: true); 
    return exPath; 
  } 

  static Future<String> get _localPath async { 
    // final directory = await getApplicationDocumentsDirectory(); 
    // return directory.path; 
    // To get the external path from device of download folder 
    final String directory = await getExternalDocumentPath(); 
    return directory; 
  } 

    static Future<File> writeCounter(String bytes,String name) async { 
    final path = await _localPath; 
    // Create a file for the path of 
    // device and file name with extension 
    File file = File('$path/$name');
    print("Save file"); 
    
    // Truncate the file to remove existing content before writing new data
    if (file.existsSync()) {
      await file.writeAsString('');
    }

    // Write the data in the file you have created 
    return file.writeAsString(bytes); 
  } 

  Future<void> saveFileToDownloads(String fileName, List<int> bytes) async {
    String dir = await getDownloadDirectory();
    File file = File('$dir/$fileName');
    await file.writeAsBytes(bytes);
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


// To save the file in the device 
class FileStorage { 
  static Future<String> getExternalDocumentPath() async { 
    // To check whether permission is given for this app or not. 
    var status = await Permission.storage.status; 
    if (!status.isGranted) { 
      // If not we will ask for permission first 
      await Permission.storage.request(); 
    } 
    Directory directory = Directory(""); 
    if (Platform.isAndroid) { 
      // Redirects it to download folder in android 
      directory = Directory("/storage/emulated/0/Download"); 
    } else { 
      directory = await getApplicationDocumentsDirectory(); 
    } 

    final exPath = directory.path; 
    print("Saved Path: $exPath"); 
    await Directory(exPath).create(recursive: true); 
    return exPath; 
  } 

  static Future<String> get _localPath async { 
    // final directory = await getApplicationDocumentsDirectory(); 
    // return directory.path; 
    // To get the external path from device of download folder 
    final String directory = await getExternalDocumentPath(); 
    return directory; 
  } 

  static Future<File> writeCounter(String bytes,String name) async { 
    final path = await _localPath; 
    // Create a file for the path of 
    // device and file name with extension 
    File file = File('$path/$name');
    print("Save file"); 
    
    // Truncate the file to remove existing content before writing new data
    if (file.existsSync()) {
      await file.writeAsString('');
    }

    // Write the data in the file you have created 
    return file.writeAsString(bytes); 
  } 
}