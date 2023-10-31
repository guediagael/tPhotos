import 'dart:io';


List<FileSystemEntity> listFiles(String rootPath){
  Directory folder = Directory(rootPath);
  return folder.listSync(recursive: true);
}