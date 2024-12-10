import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path_dependency;
import 'package:path_provider/path_provider.dart';
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

  static Future<Uint8List?> convertImageToUint8List(String filePath) async {
    try {
      // Create a File instance from the file path
      File imageFile = File(filePath);

      // Read the file as bytes
      Uint8List bytes = await imageFile.readAsBytes();

      return bytes;
    } catch (e) {
      print('Error converting image to Uint8List: $e');
      return null;
    }
  }

  Future<void> saveCacheFile(String fileName, String content) async {
    final directory = await getTemporaryDirectory();
    final file = File('${directory.path}/$fileName');
    await file.writeAsString(content);
  }

  Future<void> clearCache() async {
    final directory = await getTemporaryDirectory();
    if (directory.existsSync()) {
      directory.deleteSync(recursive: true);
    }
  }

  Future<String> generateImageCachePath() async {
    final cacheDir = await getTemporaryDirectory();
    return '${cacheDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
  }

  static Future<String> saveImageToCache(XFile image) async {
    final fileHelper = FileHelper();
    final savedImagePath = await fileHelper.generateImageCachePath();
    try {
      await File(image.path).copy(savedImagePath);
      print("saveImagePath: $savedImagePath");
      return savedImagePath;
    } catch (e) {
      print('Error while saving image: $e');
      return "";
    }
  }

  // Function to pick image from system
  static Future<XFile?> pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        return pickedFile;
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  // Get size of image from given path
  static Future<Size> getImageSize(String path) async {
    final file = File(path);
    // Read the file as bytes
    final bytes = await file.readAsBytes();

    // Use a Completer to await the result from decodeImageFromList
    final Completer<Size> completer = Completer();

    ui.decodeImageFromList(bytes, (ui.Image uiImage) {
      final size = Size(uiImage.width.toDouble(), uiImage.height.toDouble());
      print("Image Dimensions: ${size.width} x ${size.height}");
      completer.complete(size);
    });

    // Return the size once the completer is completed
    return completer.future;
  }
}
