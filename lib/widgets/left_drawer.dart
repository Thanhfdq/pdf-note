import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
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
    TabsManager tabsManager = Provider.of<TabsManager>(context);
    return Stack(children: [
      // Blurred Background
      GestureDetector(
        onTap: tabsManager.toggleTabWindow,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ),
      // Content
      Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            // Show number of tabs
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      "${tabsManager.tabs.length} tabs"),
                )),
              ],
            ),
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
                    child: Padding(
                      padding:
                          const EdgeInsets.only(bottom: 7, left: 10, right: 10),
                      child: Card(
                        color: tabsManager.currentTab == index
                            ? Colors.white
                            : const Color.fromARGB(171, 230, 230, 230),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            // File Name
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
                                              tabsManager.tabs[index].filePath),
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
                                        FileService().closeTab(context, index);
                                      },
                                      icon: CupertinoIcons.xmark)
                                ],
                              ),
                            ),
                            // Markdown Content
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
                                          tabsManager.tabs[index].mode == "new"
                                              ? ""
                                              : tabsManager.tabs[index]
                                                      .markdownState?.content ??
                                                  "",
                                          style: const TextStyle(
                                            fontSize: 5,
                                            color: Colors.grey,
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CupertinoButton(
                  onPressed: () => FileService().closeAllTab(context),
                  child: const Text("Close all"),
                ),
                CupertinoButton(
                  onPressed: () {
                    NewtabModeHandler.handleNewTabButton(context);
                  },
                  child: const Text("New Tab"),
                )
              ],
            )
          ],
        ),
      ),
    ]);
  }
}
