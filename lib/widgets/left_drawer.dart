import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pdf_note/components/custom_button.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdf_note/services/file_services.dart';
import 'package:pdf_note/services/newtab_mode_handler.dart';
import 'package:provider/provider.dart';
import '../utils/file_helper.dart';

class LeftDrawer extends StatefulWidget {
  const LeftDrawer({super.key});

  @override
  State<StatefulWidget> createState() => _LeftDrawerState();
}

class _LeftDrawerState extends State<LeftDrawer> {
  @override
  Widget build(BuildContext context) {
    TabsManager tabsManager = Provider.of<TabsManager>(context, listen: true);

    return Stack(children: [
      BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Column(
          children: [
            // List tabs opening
            Expanded(
              child: GridView.builder(
                reverse: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of columns
                  mainAxisSpacing: 0, // Spacing between rows
                ),
                // padding: const EdgeInsets.all(8),
                itemCount: tabsManager.tabs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      tabsManager
                          .setCurrentTab(index); // Switch to the selected tab
                      tabsManager.toggleTabWindow(); // Close the drawer
                    },
                    // 1 item
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Container(
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.3), // Màu bóng và độ mờ
                                spreadRadius: 8, // Độ lan của bóng
                                blurRadius: 10, // Độ mờ của bóng
                                offset: const Offset(0, 0), // Độ lệch (x, y)
                              ),
                            ],
                            border: Border.all(
                                color: Colors.blue,
                                strokeAlign: BorderSide.strokeAlignOutside,
                                width: tabsManager.currentTab == index ? 5 : 0),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(20))),
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            // Tab
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                // Title bar
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          FileHelper.getFileName(tabsManager
                                                      .tabs[index].filePath) ==
                                                  ""
                                              ? "Blank tab"
                                              : FileHelper.getFileName(
                                                  tabsManager
                                                      .tabs[index].filePath),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                      CustomButton(
                                          onPressed: () {
                                            FileService()
                                                .closeTab(context, index);
                                          },
                                          icon: CupertinoIcons.xmark)
                                    ],
                                  ),
                                ), // End title bar
                                // Content
                                Expanded(
                                  child: tabsManager.tabs[index].mode == "new"
                                      ? const Center(
                                          child: Icon(
                                            CupertinoIcons.doc,
                                            size: 100,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : Container(
                                          color: Colors.white,
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(10),
                                          // height: size.height * 0.15,
                                          child: Expanded(
                                            child: Text(
                                              tabsManager.tabs[index].mode ==
                                                      "new"
                                                  ? ""
                                                  : tabsManager
                                                          .tabs[index]
                                                          .markdownState
                                                          ?.content ??
                                                      "",
                                              style: const TextStyle(
                                                fontSize: 5,
                                                color: Colors.grey,
                                              ),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                        ),
                                ), // end content
                              ],
                            ), // End Tab
                          ),
                        ),
                      ),
                    ), // End 1 Item
                  );
                },
              ),
            ), // End list item
            // Actions
            Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    onPressed: () => FileService().closeAllTab(context),
                    child: const Text("Close all"),
                  ),
                  Text(
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      "${tabsManager.tabs.length} tabs"),
                  CupertinoButton(
                    onPressed: () {
                      NewtabModeHandler.handleNewTabButton(context);
                    },
                    child: const Text("New Tab"),
                  )
                ],
              ),
            ) // End actions
          ],
        ),
      ), // End Padding
    ]);
  }
}
