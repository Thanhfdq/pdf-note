import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileHelper {
  // Write to any specified path
  static Future<void> writeFile(String filePath, String content) async {
    try {
      final file = File(filePath);
      await file.writeAsString(content);
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
  static Future<void> deleteFile(String filePath) async {
    try {
      final file = File(filePath);
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

  // Pick a file using File Picker
  static Future<String> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
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
}
