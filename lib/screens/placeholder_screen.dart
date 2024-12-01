import 'package:flutter/material.dart';
import 'package:pdf_note/screens/pdf_viewer_screen.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;

  const PlaceholderScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(title)), body: const PdfViewerScreen());
  }
}
