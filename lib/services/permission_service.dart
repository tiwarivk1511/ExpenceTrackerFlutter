import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> _requestPermission(Permission permission) async {
    final status = await permission.request();
    return status == PermissionStatus.granted;
  }

  Future<bool> requestCameraPermission() async {
    return await _requestPermission(Permission.camera);
  }

  Future<bool> requestStoragePermission() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        return await _requestPermission(Permission.storage);
      } else {
        return await _requestPermission(Permission.photos);
      }
    } else {
      // For iOS and other platforms, we can just request photos permission
      return await _requestPermission(Permission.photos);
    }
  }
}
