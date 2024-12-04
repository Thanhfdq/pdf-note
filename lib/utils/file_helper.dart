import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path_dependency;
import 'package:pdf_note/providers/tab_mangager.dart';

class FileHelper {
  static String getPath(String fileName) {
    return TabsManager().defaultFileLocation + fileName;
  }

  static String getFileName(String filePath) {
    if (filePath.isEmpty) return "";
    String nameWithextension = path_dependency.basename(filePath);
    String justName =
        nameWithextension.substring(0, nameWithextension.lastIndexOf('.'));
    return justName;
  }

  // Write to any specified path
  static void writeFile(String filePath, String content) async {
    try {
      final file = File(filePath);
      await file.writeAsString(content);
      print("File written: $filePath");
    } catch (e) {
      print("Error writing file: $e");
    }
  }

  static void writeByte(String filePath, Uint8List byteData) async {
    try {
      final file = File(filePath);
      await file.writeAsBytes(byteData);
      print("File written: $filePath");
    } catch (e) {
      print("Error writing file: $e");
    }
  }

  // Read from any specified path
  static Future<String> readFile(String filePath) async {
    try {
      final file = File(filePath);
      String content = await file.readAsString();
      print("File read: $filePath");
      return content;
    } catch (e) {
      print("Error reading file: $e");
      return "";
    }
  }

  // Delete any file at a specified path
  static void deleteFile(String filePath) async {
    try {
      final file = File(getPath(filePath));
      if (await file.exists()) {
        await file.delete();
        print("File deleted: $filePath");
      } else {
        print("File does not exist: $filePath");
      }
    } catch (e) {
      print("Error deleting file: $e");
    }
  }

  static void renameFile(String oldPath, String newPath) async {
    try {
      // Create a File instance
      final file = File(oldPath);

      // Rename the file
      final renamedFile = await file.rename(newPath);

      print('File renamed successfully to: ${renamedFile.path}');
    } catch (e) {
      print('Error renaming file: $e');
    }
  }

  // Pick a file using File Picker
  static Future<String> pickFile(List<String> allowedExtensions) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: allowedExtensions);
    if (result != null) {
      String? filePath = result.files.single.path;
      if (filePath != null) {
        print("File selected: $filePath");
        return filePath;
      }
    }
    print("No file selected.");
    return "";
  }

  static Future<Uint8List> getAssetImageBytes(String imagePath) async {
    ByteData byteData = await rootBundle.load(imagePath);
    return byteData.buffer.asUint8List();
  }
}
