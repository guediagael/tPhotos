import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tphotos/ui/widgets/dialogs/dialog_alert.dart';

Future<bool> checkStoragePermission(BuildContext context) async {
  bool permissionGranted = await Permission.storage.isGranted;
  if (!permissionGranted) {
    bool shouldShowRationale =
        await Permission.storage.shouldShowRequestRationale;
    if (shouldShowRationale) {
      await _showRationale(
          context: context, onOkPressed: () => Navigator.of(context).pop());
    }
    bool shouldOpenSettings = await Permission.storage.isPermanentlyDenied;
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
