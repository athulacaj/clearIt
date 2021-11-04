import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

void saveNotesData(Map savedData) async {
  final localData = await SharedPreferences.getInstance();
  String data = jsonEncode(savedData);
  localData.setString('savedData', data);
}

Future<Map> getNotesData() async {
  Map savedData = {};
  final localData = await SharedPreferences.getInstance();
  String data = localData.getString('savedData') ?? '';
  // print('saved data: $data');
  if (data == "null" || data == '') {
  } else {
    savedData = jsonDecode(data);
  }
  return savedData;
}

class SavedDataProvider extends ChangeNotifier {
  Map savedData = {"Notes & Equations": []};

  void addToList(String type, Map data) {
    if (savedData[type] == null) {
      savedData[type] = [];
    }
    savedData[type].add(data);
    notifyListeners();
    saveNotesData(savedData);
  }

  void removeDataFromList(String type, Map data, String key) {
    int i = findIndex(type, data[key], key);
    print(i);
    savedData[type].removeAt(i);
    notifyListeners();
    saveNotesData(savedData);
  }

  int findIndex(String type, String title, String key) {
    int i = 0;
    for (Map data in savedData[type]) {
      if (data[key] == title) {
        return i;
      }
      i++;
    }
    return -1;
  }

  void getSavedData() async {
    savedData = await getNotesData();
  }

  void removeAllData() {
    savedData = {};
    saveNotesData(savedData);
  }
}
