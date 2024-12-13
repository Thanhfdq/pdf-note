import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdf_note/constants/app_numbers.dart';
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
  // Canvas key
  final GlobalKey _canvasKey = GlobalKey();
  // Save the current moved object
  CanvasElement? _movingElement;
  late int _movingElementIndex;
  Offset? _initialTouchOffset;

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
              .canvasStates[currentPageNumber - 1];
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
    //init canvas size
    double canvasWidth;
    double canvasHeight;
    canvasWidth = screenWidth;
    canvasHeight = screenWidth * AppNumbers.a4AspectRatio;
    if (canvasHeight > screenHeight) {
      canvasHeight = screenHeight;
      canvasWidth = canvasHeight / AppNumbers.a4AspectRatio;
    }

    // Get state datas
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    final currentPdfState = tabsManager.tabs[tabsManager.currentTab].pdfState;
    final currentPageNumber = currentPdfState!.currentPage;
    // Data
    final currentPageData = currentPdfState.canvasStates[currentPageNumber - 1];

    return Stack(children: [
      Center(
        child: Container(
          width: canvasWidth,
          height: canvasHeight,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Colors.black,
                  strokeAlign: BorderSide.strokeAlignOutside,
                  width: 1)),
          child: InteractiveViewer(
            boundaryMargin: EdgeInsets.zero,
            minScale: 1.0,
            maxScale: 3.0,
            child: GestureDetector(
              onPanStart: (details) {
                setState(() {
                  if (currentPdfState.currentTool == AppStrings.penTool) {
                    newInkStroke(details.localPosition);
                  } else if (currentPdfState.currentTool ==
                      AppStrings.eraserTool) {
                    newEraseStroke(details.localPosition);
                  } else {
                    // Moving mode
                    onPanStart(details);
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
                  } else {
                    // Moving mode
                    onPanUpdate(details);
                  }
                });
              },
              onPanEnd: (details) {
                onPanEnd(details);
              },
              child: Container(
                key: _canvasKey,
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        color: Colors.black,
                        strokeAlign: BorderSide.strokeAlignOutside,
                        width: 1)),
                child: CustomPaint(
                  painter: CanvasPainter(currentPageData.canvasElements),
                ),
              ),
            ),
          ),
        ),
      ), // End center

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
              borderRadius: BorderRadius.all(
                  Radius.circular(_isStuckToBottom || _isStuckToTop ? 0 : 20)),
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
                            icon: Icon(CupertinoIcons.cursor_rays,
                                color: currentPdfState.currentTool ==
                                        AppStrings.moving
                                    ? Colors.blue
                                    : Colors.white),
                            onPressed: () => _changeTool(AppStrings.moving),
                          ),
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
                            onPressed: () {
                              addTextBox(
                                  "Sample2 text", const ui.Offset(200, 200));
                            },
                          ),
                          IconButton(
                            icon: const Icon(CupertinoIcons.tree,
                                color: Colors.white),
                            onPressed: () {
                              setState(() => addImage());
                            },
                          ),
                          IconButton(
                            icon: const Icon(CupertinoIcons.arrow_turn_up_left,
                                color: Colors.white),
                            // onPressed: _undo,
                            onPressed: () {},
                          ),
                          IconButton(
                            icon: const Icon(CupertinoIcons.arrow_turn_up_right,
                                color: Colors.white),
                            onPressed: () {},
                          ),
                        ]),
                  ), // End Expended
                ),
              ),
            ),
          ),
        ), // End animated Posiotioned
    ]);
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
  void addImage() {
    final tabsManager = Provider.of<TabsManager>(context, listen: false);
    final currentPdfState = tabsManager.tabs[tabsManager.currentTab].pdfState;
    FileService().addImageToPdf(context, tabsManager.currentTab,
        currentPdfState!.currentPage - 1, const ui.Offset(100, 100));
  }

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
        .tabs[tabsManager.currentTab].pdfState!.canvasStates[currentPageIndex];
    setState(() {
      currentPageData.canvasElements.clear();
    });
  }

  void _save() {
    final tabsManager = Provider.of<TabsManager>(context, listen: false);

    final RenderBox renderBox =
        _canvasKey.currentContext!.findRenderObject() as RenderBox;
    final Size canvasSize = renderBox.size;
    setState(() {
      FileService().savePdfNote(
          context,
          tabsManager.tabs[tabsManager.currentTab].pdfState!.canvasStates[0]
              .canvasElements,
          canvasSize);
    });
    print("Saving...");
  }

//Moving object event handle
  void onPanStart(DragStartDetails details) {
    print("Start move...");
    final touchPosition = details.localPosition;

    for (int i = 0; i < canvasData.canvasElements.length; i++) {
      print(i);
      final element = canvasData.canvasElements[i];
      if (element is TextBox) {
        if (element.constainsPoint(touchPosition)) {
          print("moving a textbox...");
          _movingElement = element;
          _movingElementIndex =
              i; // save the moving element index for change position
          _initialTouchOffset = touchPosition - element.position;
          break;
        }
      } else if (element is InsertImage) {
        print("moving an image...");
        if (element.constainsPoint(touchPosition)) {
          _movingElement = element;
          _movingElementIndex = i;
          _initialTouchOffset =
              touchPosition - Offset(element.position.dx, element.position.dy);
          break;
        }
      }
      // InkStroke handling depends on your requirements (e.g., bounding box or selection handle).
    }
  }

  void onPanUpdate(DragUpdateDetails details) {
    print("moving...");
    if (_movingElement != null && _initialTouchOffset != null) {
      final touchPosition = details.localPosition;
      final element = canvasData.canvasElements[_movingElementIndex];
      if (element is TextBox) {
        element.position = touchPosition - _initialTouchOffset!;
      } else if (element is InsertImage) {
        final dx = touchPosition.dx - _initialTouchOffset!.dx;
        final dy = touchPosition.dy - _initialTouchOffset!.dy;
        element.position = Offset(dx, dy);
      }

      // if (_movingElement is TextBox) {
      //   (_movingElement as TextBox).position =
      //       touchPosition - _initialTouchOffset!;
      // } else if (_movingElement is InsertImage) {
      //   final dx = touchPosition.dx - _initialTouchOffset!.dx;
      //   final dy = touchPosition.dy - _initialTouchOffset!.dy;
      //   (_movingElement as InsertImage).position = Offset(dx, dy);
      // }
      // For InkStroke, update its points or bounding box.
      // updateCanvas();
    }
  }

  void onPanEnd(DragEndDetails details) {
    print("end move.");
    _movingElement = null;
    _initialTouchOffset = null;
  }

  void updateCanvas() {
    setState(() {
      // Trigger a repaint of the canvas.
    });
  }
}
