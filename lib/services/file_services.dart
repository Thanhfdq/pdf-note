import 'package:flutter/material.dart';
import 'package:pdf_note/constants/app_strings.dart';
import 'package:pdf_note/providers/markdown_state.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdf_note/utils/file_helper.dart';
import 'package:provider/provider.dart';
import '../screens/placeholder_screen.dart';
import '../utils/notification_helper.dart';

class FileService {
  void createNewMarkdownFile(BuildContext context) {
    try {
      String filePath = AppStrings.defaultFileLocation + generateFileName();
      FileHelper.writeFile(AppStrings.defaultFileLocation + filePath, "");
      print("Create new file with path: ${filePath}");
      final tabManager = Provider.of<TabsManager>(context, listen: false);
      tabManager.updateTab(tabManager.currentTab,
          mode: "markdown",
          filePath: filePath,
          markdownState: MarkdownState(),
          markdownContent: "");
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
    return "note_${now.toIso8601String().replaceAll(':', '_')}.md";
  }



  void createNewPdfFile(BuildContext context) {
    // Your logic for creating a new PDF file
    // Example: Navigate to PDF editor or initialize resources
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const PlaceholderScreen("PDF Editor")),
    );
  }

  void openMarkdownFile(BuildContext context) async {
    String filePath = await FileHelper.pickFile();
    String content = await FileHelper.readFile(filePath);
    // ignore: use_build_context_synchronously
    final tabManager = Provider.of<TabsManager>(context, listen: false);
    // Set markdown mode for tabcx
    tabManager.updateTab(tabManager.currentTab,
        mode: "markdown",
        filePath: filePath,
        markdownState: MarkdownState(),
        markdownContent: content);
  }

  void saveFile(BuildContext context, String content) {
    // Get current tab infomation
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    // get current editting file path
    String filePath = tabsManager.tabs[tabsManager.currentTab].filePath;
    // Save file and save history
    FileHelper.writeFile(filePath, content);
    print("Before save history");
    tabsManager.tabs[tabsManager.currentTab].markdownState
        ?.saveVersion(content);
    tabsManager.tabs[tabsManager.currentTab].markdownState?.printState();
    print("After save history");
  }
}
