import 'package:cloud_firestore/cloud_firestore.dart';

class DailyWordDatabase {
  late FirebaseFirestore firestore;
  late int dateInMS;
  DailyWordDatabase() {
    firestore = FirebaseFirestore.instance;
    dateInMS = DateTime.now().millisecondsSinceEpoch;
  }

  Future<Map> getData() async {
    Map<String, dynamic> data = {};
    DateTime now = DateTime.now();
    String date = '$now'.substring(0, 10);
    DocumentSnapshot<Map<String, dynamic>> snap =
        await firestore.collection('dailyWord').doc(date).get();
    if (snap.exists) {
      data = snap.data()!;
      data['id'] = snap.id;
    }
    print(date);
    return data;
  }
}
