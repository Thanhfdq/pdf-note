import 'package:flutter/cupertino.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:provider/provider.dart';

class MarkdownModeHandler {
  TabsManager tabsManager = TabsManager();
  static void handleBook(BuildContext context) {
    Provider.of<TabsManager>(context, listen: false).toggleViewMarkdownMode(TabsManager().currentTab);
  }
}
