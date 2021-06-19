import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/utility/provider/account.dart';

class FirebaseServices {
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;

  //recieve the data

  Stream<int> getUserCoin(String uid) {
    return _fireStoreDataBase
        .collection('user/userEvents/coins')
        .doc('')
        .snapshots()
        .map((snapShot) => snapShot.data()['coin']);
  }

  Stream getUsersCoin(String uid) {
    return _fireStoreDataBase
        .collection('users/userEvents/coins')
        .doc(uid)
        .snapshots()
        .map((snapShot) => Account.fromJson(snapShot.data()));
  }

  //upload a data
  addUser() {
    var addUserData = Map<String, dynamic>();
    addUserData['name'] = "Andrew Holder";
    addUserData['age'] = "31yrs";
    return _fireStoreDataBase
        .collection('user')
        .doc('user_03')
        .set(addUserData);
  }
}

class Account with ChangeNotifier {
  int coins = 0;
  setCoins(received) {
    coins = received;
  }

  Account.fromJson(Map<String, dynamic> parsedJSON)
      : coins = parsedJSON['coins'];
  // age = parsedJSON['age'];
}

//
// ../
//

class CoinsClass {
  int coins;
  CoinsClass({this.coins});
}

CoinsClass getInitialData() {
  return CoinsClass(coins: 0);
}

class CoinsStream {
  String uid;
  BuildContext context;
  CoinsStream(this.uid, this.context);
  FirebaseFirestore _fireStoreDataBase = FirebaseFirestore.instance;
  Stream<CoinsClass> get getCoin {
    return _fireStoreDataBase
        .collection('users/userEvents/coins')
        .doc(uid)
        .snapshots()
        .map((snapShot) {
      print('coins updated to ${snapShot.data()['coins']}');
      Provider.of<MyAccount>(context, listen: false)
          .setCoins(snapShot.data()['coins']);

      return CoinsClass(coins: snapShot.data()['coins']);
    });
  }
}
