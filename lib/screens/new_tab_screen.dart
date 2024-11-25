import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdf_note/services/file_services.dart';

class NewTabScreen extends StatelessWidget {
  final FileService fileService;

  const NewTabScreen({super.key, required this.fileService});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App Title or Introduction
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              "Create a New File",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 20),
          // Button to create a Markdown file
          ElevatedButton.icon(
            onPressed: () {
              fileService.createNewMarkdownFile(context);
            },
            icon: const Icon(CupertinoIcons.doc_text),
            label: const Text("New Markdown File"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          const SizedBox(height: 10),
          // Button to create a PDF file
          ElevatedButton.icon(
            onPressed: () => fileService.createNewPdfFile(context),
            icon: const Icon(Icons.picture_as_pdf),
            label: const Text("New PDF File"),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
          const SizedBox(height: 30),
          // Optional: Add an illustration or image
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Icon(
              CupertinoIcons.add_circled,
              size: 100,
              color: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
