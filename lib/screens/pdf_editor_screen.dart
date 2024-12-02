import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdf_note/components/custom_button.dart';

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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Set default position to stick at the bottom
      final screenHeight = MediaQuery.of(context).size.height;
      final int appBarHeight = Scaffold.of(context).appBarMaxHeight!.toInt();
      setState(() {
        _top = screenHeight - appBarHeight - 50;
        _left = 0;
        _isBarVisible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final int appBarHeight = Scaffold.of(context).appBarMaxHeight!.toInt();

    return Stack(
      children: [
        // Content
        Positioned.fill(
          top: _isStuckToTop ? 50 : 0,
          bottom: _isStuckToBottom ? 50 : 0,
          child: Container(
            color: Colors.white,
            child: const Center(
              child: Text(
                "Main Content Area",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
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
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
                            CustomButton(
                                icon: CupertinoIcons.clear_fill,
                                onPressed: () {}),
                            CustomButton(
                                icon: CupertinoIcons.pen, onPressed: () {}),
                            CustomButton(
                                icon: CupertinoIcons.textbox, onPressed: () {}),
                            CustomButton(
                                icon: CupertinoIcons.arrow_turn_up_left,
                                onPressed: () {}),
                            CustomButton(
                                icon: CupertinoIcons.arrow_turn_up_right,
                                onPressed: () {}),
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
}
