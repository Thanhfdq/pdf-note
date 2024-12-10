import 'package:flutter/material.dart';
import 'package:pdf_note/constants/app_colors.dart';
import 'package:pdf_note/constants/app_strings.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdf_note/screens/markdown_editor.dart';
import 'package:pdf_note/screens/pdf_editor_screen.dart';
import 'package:pdf_note/screens/pdf_viewer_screen.dart';
import 'package:pdf_note/widgets/file_options.dart';
import 'package:pdf_note/widgets/left_drawer.dart';
import 'package:provider/provider.dart';
import '../widgets/app_bar.dart';
import 'new_tab_screen.dart';
import '../services/file_services.dart';
import 'package:file_picker/file_picker.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkDefaultFolder();
    });
  }

  Future<void> _checkDefaultFolder() async {
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    if (tabsManager.defaultFileLocation == "") {
      String? selectedDirectory = await FilePicker.platform.getDirectoryPath();

      if (selectedDirectory == null) {
        // User canceled the picker
        return;
      }

      setState(() {
        tabsManager.defaultFileLocation = "$selectedDirectory/";
      });
      print("default File location: ${tabsManager.defaultFileLocation}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return HomeScreen();
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
        backgroundColor: AppColors.lightSecondary,
        key: scaffoldKey,
        appBar: CustomAppBar(
          filePath: currentTab.filePath,
          scaffoldKey: scaffoldKey,
        ),
        body: Consumer<TabsManager>(builder: (context, tabManager, child) {
          return Stack(
            children: [
              currentTab.mode == AppStrings.markdownMode // Markdown mode
                  ? const MarkdownEditor()
                  : currentTab.mode == AppStrings.pdfMode // PDF mode
                      ? tabsManager
                              .tabs[tabsManager.currentTab].pdfState!.isViewMode
                          ? const PdfViewerScreen()
                          : const PdfEditorScreen()
                      : NewTabScreen(fileService: fileService),
              if (tabsManager.isTabWindowOpen) const LeftDrawer(), // New Tab
              if (tabManager.isOptionsOpen) const FileOptions()
            ],
          );
        }),
        drawer: const LeftDrawer());
  }
}
