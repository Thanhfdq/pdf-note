import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pdf_note/services/file_services.dart';

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
  late TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Initialize controller with the markdownText
    setState(() {
      _controller = TextEditingController(text: widget.markdownText);
    });
  }

  @override
  void dispose() {
    // Dispose of the controller to free resources
    _controller.dispose();
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
    return TextField(
        controller: _controller,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
            hintText: "Write your Markdown here...",
            contentPadding:EdgeInsets.only(left: 30, top: 30),
            filled: true,
            fillColor: Colors.white,
            hoverColor: Colors.white,
            border: InputBorder.none),
        onChanged: _onContentChanged); // Trigger when text chang
  }
}
