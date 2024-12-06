import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdf_note/constants/app_strings.dart';
import 'package:pdf_note/models/canvas_element.dart';
import 'package:pdf_note/providers/canvas_state.dart';
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
  // Bar positioning data
  double _toolBarTop = 0;
  double _toolBarLeft = 0;
  bool _isStuckToBottom = true;
  bool _isStuckToTop = false;
  bool _isBarVisible = false;

  // Canvas data of current page
  CanvasState canvasData = CanvasState();

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
          // Init tool bar position at the bottom
          _toolBarTop = screenHeight - 50;
          _toolBarLeft = 0;
          _isBarVisible = true;

          // Listen page data from provider
          final currentPageNumber =
              tabsManager.tabs[tabsManager.currentTab].pdfState!.currentPage;
          canvasData = tabsManager.tabs[tabsManager.currentTab].pdfState!
              .pageDatas[currentPageNumber - 1];
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get size to config UI
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final int appBarHeight = Scaffold.of(context).appBarMaxHeight!.toInt();
    // Get state datas
    final tabsManager = Provider.of<TabsManager>(context);
    final currentPdfState = tabsManager.tabs[tabsManager.currentTab].pdfState;
    final currentPageNumber = currentPdfState!.currentPage;
    // Data
    final currentPageData = currentPdfState.pageDatas[currentPageNumber - 1];

    return Stack(
      children: [
        // Page Data
        Positioned.fill(
          top: _isStuckToTop ? 50 : 0,
          bottom: _isStuckToBottom ? 50 : 0,
          child: GestureDetector(
            onPanStart: (details) {
              setState(() {
                if (currentPdfState.currentTool == AppStrings.penTool) {
                  newInkStroke(details.localPosition);
                } else if (currentPdfState.currentTool ==
                    AppStrings.eraserTool) {
                  newEraseStroke(details.localPosition);
                }
              });
            },
            onPanUpdate: (details) {
              setState(() {
                if (currentPdfState.currentTool == AppStrings.penTool) {
                  inkStrokeExtense(details.localPosition);
                } else if (currentPdfState.currentTool ==
                    AppStrings.eraserTool) {
                  eraseStrokeExtense(details.localPosition);
                }
              });
            },
            child: CustomPaint(
              painter: CanvasPainter(currentPageData.canvasElements),
              size: Size.infinite,
            ),
          ),
        ),

        // Draggable toolbar
        if (_isBarVisible)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 0),
            top: _toolBarTop,
            left: _toolBarLeft,
            child: GestureDetector(
              onPanStart: (_) {},
              onPanUpdate: (details) {
                setState(() {
                  _isStuckToBottom = false;
                  _isStuckToTop = false;
                  _toolBarTop += details.delta.dy;
                  _toolBarLeft += details.delta.dx;
                });
              },
              onPanEnd: (_) {
                setState(() {
                  // Stick to top or bottom if near
                  if (_toolBarTop <= 0) {
                    _isStuckToTop = true;
                    _isStuckToBottom = false;
                    _toolBarTop = 0;
                    _toolBarLeft = 0;
                  } else if (_toolBarTop >= screenHeight - appBarHeight - 50) {
                    _isStuckToBottom = true;
                    _isStuckToTop = false;
                    _toolBarTop = screenHeight - appBarHeight - 50;
                    _toolBarLeft = 0;
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
                                  color: currentPdfState.currentTool ==
                                          AppStrings.eraserTool
                                      ? Colors.blue
                                      : Colors.white),
                              onPressed: () {
                                print("erasing...");
                                _changeTool(AppStrings.eraserTool);
                              },
                            ),
                            IconButton(
                              icon: Icon(CupertinoIcons.pen,
                                  color: currentPdfState.currentTool ==
                                          AppStrings.penTool
                                      ? Colors.blue
                                      : Colors.white),
                              onPressed: () {
                                _changeTool(AppStrings.penTool);
                              },
                            ),
                            IconButton(
                              icon: const Icon(CupertinoIcons.textbox,
                                  color: Colors.white),
                              // onPressed: _addTextBox,
                              onPressed: () {
                                addTextBox(
                                    "Sample2 text", const ui.Offset(200, 200));
                              },
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
                              onPressed: () {},
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

  // Canvas actions
  // drawing
  void newInkStroke(Offset position) {
    // Get state datas
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    final currentPdfState = tabsManager.tabs[tabsManager.currentTab].pdfState;
    setState(() {
      canvasData.addInkStroke(
          position,
          [position],
          currentPdfState?.penConfig.color,
          currentPdfState?.penConfig.strokewidth,
          0.0);
    });
  }

  void inkStrokeExtense(Offset position) {
    setState(() =>
        (canvasData.canvasElements.last as InkStroke).inkDots.add(position));
  }

  //Erase
  void newEraseStroke(Offset position) {
    // Get state datas
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    final currentPdfState = tabsManager.tabs[tabsManager.currentTab].pdfState;
    setState(() {
      canvasData.addEraser(
          position, [position], currentPdfState!.eraserConfig.eraseStrokeWidth);
    });
  }

  void eraseStrokeExtense(Offset position) {
    setState(() => (canvasData.canvasElements.last as EraserStroke)
        .eraserDots
        .add(position));
  }

  // Add text box
  void addTextBox(String text, Offset position) {
    setState(() {
      canvasData.addTextBox(position, text, 16, Colors.black, 0.0);
    });
  }
  // // Add image
  // void addImage(String imagePath, Offset position, Size size) {
  //   canvasElements.add(ImageElement(
  //     position: position,
  //     imagePath: imagePath,
  //     size: size,
  //   ));
  // }

  void _changeTool(String tool) {
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    final currentPdfState = tabsManager.tabs[tabsManager.currentTab].pdfState;
    setState(() {
      currentPdfState?.currentTool = tool;
    });
  }

  void _clearCanvas() {
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    int currentPageIndex =
        tabsManager.tabs[tabsManager.currentTab].pdfState!.currentPage - 1;
    final currentPageData = tabsManager
        .tabs[tabsManager.currentTab].pdfState!.pageDatas[currentPageIndex];
    setState(() {
      currentPageData.canvasElements.clear();
    });
  }

  // void _addTextBox() {
  //   setState(() {
  //     _textBoxes.add(TextBox(x: 100, y: 100, content: 'New Text'));
  //   });
  // }

  void _save() {
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    setState(() {
      FileService().savePdfNote(
          context,
          tabsManager.tabs[tabsManager.currentTab].pdfState!.pageDatas[0]
              .canvasElements);
    });
    print("Saving...");
  }
}
