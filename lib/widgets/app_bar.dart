import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:pdf_note/components/custom_button.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String fileName;
  final VoidCallback onTabButtonPressed;
  final VoidCallback onOptionsPressed;

  const CustomAppBar({
    super.key,
    required this.fileName,
    required this.onTabButtonPressed,
    required this.onOptionsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: const Color(0xFFE6E6E6),
      leading: CustomButton(
        onPressed: onTabButtonPressed,
        icon: CupertinoIcons.rectangle_stack,
      ),
      title: Text(
        fileName.isEmpty ? "New Tab" : fileName,
        style: const TextStyle(color: Colors.grey, fontSize: 15),
      ),
      centerTitle: true,
      actions: [
        CustomButton(
          onPressed: onOptionsPressed,
          icon: CupertinoIcons.ellipsis_vertical,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
