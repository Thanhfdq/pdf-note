import 'package:flutter/foundation.dart';
import 'package:pdf_note/providers/markdown_state.dart';
import 'package:pdf_note/providers/pdf_state.dart';

class TabState extends ChangeNotifier {
  String mode = "new";
  String filePath = "";
  MarkdownState? markdownState;
  PdfState? pdfState;

  TabState({required this.mode, required this.filePath});

  TabState.withMarkdown(
      {required this.mode,
      required this.filePath,
      required this.markdownState});

  TabState.withPdf(
      {required this.mode, required this.filePath, required this.pdfState});

  void setMode(String mode) {
    this.mode = mode;
    notifyListeners();
  }

  void setFilePath(String filePath) {
    this.filePath = filePath;
    notifyListeners();
  }

  void setMarkdownState(MarkdownState markdownState) {
    this.markdownState = markdownState;
  }

  void setPdfState(PdfState pdfState) {
    this.pdfState = pdfState;
  }
}
