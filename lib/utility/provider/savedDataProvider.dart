import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

void saveNotesData(List dataList) async {
  final localData = await SharedPreferences.getInstance();
  String data = jsonEncode(dataList);
  localData.setString('savedData', data);
}

Future<List<Map>> getNotesData() async {
  List dataList = [];
  final localData = await SharedPreferences.getInstance();
  String userData = localData.getString('savedData') ?? '';
  print('splash scren: $userData');
  if (userData == "null" || userData == '') {
  } else {
    dataList = jsonDecode(userData);
  }
  return dataList;
}

class SavedDataProvider extends ChangeNotifier {
  List<Map> savedDataList = [];

  void addToList(Map data) {
    savedDataList.add(data);
  }
}
