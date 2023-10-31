import 'dart:io';

import 'package:external_path/external_path.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter/widgets.dart';

Future<String?> getDirs(BuildContext context) async {
  var rootDirs = await ExternalPath.getExternalStorageDirectories();
  List<FilesystemPickerShortcut> shortcuts = [];
  for (var element in rootDirs) {
    shortcuts.add(
        FilesystemPickerShortcut(name: element, path: Directory(element)));
  }
  return FilesystemPicker.open(
    context: context,
    fsType: FilesystemType.folder,
    shortcuts: shortcuts,
  ).then((value) {
    if (value != null && value.isNotEmpty) {
      debugPrint("main_dispatcher::getDirs:: folder selected $value");

    }
    return value;
  });
}

List<FileSystemEntity> listFiles(String rootPath){
  Directory folder = Directory(rootPath);
  return folder.listSync(recursive: true);
}