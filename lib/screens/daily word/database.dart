import 'package:cloud_firestore/cloud_firestore.dart';

class DailyWordDatabase {
  FirebaseFirestore firestore;
  int dateInMS;
  DailyWordDatabase() {
    firestore = FirebaseFirestore.instance;
    dateInMS = DateTime.now().millisecondsSinceEpoch;
  }

  Future<Map> getData() async {
    Map data = {};
    DateTime now = DateTime.now();
    String date = '$now'.substring(0, 10);
    DocumentSnapshot snap =
        await firestore.collection('dailyWord').doc(date).get();
    if (snap.exists) {
      data = snap.data();
    }
    print(date);
    return data;
  }
}
