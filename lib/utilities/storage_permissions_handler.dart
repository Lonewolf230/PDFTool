// import 'dart:async';
// import 'dart:io';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:device_info_plus/device_info_plus.dart';

// class StoragePermissionHandler {
//   Future<bool> requestStoragePermissions() async {
//     // Check Android version
//     if (Platform.isAndroid) {
//       final androidInfo = await DeviceInfoPlugin().androidInfo;
//       if (androidInfo.version.sdkInt >= 30) {
//         // Android 11 (API 30) and above
//         final status = await Permission.manageExternalStorage.status;
//         if (status.isDenied) {
//           final result = await Permission.manageExternalStorage.request();
//           return result.isGranted;
//         }
//         return status.isGranted;
//       } else {
//         // Below Android 11
//         final status = await Permission.storage.status;
//         if (status.isDenied) {
//           final result = await Permission.storage.request();
//           return result.isGranted;
//         }
//         return status.isGranted;
//       }
//     }
//     return true; // For iOS or other platforms
//   }

//   Future<void> openSettings() async {
//     final opened = await openAppSettings();
//     if (!opened) {
//       throw Exception('Could not open app settings');
//     }
//   }
// }

import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class StoragePermissionHandler {
  Future<bool> requestStoragePermissions() async {
    // Check Android version
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt >= 30) {
        // Android 11 (API 30) and above
        final status = await Permission.manageExternalStorage.status;
        if (status.isDenied) {
          final result = await Permission.manageExternalStorage.request();
          return result.isGranted;
        }
        return status.isGranted;
      } else {
        // Below Android 11
        final status = await Permission.storage.status;
        if (status.isDenied) {
          final result = await Permission.storage.request();
          return result.isGranted;
        }
        return status.isGranted;
      }
    }
    return true; // For iOS or other platforms
  }

  Future<void> openSettings() async {
    final opened = await openAppSettings();
    if (!opened) {
      throw Exception('Could not open app settings');
    }
  }
}
