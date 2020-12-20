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

    return firestore.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }

      int coins = snapshot.data()['coins'] - 1;
      transaction.update(documentReference, {'coins': coins});

      return coins;
    }).then((value) async {
      FirebaseFirestore.instance
          .collection('askDoubt')
          .add({'queryDetails': queryDetails});
      return FirebaseFirestore.instance
          .collection('users/byUid/$uid/category/questionsHistory')
          .add({'queryDetails': queryDetails});
    }).then((value) {
      int dateInMS = DateTime.now().millisecondsSinceEpoch;
      firestore
          .collection('users/byUid/$uid/category/coinsHistory')
          .doc('$dateInMS')
          .set({
        'title': 'Asked a question ',
        'isAdded': false,
        'coin': -1
      }).then((value) {
        Provider.of<CommonProvider>(context, listen: false).showSpinner(false);
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SuccessPage(),
            ));
      });
    }).catchError((error) => print("Failed to update user followers: $error"));
  }
}
