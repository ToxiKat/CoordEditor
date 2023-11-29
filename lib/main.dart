import 'package:coordeditor/values/values.dart';
import 'package:coordeditor/views/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    initvalues();
    useSystemTheme.addListener(() {
      try {
        setState(() {});
      } finally {}
    });
    isDarkTheme.addListener(() {
      try {
        setState(() {});
      } finally {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: useSystemTheme.value
          ? ThemeMode.system
          : isDarkTheme.value
              ? ThemeMode.dark
              : ThemeMode.light,
      home: const HomePage(),
    );
  }
}
