import 'package:clearit/screens/sucessPAge/SuccessPage.dart';
import 'package:clearit/utility/provider/account.dart';
import 'package:clearit/utility/provider/commonprovider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

class AskDoubtDatabase {
  final String uid;
  final Map queryDetails;
  final BuildContext context;
  AskDoubtDatabase(this.uid, this.queryDetails, this.context);

  Future<void> saveData(Map queryDetails) async {
    await Provider.of<CommonProvider>(context, listen: false)
        .showSpinner(false);
    String uid =
        Provider.of<MyAccount>(context, listen: false).userDetails!['uid']!;

    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection('uid').doc('$uid');
    int dateInMS = DateTime.now().millisecondsSinceEpoch;

    WriteBatch batch = FirebaseFirestore.instance.batch();
    DocumentReference mainRef =
        FirebaseFirestore.instance.collection('askDoubt').doc("$dateInMS%$uid");
    DocumentReference secondRef = firestore
        .collection('users/byUid/$uid/category/coinsHistory')
        .doc('$dateInMS%$uid');

    batch.set(mainRef, {
      'queryDetails': [queryDetails],
      'date': dateInMS,
      'uid': uid,
      'usersList': [uid]
    });
    batch.set(secondRef, {
      'title': 'Asked a question ',
      'uid': uid,
      'date': dateInMS,
      'isAdded': false,
      'coin': -1
    });
    await batch.commit().then((value) {
      return firestore.runTransaction((transaction) async {
        // Get the document
        DocumentSnapshot<Map> snapshot =
            await transaction.get(documentReference);

        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }
        int coins = snapshot.data()!['coins'] - 1;
        transaction.update(documentReference, {'coins': coins});

        return coins;
      }).then((value) {
        Provider.of<CommonProvider>(context, listen: false).showSpinner(false);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessPage(),
            ));
      });
    }).catchError((error) {
      print("Failed to update user followers: $error");
    });
  }
}
