import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:pdf_note/components/custom_button.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:pdf_note/services/newtab_mode_handler.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String filePath;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const CustomAppBar(
      {super.key, required this.filePath, required this.scaffoldKey});

  @override
  Widget build(BuildContext context) {
    final tabsManager = Provider.of<TabsManager>(context);
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFE6E6E6),
      leading: CustomButton(
        onPressed: () {
          // scaffoldKey.currentState?.openDrawer();
          ZoomDrawer.of(context)!.toggle();
        },
        icon: CupertinoIcons.rectangle_stack,
      ),
      title: Text(
        filePath.isEmpty ? "New Tab" : filePath,
        style: const TextStyle(color: Colors.grey, fontSize: 15),
      ),
      centerTitle: true,
      actions: [
        // CustomButton(
        //     onPressed: () {
        //       NewtabModeHandler.handleNewTabButton(context);
        //     },
        //     icon: CupertinoIcons.add),
        CustomButton(
          onPressed: tabsManager.toggleOption,
          icon: CupertinoIcons.ellipsis_vertical,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
