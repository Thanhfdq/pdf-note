import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf_note/constants/app_colors.dart';
import 'package:pdf_note/constants/app_strings.dart';
import 'package:pdf_note/models/canvas_element.dart';
import 'package:pdf_note/providers/markdown_state.dart';
import 'package:pdf_note/providers/pdf_state.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdf_note/utils/file_helper.dart';
import 'package:provider/provider.dart';
import '../utils/notification_helper.dart';
import 'package:pdf/widgets.dart' as pw;

class FileService {
  void createNewMarkdownFile(BuildContext context) {
    final tabManager = Provider.of<TabsManager>(context, listen: false);
    String defaultFileLocation = tabManager.defaultFileLocation;
    try {
      String filePath = "$defaultFileLocation${generateFileName()}.md";
      FileHelper.writeFile(filePath, "");
      final tabManager = Provider.of<TabsManager>(context, listen: false);
      tabManager.updateTab(tabManager.currentTab,
          newMode: AppStrings.markdownMode,
          newFilePath: filePath,
          newMarkDownState: MarkdownState(),
          newMarkdownContent: "");
      // Notify the user or navigate to the editor screen
      NotificationHelper.showNotification(
          context, "Created new markdown file.");
    } catch (e) {
      // Handle errors
      NotificationHelper.showNotification(context, "Error creating file: $e");
    }
  }

  String generateFileName() {
// Generate a unique file name (e.g., "note_YYYYMMDD_HHMMSS.md")
    final now = DateTime.now();
    final formatter = DateFormat('ddMMyyyy_HHmmss');
    return 'note_${formatter.format(now)}';
  }

