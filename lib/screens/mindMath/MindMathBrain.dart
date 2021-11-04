import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class MindMathBrain {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Future<List> getData() async {
    DocumentSnapshot<Map<String, dynamic>> doc =
        await _firestore.collection("mindMath").doc("questions").get();
    if (!doc.exists) {
      return [];
    }

    List dataList = doc.data()!['questions'];
    if (dataList.length < 10) {
      return [];
    }
    return shuffleList(dataList);
  }
}

List shuffleList(List questions) {
  List shuffledList = shuffle(questions);
  return shuffledList.sublist(0, 10);
}

List shuffle(List items) {
  var random = new Random();

  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}
