// ignore_for_file: file_names
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:universal_html/html.dart' as html;

import '../utils/helper.dart';

class FileManagerHandler {
  static Future<File?> saveFile({
    required String name,
    required dynamic data,
  }) async {
    String? filePath = await getFilePath(
      name: name,
    );

    if (filePath == null) {
      return null;
    }
    File file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }

    return file.writeAsBytes(data);
  }

  static void saveFileInWeb(List<int> bytes, String fileName) {
    html.AnchorElement(
      href: html.Url.createObjectUrlFromBlob(
        html.Blob([bytes], 'application/octet-stream'),
      ),
    )
      ..setAttribute('download', fileName)
      ..click();
  }

  static Future<String?> getFilePath({
    required String name,
  }) async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

    if (selectedDirectory == null) {
      return null;
    }
    Helper.log('$selectedDirectory/$name');
    return '$selectedDirectory/$name';
  }
}