  void createNewPdfFile(BuildContext context) {
    // Your logic for creating a new PDF file
    // Example: Navigate to PDF editor or initialize resources
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => const PlaceholderScreen("PDF Editor")),);
    final tabManager = Provider.of<TabsManager>(context, listen: false);
    tabManager.updateTab(tabManager.currentTab,
        newMode: AppStrings.pdfMode,
        newFilePath:
            "${tabManager.defaultFileLocation}${generateFileName()}.pdf",
        newPdfState: PdfState());
    // Notify the user or navigate to the editor screen
    NotificationHelper.showNotification(context, "Created new pdf file.");
  }

  void openMarkdownFile(BuildContext context) async {
    String filePath = await FileHelper.pickFile(['md', 'pdf']);
    if (filePath.isEmpty) return; // cancel if user not choose any file
    String content = await FileHelper.readFile(filePath);
    // ignore: use_build_context_synchronously
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    if (filePath.substring(filePath.lastIndexOf('.') + 1, filePath.length) ==
        'md') {
      // Set markdown mode for tab
      tabsManager.updateTab(tabsManager.currentTab,
          newMode: AppStrings.markdownMode,
          newFilePath: filePath,
          newMarkDownState: MarkdownState(),
          newMarkdownContent: content);
    } else {
      tabsManager.updateTab(tabsManager.currentTab,
          newMode: AppStrings.pdfMode,
          newFilePath: filePath,
          newPdfState: PdfState());
    }
  }

  void saveFile(BuildContext context, String content) {
    // Get current tab infomation
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    // get current editting file path
    String filePath = tabsManager.tabs[tabsManager.currentTab].filePath;
    // Save file and save history
    FileHelper.writeFile(filePath, content);
    tabsManager.tabs[tabsManager.currentTab].markdownState
        ?.saveVersion(content);
    tabsManager.tabs[tabsManager.currentTab].markdownState?.printState();
  }

  void savePdfNote(BuildContext context, List<CanvasElement> canvasElements,
      ui.Size canvasSize) async {
    print("Saving in fileServices...");
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    // Build the stack
    final pdfStack = await buildPdfStack(canvasElements, canvasSize);
    // Add to the PDF document
    final pdf = pw.Document();
    // Calculate the PDF page format based on the A4 ratio
    final double pdfWidth = canvasSize.width;
    // final double pdfHeight = pdfWidth * AppNumbers.a4AspectRatio;
    final double pdfHeight = canvasSize.height;
    final pageFormat = PdfPageFormat(pdfWidth, pdfHeight);
    pdf.addPage(pw.Page(pageFormat: pageFormat, build: (context) => pdfStack));
    // Save or share the PDF
    String path = tabsManager.tabs[tabsManager.currentTab].filePath;
    Uint8List byteData = await pdf.save();
    FileHelper.writeByte(path, byteData);
  }

  // Prepare pdf content from editor
  Future<pw.Stack> buildPdfStack(
      List<CanvasElement> canvasElements, Size canvasSize) async {
    // Preload image bytes for all ImageElement
    final preloadedImages = await Future.wait(
      canvasElements.whereType<InsertImage>().map(
            (element) async => MapEntry(
              element,
              await FileHelper.convertImageToUint8List(element.imagePath),
            ),
          ),
    );

    final imageBytesMap = {
      for (var entry in preloadedImages) entry.key: entry.value
    };

    return pw.Stack(
      children: canvasElements.map((element) {
        if (element is InkStroke) {
          return _renderPdfPath(element, canvasSize);
        } else if (element is TextBox) {
          return _renderPdfText(element);
        } else if (element is InsertImage) {
          return _renderPdfImage(element, imageBytesMap[element]!);
        } else if (element is EraserStroke) {
          return _renderPdfEraser(element, canvasSize);
        }
        return pw.Container();
      }).toList(),
    );
  }

  pw.Widget _renderPdfPath(InkStroke element, ui.Size canvasSize) {
    return pw.CustomPaint(
      size: PdfPoint(canvasSize.width, canvasSize.height),
      painter: (PdfGraphics canvas, PdfPoint size) {
        // Set color and stroke width directly on the canvas
        canvas.setColor(PdfColor.fromInt(element.inkColor.value));
        canvas.setLineWidth(element.strokeWidth);

        // Draw path
        final height = size.y;
        if (element.inkDots.isNotEmpty) {
          canvas.moveTo(
            element.inkDots.first.dx,
            height - element.inkDots.first.dy, // Adjust Y-coordinate
          );
          for (var point in element.inkDots.skip(1)) {
            canvas.lineTo(
              point.dx,
              height - point.dy,
            ); // Adjust Y-coordinate
          }
          canvas.strokePath(); // This uses the set properties
        }
      },
    );
  }

  pw.Widget _renderPdfEraser(EraserStroke eraseStroke, ui.Size canvasSize) {
    return pw.CustomPaint(
      size: PdfPoint(canvasSize.width, canvasSize.height),
      painter: (PdfGraphics canvas, PdfPoint size) {
        // Vẽ vùng bị xóa bằng màu trắng
        canvas.setColor(
            PdfColor.fromInt(AppColors.defaultBackground.value)); // White color
        canvas.setLineWidth(eraseStroke.strokeWidth);
        // Draw path
        final height = size.y;
        if (eraseStroke.eraserDots.isNotEmpty) {
          canvas.moveTo(
            eraseStroke.eraserDots.first.dx,
            height - eraseStroke.eraserDots.first.dy, // Adjust Y-coordinate
          );
          for (var point in eraseStroke.eraserDots.skip(1)) {
            canvas.lineTo(
              point.dx,
              height - point.dy,
            ); // Adjust Y-coordinate
          }
          canvas.strokePath(); // This uses the set properties
        }
      },
    );
  }

  pw.Widget _renderPdfText(TextBox element) {
    return pw.Positioned(
      top: element.position.dy,
      left: element.position.dx,
      child: pw.Text(
        element.content,
        style: pw.TextStyle(
          fontSize: element.fontSize,
          color: PdfColor.fromInt(element.textColor.value),
        ),
      ),
    );
  }

  pw.Widget _renderPdfImage(InsertImage element, Uint8List imageBytes) {
    final pdfImage = pw.MemoryImage(imageBytes);
    return pw.Positioned(
      top: element.position.dy,
      left: element.position.dx,
      child: pw.Transform.rotate(
        angle: 0.0,
        child: pw.Image(
          pdfImage,
          width: element.size.width,
          height: element.size.height,
        ),
      ),
    );
  }

  void renameFile(
      BuildContext context, int tabIndex, String filePath, String newName) {
    final tabsManager = Provider.of<TabsManager>(context, listen: false);

    int lastSlashIndex = filePath.lastIndexOf('/');
    String directory =
        filePath.substring(0, lastSlashIndex + 1); // Extract the directory

    // Get file type
    String fileType =
        filePath.substring(filePath.lastIndexOf('.'), filePath.length);
    // Combine directory and new file name
    String newPath = '$directory$newName$fileType';
    print("New file Path: $newPath");
    FileHelper.renameFile(filePath, newPath);
    // Update to app state
    tabsManager.updateTab(tabIndex, newFilePath: newPath);
  }

  void closeTab(BuildContext context, int index) {
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    tabsManager.removeTab(index);
    if (index == 0 && tabsManager.tabs.isEmpty) {
      tabsManager.addTab("new", "");
      tabsManager.updateTab(0);
    }
    if (index > tabsManager.currentTab ||
        (index == tabsManager.currentTab && index == 0)) {
      return; // Dont need to update current tab index in these case
    }
    tabsManager.updateTab(--tabsManager.currentTab); // Update current tab
  }

  void closeAllTab(BuildContext context) {
    print("closing all tab...");
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    tabsManager.removeAllTab();
    print("...done.");
    tabsManager.addTab("new", "");
    tabsManager.setCurrentTab(0);
  }

  // Function to  handle insert image feature
  Future<void> addImageToPdf(BuildContext context, int tabIndex, int pageIndex,
      Offset position) async {
    try {
      // Step 1: Pick the image
      final imagePicked = await FileHelper.pickImage();
      if (imagePicked == null) {
        print("No image selected.");
        return;
      }

      // Step 2: Save image to cache
      String cachedImagePath = await FileHelper.saveImageToCache(imagePicked);
      if (cachedImagePath.isEmpty) {
        print("Failed to save image to cache.");
        return;
      }

      // Step 3: Get image size
      final imageSize = await FileHelper.getImageSize(imagePicked.path);
      print("Image size: ${imageSize.width} x ${imageSize.height}");

      // Step 4: Get ui.Image
      Uint8List? byteData =
          await FileHelper.convertImageToUint8List(cachedImagePath);
      final ui.Image image = await decodeImageFromList(byteData!);

      // Step 5: Add image to PDF
      final tabsManager = Provider.of<TabsManager>(context, listen: false);
      tabsManager.tabs[tabIndex].pdfState?.canvasStates[pageIndex]
          .addImage(position, cachedImagePath, imageSize, image, 0.0);
    } catch (e) {
      print("Error in addImageToPdf: $e");
    }
  }
}
