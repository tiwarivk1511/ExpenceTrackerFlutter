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
    // For Android 13 and above, this is handled by Photos permission
    // For older versions, it's storage permission
    if (await Permission.photos.isGranted) {
      return true;
    }
    return await _requestPermission(Permission.photos);
  }
}
