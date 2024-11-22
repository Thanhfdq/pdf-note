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
  bool isFirstFieldFocused = false;
  bool isSecondFieldFocused = false;
  bool isMarkdownRendered = false; // To track if markdown should be displayed

  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();
  String markdownContent =
      "# This is the title"; // Store content to render as markdown

  @override
  void dispose() {
    // Clean up controllers when the widget is disposed.
    firstController.dispose();
    secondController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
      body: Column(
        children: [
          // If markdown is rendered, display it, otherwise show the TextFields
          isMarkdownRendered
              ? Expanded(
                  child: Markdown(
                    data: markdownContent, // Render the markdown content
                  ),
                )
              : Expanded(
                  child: Focus(
                    onFocusChange: (hasFocus) {
                      setState(() {
                        isFirstFieldFocused = hasFocus;
                        if (hasFocus) {
                          isSecondFieldFocused = false; // Hide second field
                        }
                      });
                    },
                    child: Visibility(
                      visible: !isSecondFieldFocused,
                      child: TextField(
                        controller: firstController,
                        expands:
                            true, // Allows the TextField to expand to fill the space
                        maxLines: null, // No line limit
                        minLines: null, // Adjust automatically
                        decoration: const InputDecoration(
                            hintText: "@Start markdown note here",
                            hintStyle: TextStyle(color: Color(0xFF909090)),
                            contentPadding: EdgeInsets.all(16), // Add padding
                            filled: true,
                            fillColor: Color(0xFFFFFFFF)),
                        onTap: () {
                          setState(() {
                            isFirstFieldFocused = true;
                            isSecondFieldFocused = false; // Hide second field
                          });
                        },
                      ),
                    ),
                  ),
                ),
          Expanded(
            child: Focus(
              onFocusChange: (hasFocus) {
                setState(() {
                  isSecondFieldFocused = hasFocus;
                  if (hasFocus) {
                    isFirstFieldFocused = false; // Hide first field
                  }
                });
              },
              child: Visibility(
                visible: !isFirstFieldFocused,
                child: TextField(
                  controller: secondController,
                  expands:
                      true, // Allows the TextField to expand to fill the space
                  maxLines: null, // No line limit
                  minLines: null, // Adjust automatically
                  decoration: const InputDecoration(
                      hintText: "@New PDF note",
                      hintStyle: TextStyle(color: Color(0xFF909090)),
                      contentPadding: EdgeInsets.all(16), // Add padding
                      filled: true,
                      fillColor: Color(0xFFFFFFFF)),
                  onTap: () {
                    setState(() {
                      isSecondFieldFocused = true;
                      isFirstFieldFocused = false; // Hide first field
                    });
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: isFirstFieldFocused
          ? BottomNavigationBar(
              backgroundColor: const Color.fromARGB(255, 167, 89, 89),
              selectedItemColor: const Color(0xFF856DFF),
              unselectedItemColor: Colors.grey,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.line_horizontal_3),
                  label: 'Menu',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.paperclip),
                  label: 'Attach',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.book),
                  label: 'Book',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.arrow_turn_up_left),
                  label: 'Undo',
                ),
                BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.arrow_turn_up_right),
                    label: 'Redo'),
              ],
              onTap: (index) {
                if (index == 2) {
                  setState(() {
                    markdownContent = firstController
                        .text; // Save content from the first TextField
                    isMarkdownRendered = true; // Render the markdown content
                  });
                }
              },
            )
          : BottomNavigationBar(
              backgroundColor: const Color.fromARGB(255, 167, 89, 89),
              selectedItemColor: const Color(0xFF856DFF),
              unselectedItemColor: Colors.grey,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.line_horizontal_3),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.folder_open),
                  label: 'Open',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.mic),
                  label: 'Record',
                ),
                BottomNavigationBarItem(
                  icon: Icon(CupertinoIcons.add),
                  label: 'Add Tab',
                ),
              ],
            ),
    );
  }
}

class NoteCard extends StatelessWidget {
  final String placeholder;

  const NoteCard({super.key, required this.placeholder});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Text(
        placeholder,
        style: const TextStyle(color: Colors.grey),
      ),
    );
  }
}
