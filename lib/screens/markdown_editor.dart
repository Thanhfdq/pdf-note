import 'package:flutter/material.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:provider/provider.dart';
import 'markdown_input.dart';
import 'markdown_preview.dart';

// ignore: must_be_immutable
class MarkdownEditor extends StatefulWidget {
  const MarkdownEditor({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MarkdownEditorState createState() => _MarkdownEditorState();
}

class _MarkdownEditorState extends State<MarkdownEditor> {
  TabsManager tabsManager = TabsManager();

  @override
  Widget build(BuildContext context) {
    TabsManager tabManager = Provider.of<TabsManager>(context);
    final currentMarkdownState =
        tabManager.tabs[tabManager.currentTab].markdownState;
    String content =
        tabManager.tabs[tabManager.currentTab].markdownState!.content;
    return Stack(
      children: [
        MarkdownInput(
            markdownText: content),
        currentMarkdownState?.previewMode == true
            ? Container(
                color: Colors.white,
                child: MarkdownPreview(markdownText: content))
            : Container()
      ],
    );
  }
}
