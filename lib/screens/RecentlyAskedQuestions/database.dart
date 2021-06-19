import 'package:cloud_firestore/cloud_firestore.dart';

class RecentlyAskedQuestionsDatabase {
  FirebaseFirestore firestore;
  int dateInMS;
  RecentlyAskedQuestionsDatabase() {
    firestore = FirebaseFirestore.instance;
    dateInMS = DateTime.now().millisecondsSinceEpoch;
  }
  Future<void> saveUidToQuestion(String docId, String uid) async {
    DocumentReference documentReference =
        firestore.collection('users/userEvents/coins').doc('$uid');
    DocumentReference mainRef = firestore.collection('askDoubt').doc(docId);
    DocumentReference secondRef = firestore
        .collection('users/byUid/$uid/category/coinsHistory')
        .doc('$dateInMS%$uid');

    WriteBatch batch = FirebaseFirestore.instance.batch();
    batch.update(mainRef, {
      'usersList': FieldValue.arrayUnion([uid])
    });
    batch.set(secondRef, {
      'title': 'Asked a question ',
      'uid': uid,
      'date': dateInMS,
      'isAdded': false,
      'coin': -1
    });
    await batch.commit().then((value) {
      firestore.runTransaction((transaction) async {
        // Get the document
        DocumentSnapshot<Map> snapshot =
            await transaction.get(documentReference);

        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }

        int coins = snapshot.data()['coins'] - 1;
        transaction.update(documentReference, {'coins': coins});
      });
    });
  }
}
