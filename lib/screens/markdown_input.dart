import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdf_note/services/file_services.dart';
import 'package:pdf_note/utils/file_helper.dart';
import 'package:provider/provider.dart';

class MarkdownInput extends StatefulWidget {
  final String markdownText;

  const MarkdownInput({
    super.key,
    required this.markdownText,
  });
  @override
  // ignore: library_private_types_in_public_api
  _MarkdownInputState createState() => _MarkdownInputState();
}

class _MarkdownInputState extends State<MarkdownInput> {
  Timer? _debounceTimer;
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  
  @override
  void initState() {
    super.initState();
    // Initialize controller with the markdownText
    setState(() {
      _controller.text = widget.markdownText;
    });

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        print("lost focus");
        final tabsManager = Provider.of<TabsManager>(context, listen: false);
        FileService().renameFile(
          context,
          tabsManager.currentTab,
          tabsManager.tabs[tabsManager.currentTab].filePath,
          _titleController.text,
        );
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the controller to free resources
    _controller.dispose();
    _focusNode.dispose();
    _debounceTimer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _onContentChanged(String value) {
    // Restart the debounce timer
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(seconds: 1), () {
      FileService().saveFile(context, _controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    final tabsManager = Provider.of<TabsManager>(context);
    // Set the text in the TextEditingController
    _titleController.text = FileHelper.getFileName(
        tabsManager.tabs[tabsManager.currentTab].filePath);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _titleController,
            focusNode: _focusNode,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              hintText: 'Nhập tiêu đề...',
              border: InputBorder.none,
            ),
          ),
          const SizedBox(height: 16), // Khoảng cách giữa tiêu đề và nội dung
          TextField(
            controller: _controller,
            maxLines: null, // Cho phép tự động mở rộng chiều cao theo nội dung
            decoration: const InputDecoration(
              hintText: "Write your Markdown here...",
              filled: true,
              fillColor: Colors.white,
              hoverColor: Colors.white,
              border: InputBorder.none,
            ),
            onChanged: _onContentChanged,
          ),
        ],
      ),
    );
  }
}
