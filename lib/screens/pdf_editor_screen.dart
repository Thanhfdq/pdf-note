import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdf_note/constants/app_strings.dart';
import 'package:pdf_note/providers/pdf_data.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdf_note/services/file_services.dart';
import 'package:pdf_note/widgets/canvas_painter.dart';
import 'package:provider/provider.dart';

class PdfEditorScreen extends StatefulWidget {
  const PdfEditorScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PdfEditorScreenState createState() => _PdfEditorScreenState();
}

class _PdfEditorScreenState extends State<PdfEditorScreen> {
  double _top = 0;
  double _left = 0;
  bool _isStuckToBottom = true;
  bool _isStuckToTop = false;
  bool _isBarVisible = false;

  PdfData data = PdfData();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final renderBox = context.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        final screenHeight = renderBox.size.height;
        // final appBarHeight = Scaffold.of(context).appBarMaxHeight ?? 0;
        final tabsManager = Provider.of<TabsManager>(context, listen: false);

        setState(() {
          _top = screenHeight - 50;
          _left = 0;
          _isBarVisible = true;

          // Lấy dữ liệu PDF
          final currentPage =
              tabsManager.tabs[tabsManager.currentTab].pdfState!.currentPage;
          data = tabsManager
              .tabs[tabsManager.currentTab].pdfState!.pdfDatas[currentPage - 1];
        });
      }
    });
  }

  // Call when start draw on screen by Pen tool
  void startDrawing(Offset position) {
    setState(() {
      data.addDrawing(position, [position], Colors.black, 2.0, 0.0);
    });
  }

  // Continue the draw
  void continueDrawing(Offset newPoint) {
    setState(() {
      data.addPoint(data.canvasElements.length - 1, newPoint);
    });
  }

  // Add text box
  // void addTextBox(String text, Offset position) {
  //   canvasElements.add(TextElement(
  //     position: position,
  //     text: text,
  //     fontSize: 16,
  //     color: Colors.black,
  //   ));
  // }

  // // Add image
  // void addImage(String imagePath, Offset position, Size size) {
  //   canvasElements.add(ImageElement(
  //     position: position,
  //     imagePath: imagePath,
  //     size: size,
  //   ));
  // }

  @override
  Widget build(BuildContext context) {
    // Get size to config UI
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final int appBarHeight = Scaffold.of(context).appBarMaxHeight!.toInt();
    // Get Data
    final tabsManager = Provider.of<TabsManager>(context);
    int currentPageIndex =
        tabsManager.tabs[tabsManager.currentTab].pdfState!.currentPage;
    final currentPdfState = tabsManager.tabs[tabsManager.currentTab].pdfState;
    final currentPageData = tabsManager
        .tabs[tabsManager.currentTab].pdfState!.pdfDatas[currentPageIndex - 1];

    return Stack(
      children: [
        // Content
        Positioned.fill(
          top: _isStuckToTop ? 50 : 0,
          bottom: _isStuckToBottom ? 50 : 0,
          child: // Drawing Canvas and Text Boxes
              GestureDetector(
            onPanStart: (details) {
              setState(() {
                startDrawing(details.localPosition);
              });
            },
            onPanUpdate: (details) {
              setState(() {
                continueDrawing(details.localPosition);
              });
            },
            onPanEnd: (_) {
              print("end drawing.");
            },
            child: CustomPaint(
              painter: CanvasPainter(currentPageData.canvasElements),
              size: Size.infinite,
            ),
          ),
        ),

        // Draggable panel
        if (_isBarVisible)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 0),
            top: _top,
            left: _left,
            child: GestureDetector(
              onPanStart: (_) {},
              onPanUpdate: (details) {
                setState(() {
                  _isStuckToBottom = false;
                  _isStuckToTop = false;
                  _top += details.delta.dy;
                  _left += details.delta.dx;
                });
              },
              onPanEnd: (_) {
                setState(() {
                  // Stick to top or bottom if near
                  if (_top <= 0) {
                    _isStuckToTop = true;
                    _isStuckToBottom = false;
                    _top = 0;
                    _left = 0;
                  } else if (_top >= screenHeight - appBarHeight - 50) {
                    _isStuckToBottom = true;
                    _isStuckToTop = false;
                    _top = screenHeight - appBarHeight - 50;
                    _left = 0;
                  }
                });
              },
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(
                    _isStuckToBottom || _isStuckToTop ? 0 : 20)),
                child: BackdropFilter(
                  filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    width: screenWidth,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.all(
                        Radius.circular(
                            _isStuckToBottom || _isStuckToTop ? 0 : 20),
                      ),
                    ),
                    // Tools
                    child: Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              icon: const Icon(CupertinoIcons.down_arrow,
                                  color: Colors.white),
                              onPressed: _save,
                            ),
                            IconButton(
                              icon: Icon(CupertinoIcons.clear_fill,
                                  color: currentPdfState!.currentTool ==
                                          AppStrings.eraserTool
                                      ? Colors.blue
                                      : Colors.white),
                              onPressed: _clearCanvas,
                            ),
                            IconButton(
                              icon: Icon(CupertinoIcons.pen,
                                  color: currentPdfState.currentTool ==
                                          AppStrings.penTool
                                      ? Colors.blue
                                      : Colors.white),
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(CupertinoIcons.textbox,
                                  color: Colors.white),
                              // onPressed: _addTextBox,
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                  CupertinoIcons.arrow_turn_up_left,
                                  color: Colors.white),
                              // onPressed: _undo,
                              onPressed: () {},
                            ),
                            IconButton(
                              icon: const Icon(
                                  CupertinoIcons.arrow_turn_up_right,
                                  color: Colors.white),
                              onPressed: _redo,
                            ),
                          ]),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  void _clearCanvas() {
    final tabsManager = Provider.of<TabsManager>(context);
    int currentPageIndex =
        tabsManager.tabs[tabsManager.currentTab].pdfState!.currentPage - 1;
    final currentPageData = tabsManager
        .tabs[tabsManager.currentTab].pdfState!.pdfDatas[currentPageIndex];
    setState(() {
      currentPageData.canvasElements.clear();
    });
  }

  // void _addTextBox() {
  //   setState(() {
  //     _textBoxes.add(TextBox(x: 100, y: 100, content: 'New Text'));
  //   });
  // }

  // void _undo() {
  //   setState(() {
  //     if (_paths.isNotEmpty) _paths.removeLast();
  //   });
  // }

  void _redo() {
    // Implement redo functionality if required
  }

  void _save() {
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    setState(() {
      FileService().savePdfNote(
          context,
          tabsManager.tabs[tabsManager.currentTab].pdfState!.pdfDatas[0]
              .canvasElements);
    });
    print("Saving...");
  }
}
