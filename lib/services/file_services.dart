import 'package:flutter/material.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdf_note/utils/file_helper.dart';
import 'package:provider/provider.dart';
import '../screens/placeholder_screen.dart';
import '../utils/notification_helper.dart';

class FileService {
  void createNewMarkdownFile(BuildContext context) {
    try {
      // Generate a unique file name (e.g., "note_YYYYMMDD_HHMMSS.md")
      final now = DateTime.now();
      final fileName = "note_${now.toIso8601String().replaceAll(':', '_')}.md";
      FileHelper.writeFile(fileName, "");
      final tabManager = Provider.of<TabsManager>(context, listen: false);
      tabManager.updateTab(tabManager.currentTab,
          mode: "markdown", fileName: fileName, markdownContent: "");
      // Notify the user or navigate to the editor screen
      NotificationHelper.showNotification(
          context, "Created new markdown file.");
    } catch (e) {
      // Handle errors
      NotificationHelper.showNotification(context, "Error creating file: $e");
    }
  }

  void createNewPdfFile(BuildContext context) {
    // Your logic for creating a new PDF file
    // Example: Navigate to PDF editor or initialize resources
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlaceholderScreen("PDF Editor")),
    );
  }

  void openFile(BuildContext context) async {
    String content = await FileHelper.readFile("Untitle.md");
    // ignore: use_build_context_synchronously
    final tabManager = Provider.of<TabsManager>(context, listen: false);
    tabManager.updateTab(tabManager.currentTab,
        mode: "markdown", fileName: "Untitle.md", markdownContent: content);
  }
}
