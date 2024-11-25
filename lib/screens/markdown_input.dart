import 'package:flutter/material.dart';

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: _controller,
        maxLines: null,
        expands: true,
        decoration: const InputDecoration(
            hintText: "Write your Markdown here...",
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none),
        onChanged: (text) {
          print("Current Markdown: $text"); // Example for debugging
        },
      ), // Trigger when text changes
    );
  }
}
