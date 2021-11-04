import 'package:clearit/utility/provider/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'RapiFireClass.dart';
import 'qusetionAnswerProvider.dart';

void saveRapidFireId(BuildContext context, String id) async {
  final localData = await SharedPreferences.getInstance();
  Map user = Provider.of<MyAccount>(context, listen: false).userDetails!;
  String uid = user['uid'];
  try {
    FirebaseFirestore.instance
        .collection("rapidFire/finished/${user['category'] ?? "psc"}")
        .doc(uid)
        .set({"id": id});
    localData.setString('rapidFireId', id);
  } catch (e) {}
}

Future<String> getSavedRapidFireId(BuildContext context) async {
  final localData = await SharedPreferences.getInstance();
  String userData = localData.getString('rapidFireId') ?? '';
  userData = '';
  if (userData == '') {
    Map users = Provider.of<MyAccount>(context, listen: false).userDetails!;
    String uid = users['uid'];

    DocumentSnapshot<Map> snap = await FirebaseFirestore.instance
        .collection("rapidFire/finished/${users['category']}")
        .doc(uid)
        .get();
    if (snap.exists) {
      userData = snap.data()!['id'];
      saveRapidFireId(context, userData);
    }
  }
  return userData;
}

void saveData() async {
  RapidFireClass cls = RapidFireClass();
  Map<String, dynamic> data = cls.questionsDatabase;
  await FirebaseFirestore.instance
      .collection("rapidFire/category/psc")
      .add(data);
}

class RapidFireManger {
  static Future<Map?> getData(BuildContext context) async {
    String category = Provider.of<MyAccount>(context, listen: false)
            .userDetails!['category'] ??
        'psc';
    print(category);
    QuerySnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance
        .collection("rapidFire/category/$category")
        .orderBy("date", descending: true)
        .limit(1)
        .get();
    print(doc.docs);
    if (doc.docs.isNotEmpty) {
      QueryDocumentSnapshot<Map> data = doc.docs[0];
      Map testDetails = data.data();
      testDetails['id'] = data.id;
      return testDetails;
    }
    return null;
  }

  static Future saveResult(BuildContext context, Map testData, int s) async {
    List<Map> answeredList =
        Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false)
            .answeredList;
    Map user = Provider.of<MyAccount>(context, listen: false).userDetails!;
    Map resultData = calculateScore(testData['questionsList'], answeredList);
    int score = resultData['correct'];
    if (score == 10) {
      wonCoins(testData, user['uid']);
    }
    await FirebaseFirestore.instance
        .collection("rapidFire/result/${testData['date']}")
        .doc(user['uid'])
        .set({
      'score': score,
      'time': s,
      'user': user,
      'order': (score * 1000) + (1000 - s)
    });
  }
}

void wonCoins(Map questionData, String uid) async {
  int coinsToAdd = 5;
  if (questionData.containsKey("coins") && questionData['coins'] != null) {
    coinsToAdd = questionData['coins'];
  }
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  DocumentReference<Map<String, dynamic>> documentReference =
      FirebaseFirestore.instance.collection('uid').doc('$uid');
  int dateInMS = DateTime.now().millisecondsSinceEpoch;
  DocumentReference coinHistoryRef = _firestore
      .collection('users/byUid/$uid/category/coinsHistory')
      .doc('$dateInMS%$uid');

  return _firestore.runTransaction((transaction) async {
    // Get the document
    DocumentSnapshot<Map> snapshot = await transaction.get(documentReference);

    if (!snapshot.exists) {
      throw Exception("User does not exist!");
    }
    int coins = snapshot.data()!['coins'] + coinsToAdd;
    transaction.update(documentReference, {'coins': coins});

    return coins;
  }).then((value) {
    coinHistoryRef.set({
      'title': 'Won RapidFire',
      'uid': uid,
      'date': dateInMS,
      'isAdded': true,
      'coin': coinsToAdd
    });
  });
}

Map calculateScore(List questionsMapList, List selectedDetails) {
  Map result = {
    'correct': 0,
    'wrong': 0,
    'unAnswered': 0,
  };
  int i = 0;
  for (Map question in questionsMapList) {
    print(selectedDetails[i]);
    if (selectedDetails[i]['selected'] == -1) {
      result['unAnswered'] += 1;
    } else if (selectedDetails[i]['selected'] == question['answerIndex']) {
      result['correct'] += 1;
    } else {
      result['wrong'] += 1;
    }
    i += 1;
  }
  return result;
}

void addFakeResult() async {
  await FirebaseFirestore.instance
      .collection("rapidFire/result/n9SsMQJvKBntDsVLxbMD")
      .add({
    'score': 10,
    'time': 1,
    'user': {
      'name': 'jacob',
      'image': null,
      'uid': '344345ed',
    },
    'order': (10 * 1000) + (1000 - 1)
  });
}
