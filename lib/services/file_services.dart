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
      String filePath =
          "${AppStrings.defaultFileLocation}${generateFileName()}.md";
      FileHelper.writeFile(AppStrings.defaultFileLocation + filePath, "");
      final tabManager = Provider.of<TabsManager>(context, listen: false);
      tabManager.updateTab(tabManager.currentTab,
          newMode: "markdown",
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
    return "note_${now.toIso8601String().replaceAll(':', '_')}";
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
        newMode: "markdown",
        newFilePath: filePath,
        newMarkDownState: MarkdownState(),
        newMarkdownContent: content);
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
}
