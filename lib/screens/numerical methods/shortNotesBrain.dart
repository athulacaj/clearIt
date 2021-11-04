import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ShortNotesBrain {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List<QueryDocumentSnapshot>> getData() async {
    QuerySnapshot<Map<String, dynamic>> doc =
        await _firestore.collection("shortNotes").get();
    if (doc.docs.isEmpty) {
      return [];
    }
    List<QueryDocumentSnapshot<Map<String, dynamic>>> dataList = doc.docs;
    return dataList;
  }
}
