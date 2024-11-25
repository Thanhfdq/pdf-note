import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdf_note/services/file_services.dart';
import 'package:pdf_note/services/markdown_mode_handler.dart';
import 'package:provider/provider.dart';

import '../components/custom_button.dart';

class BottomToolbar extends StatelessWidget {
  const BottomToolbar({super.key});

  @override
  Widget build(BuildContext context) {
    final tabManager = Provider.of<TabsManager>(context);

    List<Widget> toolbarButtons = [];

    if (tabManager.tabs[tabManager.currentTab].mode == "new") {
      toolbarButtons = [
        CustomButton(icon: CupertinoIcons.line_horizontal_3, onPressed: () {}),
        CustomButton(
            icon: CupertinoIcons.folder_open,
            onPressed: () => FileService().openFile(context)),
        CustomButton(icon: CupertinoIcons.mic, onPressed: () {}),
        CustomButton(icon: CupertinoIcons.add_circled, onPressed: () {}),
      ];
    } else if (tabManager.tabs[tabManager.currentTab].mode == "markdown") {
      toolbarButtons = [
        CustomButton(icon: CupertinoIcons.line_horizontal_3, onPressed: () {}),
        CustomButton(
            icon: tabManager.tabs[tabManager.currentTab].markdownState
                        ?.previewMode ==
                    true
                ? CupertinoIcons.pen
                : CupertinoIcons.book,
            onPressed: () => MarkdownModeHandler.handleBook(context)),
        CustomButton(icon: CupertinoIcons.paperclip, onPressed: () {}),
        CustomButton(icon: CupertinoIcons.arrow_turn_up_left, onPressed: () {}),
        CustomButton(
            icon: CupertinoIcons.arrow_turn_up_right, onPressed: () {}),
      ];
    } else if (tabManager.tabs[tabManager.currentTab].mode == "pdf") {
      toolbarButtons = [
        CustomButton(icon: CupertinoIcons.line_horizontal_3, onPressed: () {}),
        CustomButton(icon: CupertinoIcons.clear_fill, onPressed: () {}),
        CustomButton(icon: CupertinoIcons.pen, onPressed: () {}),
        CustomButton(icon: CupertinoIcons.textbox, onPressed: () {}),
        CustomButton(icon: CupertinoIcons.arrow_turn_up_left, onPressed: () {}),
        CustomButton(
            icon: CupertinoIcons.arrow_turn_up_right, onPressed: () {}),
      ];
    }

    return BottomAppBar(
      color: const Color(0xFFE6E6E6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: toolbarButtons,
      ),
    );
  }
}
