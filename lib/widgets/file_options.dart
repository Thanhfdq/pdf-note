import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/tab_mangager.dart';

class FileOptions extends StatefulWidget {
  const FileOptions({super.key});

  @override
  State<FileOptions> createState() => _FileOptionsState();
}

class _FileOptionsState extends State<FileOptions> {
  @override
  Widget build(BuildContext context) {
    final tabsManager = Provider.of<TabsManager>(context);
    return Stack(
      children: [
        // Blurred Background
        GestureDetector(
          onTap: tabsManager.toggleOption,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
        ),
        // Drawer Content
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 50),
                ListTile(
                  leading: const Icon(Icons.home),
                  title: const Text("Home"),
                  onTap: () {
                    // Handle tap
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text("Settings"),
                  onTap: () {
                    // Handle tap
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout),
                  title: const Text("Logout"),
                  onTap: () {
                    // Handle tap
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
