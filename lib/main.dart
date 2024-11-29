import 'package:flutter/material.dart';
import 'package:pdf_note/providers/tab_mangager.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => TabsManager())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'SFPro'
      ),
      debugShowCheckedModeBanner: false,
      title: "PDF Note",
      home: const Home(),
    );
  }
}
