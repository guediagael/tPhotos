import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tphotos/ui/widgets/dialogs/dialog_alert.dart';

Future<bool> _checkImagePermission(BuildContext context) async {
  return _checkPermission(context, Permission.photos);
}

Future<bool> _checkVideoPermission(BuildContext context) async {
  return _checkPermission(context, Permission.videos);
}

Future<bool> checkStoragePermission(BuildContext context) async {
  if (Platform.isAndroid) {
    AndroidDeviceInfo deviceInfo = await DeviceInfoPlugin().androidInfo;
    if (deviceInfo.version.sdkInt >= 33) {
      return _checkImagePermission(context).then((imagePermission) {
        return _checkVideoPermission(context).then((videoPermission) {
          return imagePermission || videoPermission;
        });
      });
    }
  }

  return _checkPermission(context, Permission.storage);
}

Future<bool> _checkPermission(
    BuildContext context, Permission permission) async {
  bool permissionGranted = await permission.isGranted;
  if (!permissionGranted) {
    bool shouldShowRationale =
        await Permission.storage.shouldShowRequestRationale;
    if (shouldShowRationale) {
      await _showRationale(
          context: context, onOkPressed: () => Navigator.of(context).pop());
    }
    bool shouldOpenSettings = await permission.isPermanentlyDenied;
    if (shouldOpenSettings) {
      await _showRationale(
          context: context,
          onOkPressed: () {
            openAppSettings().then((value) {
              if (value != false) {
                return false;
              }
            });
          });
    }
    return _requestPermission();
  }
  return permissionGranted;
}

Future<bool> _requestPermission() async {
  PermissionStatus status = await Permission.storage.request();
  return status == PermissionStatus.granted;
}

Future<void> _showRationale(
    {required Function onOkPressed, required context}) async {
  return showDialog(
      context: context,
      builder: (ctx) => DialogAlert(
            alertMessage:
                "This app needs to write photos to your device to function correctly",
            onOkayPressed: onOkPressed,
            alertTitle: "Storage Permission",
          ));
}
