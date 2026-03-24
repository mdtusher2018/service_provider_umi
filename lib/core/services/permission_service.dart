import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  Future<bool> requestCamera() => _request(Permission.camera);
  Future<bool> requestMicrophone() => _request(Permission.microphone);
  Future<bool> requestStorage() => _request(Permission.storage);
  Future<bool> requestPhotos() => _request(Permission.photos);
  Future<bool> requestNotification() => _request(Permission.notification);
  Future<bool> requestContacts() => _request(Permission.contacts);

  Future<bool> requestLocation() async {
    final status = await Permission.location.request();
    if (status.isGranted) return true;

    if (status.isDenied) {
      final retryStatus = await Permission.location.request();
      return retryStatus.isGranted;
    }

    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }

    return false;
  }

  Future<bool> requestLocationAlways() async {
    final whenInUse = await requestLocation();
    if (!whenInUse) return false;
    return _request(Permission.locationAlways);
  }

  Future<bool> checkCamera() => _check(Permission.camera);
  Future<bool> checkMicrophone() => _check(Permission.microphone);
  Future<bool> checkLocation() => _check(Permission.location);
  Future<bool> checkNotification() => _check(Permission.notification);
  Future<bool> checkPhotos() => _check(Permission.photos);

  Future<bool> requestCameraAndMicrophone() async {
    final statuses = await [Permission.camera, Permission.microphone].request();

    return statuses[Permission.camera]!.isGranted &&
        statuses[Permission.microphone]!.isGranted;
  }

  Future<bool> _request(Permission permission) async {
    final status = await permission.request();
    if (status.isPermanentlyDenied) {
      await openAppSettings();
      return false;
    }
    return status.isGranted;
  }

  Future<bool> _check(Permission permission) async {
    final status = await permission.status;
    return status.isGranted;
  }

  Future<void> openSettings() => openAppSettings();
}
