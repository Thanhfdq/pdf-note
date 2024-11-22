import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Note',
      theme: ThemeData(
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFFE6E6E6),
        ),
      ),
      home: const MyHomePage(title: 'New tab'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isMarkdownFieldFocused = false;
  bool _isPdfFieldFocused = false;
  bool _showMarkdown = false; // To track if markdown should be displayed

  final TextEditingController _markdownFieldController =
      TextEditingController();
  final TextEditingController _pdfFieldController = TextEditingController();
  String _markdownFieldContent = ""; // Store content to render as markdown

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed.
    _markdownFieldController.dispose();
    _pdfFieldController.dispose();
    super.dispose();
  }

  void _startMarkdown() {
    setState(() {
      _isMarkdownFieldFocused = true;
      _showMarkdown = false;
    });
  }

  void _showCommandPalette() {}
  void _openFile() {}
  void _startRecord() {}

  void _newTab() {}
  void _toggleMarkdownView() {
    if (_isMarkdownFieldFocused) {
      setState(() {
        _showMarkdown = !_showMarkdown;
      });
      if(!_showMarkdown){
        _markdownFieldController.text = _markdownFieldContent;
      }
    }
  }

  void _attachFile() {}

  void _undoOfMarkdown() {}

  void _redoOfMarkdown() {}

  @override
  void initState() {
    super.initState();
    // Set the initial text
    _markdownFieldController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFE6E6E6),
        title: Text(
          widget.title,
          style: const TextStyle(color: Colors.grey, fontSize: 15),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {},
          icon:
              const Icon(CupertinoIcons.square_stack, color: Color(0xFF856DFF)),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(CupertinoIcons.ellipsis_circle,
                color: Color(0xFF856DFF)),
          ),
        ],
      ),
      body: _isMarkdownFieldFocused
          ? (_showMarkdown
              ? Markdown(
                  data: _markdownFieldContent,
                  styleSheet: MarkdownStyleSheet(
                    p: const TextStyle(fontSize: 18),
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _markdownFieldController,
                    expands: true,
                    maxLines: null,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      hintText: 'Write your markdown text here...',
                      filled: true,
                      fillColor: Colors.white,
                      focusColor: Colors.white,
                      hoverColor: Colors.white,
                      border: InputBorder.none
                    ),
                    onChanged: (value) {
                      setState(() {
                        _markdownFieldContent = value;
                      });
                    },
                  ),
                ))
          : ElevatedButton(
              onPressed: _startMarkdown,
              child: const Text("Start Markdown note")),

      // Bottom Navigation Bar
      bottomNavigationBar: _isMarkdownFieldFocused
          ? Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: const BoxDecoration(
                  color: Color(0xFFE6E6E6),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        color: Colors.grey,
                        offset: Offset(0, -2))
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _showCommandPalette,
                    icon: const Icon(
                      CupertinoIcons.line_horizontal_3,
                      color: Color(0xFF856DFF),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _toggleMarkdownView(),
                    icon: Icon(_showMarkdown?CupertinoIcons.pencil:CupertinoIcons.book,
                        color: Color(0xFF856DFF)),
                  ),
                  IconButton(
                    onPressed: _attachFile,
                    icon: const Icon(CupertinoIcons.paperclip,
                        color: Color(0xFF856DFF)),
                  ),
                  IconButton(
                    onPressed: _undoOfMarkdown,
                    icon: const Icon(CupertinoIcons.arrow_turn_up_left,
                        color: Color(0xFF856DFF)),
                  ),
                  IconButton(
                    onPressed: _redoOfMarkdown,
                    icon: const Icon(CupertinoIcons.arrow_turn_up_right,
                        color: Color(0xFF856DFF)),
                  ),
                ],
              ))
          : Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: const BoxDecoration(
                  color: Color(0xFFE6E6E6),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 5,
                        color: Colors.grey,
                        offset: Offset(0, -2))
                  ]),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: _showCommandPalette,
                    icon: const Icon(CupertinoIcons.line_horizontal_3,
                        color: Color(0xFF856DFF)),
                  ),
                  IconButton(
                    onPressed: _openFile,
                    icon: const Icon(CupertinoIcons.folder,
                        color: Color(0xFF856DFF)),
                  ),
                  IconButton(
                    onPressed: _startRecord,
                    icon: const Icon(CupertinoIcons.mic,
                        color: Color(0xFF856DFF)),
                  ),
                  IconButton(
                    onPressed: _newTab,
                    icon: const Icon(CupertinoIcons.add,
                        color: Color(0xFF856DFF)),
                  )
                ],
              ),
            ),
    );
  }
}
