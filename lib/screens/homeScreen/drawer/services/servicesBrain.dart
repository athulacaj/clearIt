import 'package:cloud_firestore/cloud_firestore.dart';

class ServiceBrain {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List> get(String type) async {
    List items = [];
    try {
      DocumentSnapshot<Map> data =
          await _firestore.collection("common").doc(type).get();
      print(data.data());
      if (data.exists) {
        Map details = data.data()!;
        items = details['items'];
        print("items $items");
      }
    } catch (e) {}
    return items;
  }
}
