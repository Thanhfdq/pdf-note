import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pdf_note/components/custom_button.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
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
    var size = MediaQuery.of(context).size;
    return Drawer(
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.all(7),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 1, // Number of columns
                  mainAxisSpacing: 0, // Spacing between rows
                ),
                // padding: const EdgeInsets.all(8),
                itemCount: tabsManager.tabs.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      tabsManager
                          .setCurrentTab(index); // Switch to the selected tab
                      ZoomDrawer.of(context)!.close(); // Close the drawer
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Card(
                        color: const Color.fromARGB(171, 230, 230, 230),
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
                                      onPressed: () {},
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
                                      width: size.width,
                                      padding: const EdgeInsets.all(10),
                                      // height: size.height * 0.15,
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
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 4,
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
          ],
        ),
      ),
    );
  }
}
