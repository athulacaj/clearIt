import 'dart:ffi';

import 'package:clearit/utility/coin.dart';
import 'package:clearit/utility/functions/showToastFunction.dart';
import 'package:clearit/utility/loadingWidget/loading.dart';
import 'package:clearit/utility/provider/account.dart';
import 'package:clearit/utility/provider/adState.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:clearit/screens/mindMath/mindMath.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class ReviewPage extends StatefulWidget {
  final List questionsList;
  final List answeredList;
  ReviewPage({required this.questionsList, required this.answeredList});
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

bool coinClaimed = false;

class _ReviewPageState extends State<ReviewPage> {
  @override
  void initState() {
    super.initState();
    coinClaimed = false;
    cachedActor(
      AssetFlare(bundle: rootBundle, name: 'images/colorful.flr'),
    );
  }

  bool _showSpinner = false;
  late Size size;
  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String date = now.toString().substring(0, 10);
    Size size = MediaQuery.of(context).size;
    print(date);
    size = MediaQuery.of(context).size;
    print(widget.questionsList);
    String uid =
        Provider.of<MyAccount>(context, listen: false).userDetails!['uid'];
    return CoinLoading(
      showSpinner: _showSpinner,
      child: Scaffold(
        appBar: commonAppBar(title: 'Review Page', context: context),
        body: SafeArea(
          child: Stack(
            children: [
              SizedBox(
                height: size.height - 20,
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("users/mindmath/$date")
                      .doc(uid)
                      .snapshots(),
                  builder: (BuildContext context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    int coins = 0;
                    if (snapshot.data!.exists) {
                      coins = snapshot.data!['coins'];
                    }
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: SizedBox(
                        width: size.width - 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              "Congratulations!! You Won!!",
                              style:
                                  TextStyle(fontSize: 18, color: Colors.green),
                            ),
                            SizedBox(height: 5),
                            Text(
                              "Claim a coin from below",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),
                            SizedBox(height: 20),
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              width: size.width - 70,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black26)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 10),
                                  Material(
                                      color: Colors.white,
                                      elevation: 2,
                                      child: Container(
                                          alignment: Alignment.center,
                                          height: 50,
                                          width: double.infinity,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Total Coins : ${Provider.of<MyAccount>(context, listen: true).coins}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              coinBuilder(20),
                                            ],
                                          ))),
                                  SizedBox(height: 50),
                                  Text(
                                      'Coins left to claim today : ${3 - coins}',
                                      textAlign: TextAlign.start),
                                  SizedBox(height: 20),
                                  SizedBox(
                                    width: size.width / 1.5,
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          for (int i = 0; i < 3; i++)
                                            coinBuilder(40,
                                                color: coins <= i
                                                    ? Colors.grey
                                                    : null),
                                        ]),
                                  ),
                                  SizedBox(height: 10),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            FlatButton(
                                minWidth: size.width - 70,
                                color: coins < 3 && !coinClaimed
                                    ? Colors.blueAccent
                                    : Colors.grey,
                                onPressed: () async {
                                  print(coinClaimed);
                                  if (coinClaimed) {
                                    showToast("Already claimed");
                                  } else if (coins < 3) {
                                    _showSpinner = true;
                                    setState(() {});
                                    RewardAds.showRewardedAd(() async {
                                      {
                                        coins = coins + 1;
                                        try {
                                          await updateCoins(1, uid);
                                          await FirebaseFirestore.instance
                                              .collection(
                                                  "users/mindmath/$date")
                                              .doc(uid)
                                              .set({'coins': coins});
                                          int dateInMS = DateTime.now()
                                              .millisecondsSinceEpoch;
                                          DocumentReference secondRef =
                                              FirebaseFirestore.instance
                                                  .collection(
                                                      'users/byUid/$uid/category/coinsHistory')
                                                  .doc('$dateInMS');
                                          await secondRef.set({
                                            'title': 'MindMath bonus',
                                            'uid': uid,
                                            'date': dateInMS,
                                            'isAdded': false,
                                            'coin': 1,
                                          });
                                          coinClaimed = true;
                                        } catch (e) {}
                                      }
                                    });
                                    _showSpinner = false;
                                    setState(() {});
                                    // coins = coins + 1;
                                    // _showSpinner = true;
                                    // setState(() {});
                                    // try {
                                    //   await updateCoins(1, uid);
                                    //   await FirebaseFirestore.instance
                                    //       .collection("users/mindmath/$date")
                                    //       .doc(uid)
                                    //       .set({'coins': coins});
                                    //   int dateInMS =
                                    //       DateTime.now().millisecondsSinceEpoch;
                                    //   DocumentReference secondRef = FirebaseFirestore
                                    //       .instance
                                    //       .collection(
                                    //           'users/byUid/$uid/category/coinsHistory')
                                    //       .doc('$dateInMS');
                                    //   await secondRef.set({
                                    //     'title': 'MindMath bonus',
                                    //     'uid': uid,
                                    //     'date': dateInMS,
                                    //     'isAdded': false,
                                    //     'coin': 1,
                                    //   });
                                    //   coinClaimed = true;
                                    // } catch (e) {}
                                  } else {
                                    showToast(
                                        "you have claimed all coins, come tomorrow!");
                                  }
                                  _showSpinner = false;

                                  setState(() {});
                                },
                                child: Text("Claim Coin",
                                    style: TextStyle(color: Colors.white))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              coinClaimed
                  ? Container(
                      height: size.height - 20,
                      width: size.width,
                      child: FlareActor("images/colorful.flr",
                          alignment: Alignment.center,
                          fit: BoxFit.contain,
                          animation: "animate"),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> updateCoins(int bonus, String uid) async {
  DocumentReference<Map<String, dynamic>> documentReference =
      FirebaseFirestore.instance.collection('uid').doc('$uid');
  try {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      // Get the document
      DocumentSnapshot<Map> snapshot = await transaction.get(documentReference);

      if (!snapshot.exists) {
        throw Exception("User does not exist!");
      }
      int coins = snapshot.data()!['coins'] + bonus;
      transaction.update(documentReference, {'coins': coins});

      return coins;
    });
    return true;
  } catch (e) {}
  return false;
}
