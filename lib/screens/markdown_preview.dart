import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownPreview extends StatelessWidget {
  final String markdownText;

  const MarkdownPreview({
    super.key,
    required this.markdownText,
  });

  @override
  Widget build(BuildContext context) {
    return Markdown(
      data: markdownText,
      styleSheet: MarkdownStyleSheet(p: const TextStyle(fontSize: 18),),
    );
  }
}
