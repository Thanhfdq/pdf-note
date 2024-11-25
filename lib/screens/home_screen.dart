import 'package:flutter/material.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdf_note/screens/markdown_editor.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bar.dart';
import 'new_tab_screen.dart';
import 'pdf_editor_screen.dart';
import '../services/file_services.dart';
import '../widgets/bottom_toolbar.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final FileService fileService = FileService();

  @override
  Widget build(BuildContext context) {
    final tabManager = context.watch<TabsManager>();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
          fileName: tabManager.tabs[tabManager.currentTab].fileName,
          onTabButtonPressed: () {
            //Logic to handle tab button press
          },
          onOptionsPressed: () {
            //Logic to handle option button press
          }),
      body: Consumer<TabsManager>(builder: (context, tabManager, child) {
        return tabManager.tabs[tabManager.currentTab].mode == "markdown"
            ? const MarkdownEditor()
            : tabManager.tabs[tabManager.currentTab].mode == "pdf"
                ? const PDFEditorScreen()
                : NewTabScreen(fileService: fileService);
      }),
      // drawer: LeftDrawer(),
      // endDrawer: RightDrawer(),
      bottomNavigationBar: const BottomToolbar(),
    );
  }
}
