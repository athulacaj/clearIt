import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/screens/sucessPAge/sucess.dart';
import 'package:studywithfun/utility/provider/account.dart';
import 'package:studywithfun/utility/provider/commonprovider.dart';

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
        Provider.of<MyAccount>(context, listen: false).userDetails['uid'];

    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users/userEvents/coins')
        .doc('$uid');
    int dateInMS = DateTime.now().millisecondsSinceEpoch;

    return firestore.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot<Map> snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }
      int coins = snapshot.data()['coins'] - 1;
      transaction.update(documentReference, {'coins': coins});

      return coins;
    }).then((value) async {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      // FirebaseFirestore.instance
      //     .collection('askDoubt')
      //     .add({'queryDetails': queryDetails, 'date': '$dateInMS'});
      DocumentReference mainRef = FirebaseFirestore.instance
          .collection('askDoubt')
          .doc("$dateInMS%$uid");
      // DocumentReference firstRef = FirebaseFirestore.instance
      //     .collection('users/byUid/$uid/category/questionsHistory')
      //     .doc("$dateInMS%$uid");
      DocumentReference secondRef = firestore
          .collection('users/byUid/$uid/category/coinsHistory')
          .doc('$dateInMS%$uid');

      batch.set(mainRef, {
        'queryDetails': [queryDetails],
        'date': dateInMS,
        'uid': uid,
        'usersList': [uid]
      });
      // batch.set(firstRef, {
      //   'queryDetails': [queryDetails],
      //   'date': dateInMS
      // });
      batch.set(secondRef, {
        'title': 'Asked a question ',
        'uid': uid,
        'date': dateInMS,
        'isAdded': false,
        'coin': -1
      });
      return batch.commit();
      // return FirebaseFirestore.instance
      //     .collection('users/byUid/$uid/category/questionsHistory')
      //     .add({'queryDetails': queryDetails, 'date': '$dateInMS'});
    })
        //   .then((value) {
        // firestore
        //     .collection('users/byUid/$uid/category/coinsHistory')
        //     .doc('$dateInMS')
        //     .set({
        //   'title': 'Asked a question ',
        //   'isAdded': false,
        //   'coin': -1
        // })
        .then((value) {
      Provider.of<CommonProvider>(context, listen: false).showSpinner(false);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessPage(),
          ));
      // });
    }).catchError((error) => print("Failed to update user followers: $error"));
  }
}
