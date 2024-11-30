import 'package:flutter/cupertino.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdf_note/utils/notification_helper.dart';
import 'package:provider/provider.dart';

class MarkdownModeHandler {
  static void handlePreview(BuildContext context) {
    final tabManager = Provider.of<TabsManager>(context, listen: false);
    tabManager.toggleViewMarkdownMode(tabManager.currentTab);
    print("Handle preview function: ${tabManager.currentTab}");
  }

  static void handleUndo(BuildContext context) {
    print("Let's undo");
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    // Undo content
    bool isSuccess = tabsManager.undoOfMarkdown();
    tabsManager.tabs[TabsManager().currentTab].markdownState?.printState();
    // Update content undo current editing
    tabsManager.updateTab(tabsManager.currentTab,
        newMarkdownContent:
            tabsManager.tabs[tabsManager.currentTab].markdownState?.content);
    isSuccess
        ? ""
        : NotificationHelper.showNotification(
            context, "This is the oldest version!");
  }

  static void handleRedo(BuildContext context) {
    print("Let's redo");
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    // Redo content
    bool isSuccess = tabsManager.redoOfMarkdown();
    tabsManager.tabs[tabsManager.currentTab].markdownState?.printState();
    // Update content undo current editing
    tabsManager.updateTab(tabsManager.currentTab,
        newMarkdownContent:
            tabsManager.tabs[tabsManager.currentTab].markdownState?.content);
    isSuccess
        ? ""
        : NotificationHelper.showNotification(
            context, "This is the newest version!");
  }
}
