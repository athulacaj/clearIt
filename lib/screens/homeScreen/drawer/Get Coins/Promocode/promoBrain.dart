import 'package:clearit/utility/provider/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

class PromocodeBrain {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  QuerySnapshot<Map<String, dynamic>>? doc;
  late String uid;
  PromocodeBrain(BuildContext context) {
    uid = Provider.of<MyAccount>(context, listen: false).userDetails!['uid']!;
  }
  Future<String> checkPromocode(
    String promo,
  ) async {
    if (doc == null) {
      doc = await _firestore.collection("common/getCoins/promocodes").get();
    }
    List<QueryDocumentSnapshot<Map>> data = doc!.docs;
    bool isPromocodeAvialble = false;
    int coins = 0;
    for (QueryDocumentSnapshot<Map> snap in data) {
      if (snap.id == promo) {
        isPromocodeAvialble = true;
        coins = snap.data()['coin'];
        bool isAlreadyRedeemed = await checkAlreadyRedeemed(promo);
        if (isAlreadyRedeemed) {
          return "You already redeemed this promocode.";
        }
        bool isCoinUpdated = await updateCoins(coins, promo);
        return isCoinUpdated
            ? "Successfully Applied"
            : "Error, Try again after some time";
      }
    }
    return "Promocode doesn't exist.";
  }

  Future<bool> checkAlreadyRedeemed(String id) async {
    DocumentSnapshot snap = await _firestore
        .collection("common/getCoins/promocodes/$id/users")
        .doc(uid)
        .get();
    if (snap.exists) {
      return true;
    }
    return false;
  }

  Future<bool> updateCoins(int bonus, String id) async {
    DocumentReference<Map<String, dynamic>> documentReference =
        FirebaseFirestore.instance.collection('uid').doc('$uid');
    try {
      await _firestore.runTransaction((transaction) async {
        // Get the document
        DocumentSnapshot<Map> snapshot =
            await transaction.get(documentReference);

        if (!snapshot.exists) {
          throw Exception("User does not exist!");
        }
        int coins = snapshot.data()!['coins'] + bonus;
        transaction.update(documentReference, {'coins': coins});

        return coins;
      });
      await _firestore
          .collection("common/getCoins/promocodes/$id/users")
          .doc(uid)
          .set({});
      int dateInMS = DateTime.now().millisecondsSinceEpoch;
      DocumentReference secondRef = _firestore
          .collection('users/byUid/$uid/category/coinsHistory')
          .doc('$dateInMS');
      await secondRef.set({
        'title': 'Redeemed a promocode ',
        'uid': uid,
        'date': dateInMS,
        'isAdded': false,
        'coin': bonus,
      });
      return true;
    } catch (e) {}
    return false;
  }
}
