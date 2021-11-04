import 'package:cloud_firestore/cloud_firestore.dart';

Future coinUpdateFunction(String uid, Function success) async {
  int dateInMS = DateTime.now().millisecondsSinceEpoch;
  DocumentReference secondRef = FirebaseFirestore.instance
      .collection('users/byUid/$uid/category/coinsHistory')
      .doc('$dateInMS%$uid');
  DocumentReference<Map<String, dynamic>> documentReference =
      FirebaseFirestore.instance.collection('uid').doc('$uid');

  await secondRef.set({
    'title': 'Joined RapidFire ',
    'uid': uid,
    'date': dateInMS,
    'isAdded': false,
    'coin': -1
  });
  FirebaseFirestore.instance.runTransaction((transaction) async {
    // Get the document
    DocumentSnapshot<Map> snapshot = await transaction.get(documentReference);

    if (!snapshot.exists) {
      throw Exception("User does not exist!");
    }
    int coins = snapshot.data()!['coins'] - 1;
    transaction.update(documentReference, {'coins': coins});

    return coins;
  }).then((value) {
    success();
  });
}
