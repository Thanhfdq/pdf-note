import 'package:flutter/material.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (_) => TabsManager())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "PDF Note",
      home: HomeScreen(),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter_markdown/flutter_markdown.dart';
// import 'utils/file_helper.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'PDF Note',
//       theme: ThemeData(
//         bottomNavigationBarTheme: const BottomNavigationBarThemeData(
//           backgroundColor: Color(0xFFE6E6E6),
//         ),
//       ),
//       home: const MyHomePage(title: 'New tab'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});

//   final String title;

//   @override
//   State<MyHomePage> createState() => _MyHomePageState();
// }

// class TabState {
//   bool isMarkdownFieldFocused;
//   bool showMarkdown;

//   TabState(
//       {this.isMarkdownFieldFocused = false, this.showMarkdown = false});
// }

// class _MyHomePageState extends State<MyHomePage> {
//   final List<String> tabTitles = ["New tab 1", "New tab 2"];
//   final List<String> _markdownFieldContents = [
//     ""
//   ]; // Initial content for the first tab.
//   final List<TextEditingController> _markdownFieldControllers = [
//     TextEditingController()
//   ];
//   List<TabState> tabStates = [
//     TabState(),
//   ];

//   static const String defaultFileName = "Untitle.md";
//   String fileName = defaultFileName;
//   String status = "Type something to auto-save...";

//   // final TextEditingController _pdfFieldController = TextEditingController();

//   int get currentTabIndex => DefaultTabController.of(context)!.index;

//   void addNewTab() {
//     setState(() {
//       tabTitles.add("Tab ${tabTitles.length + 1}");
//       _markdownFieldContents.add(""); // Add empty content for the new tab.
//       tabStates.add(TabState()); // Add a new state for the tab.
//     });
//   }

//   void removeTab(int index) {
//     if (tabTitles.length > 1) {
//       setState(() {
//         tabTitles.removeAt(index);
//         _markdownFieldContents.removeAt(index);
//         tabStates.removeAt(index); // Remove the state for the tab.
//       });
//     }
//   }

//   @override
//   void dispose() {
//     /// Dispose all TextEditingControllers
//     for (var controller in _markdownFieldControllers) {
//       controller.dispose();
//     }
//     super.dispose();
//   }

//   void _startMarkdown(int index) {
//     setState(() {
//       tabStates[index].isMarkdownFieldFocused = true;
//       tabStates[index].showMarkdown = false;
//     });
//   }

//   void _showCommandPalette() {}

//   void _openFile() {}
//   void _startRecord() {}

//   void _newTab() {}
//   void _toggleMarkdownView(int index) {
//     if (tabStates[index].isMarkdownFieldFocused) {
//       setState(() {
//         tabStates[index].showMarkdown = !tabStates[index].showMarkdown;
//       });
//       if (!tabStates[index].showMarkdown) {
//         _markdownFieldControllers[index].text = _markdownFieldContents[index];
//       }
//     }
//   }

//   void _attachFile() {}

//   void _undoOfMarkdown() {}

//   void _redoOfMarkdown() {}

//   /// Save content to the file when the text changes
//   Future<void> _onTextChanged(int index) async {
//     try {
//       await FileHelper.writeFile(fileName, _markdownFieldContents[index]);
//       setState(() {
//         status = "Auto-saved at ${DateTime.now()}";
//       });
//     } catch (e) {
//       setState(() {
//         status = "Error saving file: $e";
//       });
//     }
//   }

// ValueNotifier<int> currentTabIndexNotifier = ValueNotifier<int>(0);


//   @override
//   void initState() {
//     super.initState();
//     // Set the initial text
//     for (int index = 0; index < _markdownFieldControllers.length; index++) {
//       _markdownFieldControllers[index].text = ""; // Set the initial text.
//       _markdownFieldControllers[index].addListener(() {
//         _onTextChanged(index); // Pass the index to the listener function.
//         currentTabIndexNotifier.value = index;

