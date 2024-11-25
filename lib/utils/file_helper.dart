import 'dart:io';
import 'package:path_provider/path_provider.dart';

class FileHelper {
  static Future<String> getFilePath(String fileName) async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/$fileName';
  }

  static Future<void> writeFile(String fileName, String content) async {
    try {
      final path = await getFilePath(fileName);
      final file = File(path);
      await file.writeAsString(content);
      print("File written: $path");
    } catch (e) {
      print("Error writing file: $e");
    }
  }

  static Future<String> readFile(String fileName) async {
    try {
      final path = await getFilePath(fileName);
      print("Current path: ${path}");
      final file = File(path);
      String content = await file.readAsString();
      return content;
    } catch (e) {
      print("Error reading file: $e");
      return "";
    }
  }

  static Future<void> deleteFile(String fileName) async {
    try {
      final path = await getFilePath(fileName);
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        print("File deleted: $path");
      } else {
        print("File does not exist");
      }
    } catch (e) {
      print("Error deleting file: $e");
    }
  }
}
