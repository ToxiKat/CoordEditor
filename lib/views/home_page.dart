import 'package:coordeditor/values/values.dart';
import 'package:coordeditor/views/editor_view.dart';
import 'package:coordeditor/views/settings_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Coord Editor"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const SettingsPage(),
                ),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      body: getBody(),
    );
  }

  Widget getBody() {
    jsonPath.addListener(() {
      try {
        setState(() {});
      } finally {}
    });
    if (jsonPath.value.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Set the Path to the json file"),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: getJsonPath,
              child: Text("Set Path"),
            ),
          ],
        ),
      );
    } else {
      return const EditingView();
    }
  }
}