//       });
//     }
//   }
  

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//         length: tabTitles.length,
//         child: Scaffold(
//           backgroundColor: Colors.white,
//           appBar: AppBar(
//             elevation: 0,
//             backgroundColor: const Color(0xFFE6E6E6),
//             title: Text(
//               widget.title,
//               style: const TextStyle(color: Colors.grey, fontSize: 15),
//             ),
//             centerTitle: true,
//             leading: Builder(builder: (context) {
//               return IconButton(
//                 onPressed: () {
//                   Scaffold.of(context).openDrawer();
//                 },
//                 icon: const Icon(CupertinoIcons.square_stack,
//                     color: Color(0xFF856DFF)),
//               );
//             }),
//             actions: [
//               IconButton(
//                 onPressed: () {},
//                 icon: const Icon(CupertinoIcons.ellipsis_circle,
//                     color: Color(0xFF856DFF)),
//               ),
//             ],
//             bottom: TabBar(
//               isScrollable: true,
//               tabs: tabTitles
//                   .map((title) => Tab(
//                         text: title,
//                         icon: IconButton(
//                           icon: const Icon(Icons.close),
//                           onPressed: () {
//                             removeTab(tabTitles.indexOf(title));
//                           },
//                         ),
//                       ))
//                   .toList(),
//             ),
//           ),
//           drawer: Drawer(
//             child: ListView(
//               children: [
//                 const DrawerHeader(
//                   decoration: BoxDecoration(
//                     color: Colors.blue,
//                   ),
//                   child: Text('Sidebar Header'),
//                 ),
//                 ListTile(
//                   title: const Text('File name 1'),
//                   onTap: () {
//                     // Navigate to the corresponding screen or perform an action
//                   },
//                 ),
//                 ListTile(
//                   title: const Text('File name 2'),
//                   onTap: () {
//                     // Navigate to the corresponding screen or perform an action
//                   },
//                 ),
//                 ListTile(
//                   title: const Text('Blank tab'),
//                   onTap: () {
//                     // Navigate to the corresponding screen or perform an action
//                   },
//                 ),
//                 ListTile(
//                   title: const Text('Untitled'),
//                   onTap: () {
//                     // Navigate to the corresponding screen or perform an action
//                   },
//                 ),
//               ],
//             ),
//           ),
//           body: TabBarView(
//             children: List.generate(
//               tabTitles.length,
//               (index) => tabStates[index].isMarkdownFieldFocused
//                   ? (tabStates[index].showMarkdown
//                       ? Markdown(
//                           data: _markdownFieldContents[index],
//                           styleSheet: MarkdownStyleSheet(
//                             p: const TextStyle(fontSize: 18),
//                           ),
//                         )
//                       : Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: TextField(
//                             expands: true,
//                             maxLines: null,
//                             textAlignVertical: TextAlignVertical.top,
//                             decoration: const InputDecoration(
//                                 hintText: 'Write your markdown text here...',
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 border: InputBorder.none),
//                             onChanged: (value) {
//                               setState(() {
//                                 _markdownFieldContents[index] = value;
//                               });
//                             },
//                           ),
//                         ))
//                   : ElevatedButton(
//                       onPressed: () => _startMarkdown(index),
//                       child: const Text("Start Markdown note"),
//                     ),
//             ),
//           ),
//           floatingActionButton: FloatingActionButton(
//             onPressed: addNewTab,
//             child: const Icon(Icons.add),
//           ),
          
//           // Bottom Navigation Bar
//           bottomNavigationBar: tabStates[index].isMarkdownFieldFocused
//               ? Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   decoration: const BoxDecoration(
//                       color: Color(0xFFE6E6E6),
//                       boxShadow: [
//                         BoxShadow(
//                             blurRadius: 5,
//                             color: Colors.grey,
//                             offset: Offset(0, -2))
//                       ]),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         onPressed: _showCommandPalette,
//                         icon: const Icon(
//                           CupertinoIcons.line_horizontal_3,
//                           color: Colors.grey,
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () => _toggleMarkdownView(),
//                         icon: Icon(
//                             _showMarkdown
//                                 ? CupertinoIcons.pencil
//                                 : CupertinoIcons.book,
//                             color: const Color(0xFF856DFF)),
//                       ),
//                       IconButton(
//                         onPressed: _attachFile,
//                         icon: const Icon(CupertinoIcons.paperclip,
//                             color: Colors.grey),
//                       ),
//                       IconButton(
//                         onPressed: _undoOfMarkdown,
//                         icon: const Icon(CupertinoIcons.arrow_turn_up_left,
//                             color: Colors.grey),
//                       ),
//                       IconButton(
//                         onPressed: _redoOfMarkdown,
//                         icon: const Icon(CupertinoIcons.arrow_turn_up_right,
//                             color: Colors.grey),
//                       ),
//                     ],
//                   ))
//               : Container(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   decoration: const BoxDecoration(
//                       color: Color(0xFFE6E6E6),
//                       boxShadow: [
//                         BoxShadow(
//                             blurRadius: 5,
//                             color: Colors.grey,
//                             offset: Offset(0, -2))
//                       ]),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       IconButton(
//                         onPressed: _showCommandPalette,
//                         icon: const Icon(CupertinoIcons.line_horizontal_3,
//                             color: Colors.grey),
//                       ),
//                       IconButton(
//                         onPressed: _openFile,
//                         icon: const Icon(CupertinoIcons.folder,
//                             color: Color(0xFF856DFF)),
//                       ),
//                       IconButton(
//                         onPressed: _startRecord,
//                         icon:
//                             const Icon(CupertinoIcons.mic, color: Colors.grey),
//                       ),
//                       IconButton(
//                         onPressed: _newTab,
//                         icon: const Icon(CupertinoIcons.add_circled,
//                             color: Colors.grey),
//                       )
//                     ],
//                   ),
//                 ),
//         ));
//   }
// }
