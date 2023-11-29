import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

ValueNotifier<bool> useSystemTheme = ValueNotifier<bool>(true);
ValueNotifier<bool> isDarkTheme = ValueNotifier<bool>(false);
ValueNotifier<bool> defaultExpand = ValueNotifier<bool>(false);
ValueNotifier<String> jsonPath = ValueNotifier<String>("");

void initvalues() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  useSystemTheme.value = prefs.getBool("useSystemTheme") ?? true;
  isDarkTheme.value = prefs.getBool("isDarkTheme") ?? false;
  defaultExpand.value = prefs.getBool("defaultExpand") ?? false;
  jsonPath.value = prefs.getString("jsonPath") ?? "";

  useSystemTheme.addListener(() async {
    await prefs.setBool("useSystemTheme", useSystemTheme.value);
  });

  isDarkTheme.addListener(() async {
    await prefs.setBool("isDarkTheme", isDarkTheme.value);
  });

  defaultExpand.addListener(() async {
    await prefs.setBool("defaultExpand", defaultExpand.value);
  });

  jsonPath.addListener(
    () async {
      await prefs.setString("jsonPath", jsonPath.value);
    },
  );
}

void deleteprefs() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.clear();
  initvalues();
}

void getJsonPath() async {
  FilePickerResult? jsonFile = await FilePicker.platform.pickFiles(
    type: FileType.custom,
    allowedExtensions: ["json"],
  );
  if (jsonFile != null) {
    jsonPath.value = jsonFile.files.single.path ?? "";
  }
}

Future<List> getJsonValues() async {
  if (jsonPath.value.isNotEmpty) {
    List out = [];
    final String response = await File(jsonPath.value).readAsString();
    Map<String, dynamic> jsonData = json.decode(response);
    for (MapEntry entry in jsonData.entries) {
      out.add({"key": entry.key, "value": entry.value});
    }
    return out;
  } else {
    return [];
  }
}

void saveJsonValues(Map outJson) async {
  if (jsonPath.value.isNotEmpty) {
    JsonEncoder encoder = const JsonEncoder.withIndent("  ");
    String dumpJson = encoder.convert(outJson);
    // print("Saving as: \n$dumpJson");
    await File(jsonPath.value).writeAsString(dumpJson);
  }
}

Future<void> addJsonKeyValues(String key, Map value) async {
  if (jsonPath.value.isNotEmpty) {
    final String response = await File(jsonPath.value).readAsString();
    Map<String, dynamic> jsonData = json.decode(response);
    jsonData[key] = value;

    saveJsonValues(jsonData);
    // JsonEncoder encoder = const JsonEncoder.withIndent("  ");
    // String dumpJson = encoder.convert(jsonData);
    // await File(jsonPath.value).writeAsString(dumpJson);
  }
}

Future deleteJsonKeyValues(List toNotDelete) async {
  if (jsonPath.value.isNotEmpty) {
    Map out = {};
    final String response = await File(jsonPath.value).readAsString();
    Map<String, dynamic> jsonData = json.decode(response);
    for (MapEntry entry in jsonData.entries) {
      String curKey = entry.key;
      if (toNotDelete.contains(curKey)) {
        out[curKey] = entry.value;
      }
    }
    saveJsonValues(out);
  }
}

Future reorderJsonKeys(List reorderedList) async {
  if (jsonPath.value.isNotEmpty) {
    Map out = {};
    for (String i in reorderedList) {
      out[i] = {};
    }
    final String response = await File(jsonPath.value).readAsString();
    Map<String, dynamic> jsonData = json.decode(response);
    for (MapEntry entry in jsonData.entries) {
      if (reorderedList.contains(entry.key)) {
        out[entry.key] = entry.value;
      }
    }
    saveJsonValues(out);
  }
}
