import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pdf_note/constants/app_strings.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdf_note/screens/markdown_editor.dart';
import 'package:pdf_note/screens/pdf_viewer_screen.dart';
import 'package:pdf_note/widgets/file_options.dart';
import 'package:pdf_note/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bar.dart';
import 'new_tab_screen.dart';
import '../services/file_services.dart';
import '../widgets/bottom_toolbar.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      menuScreen: const LeftDrawer(),
      mainScreen: HomeScreen(),
      mainScreenScale: 0.0,
      menuScreenWidth: 270,
      angle: 0.0,
      borderRadius: 0,
      // dragOffset: double.infinity,
      mainScreenTapClose: true,
      menuBackgroundColor: Colors.grey,
    );
  }
}

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final FileService fileService = FileService();

  @override
  Widget build(BuildContext context) {
    final tabsManager = context.watch<TabsManager>();
    final currentTab = tabsManager.tabs[tabsManager.currentTab];
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
        backgroundColor: Colors.white,
        key: scaffoldKey,
        appBar: CustomAppBar(
          filePath: currentTab.filePath,
          scaffoldKey: scaffoldKey,
        ),
        body: Consumer<TabsManager>(builder: (context, tabManager, child) {
          return Stack(
            children: [
              currentTab.mode == AppStrings.markdownMode
                  ? const MarkdownEditor()
                  : currentTab.mode == AppStrings.pdfMode
                      ? const PdfViewerScreen()
                      : NewTabScreen(fileService: fileService),
              if (tabManager.isOptionsOpen) const FileOptions()
            ],
          );
        }),
        drawer: const LeftDrawer(),
        // endDrawer: RightDrawer(),
        bottomNavigationBar: currentTab.mode == AppStrings.pdfMode
            ? currentTab.pdfState!.isViewMode
                ? null
                : const BottomToolbar()
            : const BottomToolbar());
  }
}
