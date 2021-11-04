import 'package:cached_network_image/cached_network_image.dart';
import 'package:clearit/utility/coin.dart';
import 'package:clearit/utility/loadingWidget/ModalProgressHudWidget.dart';
import 'package:clearit/utility/provider/account.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class CoinDetails extends StatefulWidget {
  @override
  _CoinDetailsState createState() => _CoinDetailsState();
}

class _CoinDetailsState extends State<CoinDetails> {
  bool loading = false;
  late Map user;
  int coins = 0;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    user = Provider.of<MyAccount>(context, listen: false).userDetails!;
    loading = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    coins = Provider.of<MyAccount>(context, listen: true).coins;
    Size size = MediaQuery.of(context).size;
    return Consumer<MyAccount>(
      builder: (context, myAccount, child) {
        return ModalProgressHUD(
          inAsyncCall: loading,
          child: Scaffold(
            appBar: commonAppBar(title: 'Coin Details', context: context),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                          color: Colors.white,
                          elevation: 2,
                          child: Container(
                              alignment: Alignment.center,
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Total Coins : $coins',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  coinBuilder(20),
                                ],
                              ))),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Coins History',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 5),
                    Divider(),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        stream: _firestore
                            .collection(
                                'users/byUid/${user['uid']}/category/coinsHistory')
                            .orderBy('date', descending: true)
                            .snapshots(),
                        builder: (BuildContext context, snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<QueryDocumentSnapshot<Map<String, dynamic>>>
                              historyList = snapshot.data!.docs;
                          print(historyList);

                          return ListView.builder(
                              itemCount: historyList.length,
                              itemBuilder: (context, int i) {
                                Map details = historyList[i].data();
                                DateTime dt =
                                    DateTime.fromMillisecondsSinceEpoch(
                                        details['date'],
                                        isUtc: true);
                                var format = new DateFormat("dd-MM-yyyy");
                                var dateString = format.format(dt);

                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      child: Text(dateString,
                                          style:
                                              TextStyle(color: Colors.black54)),
                                      width: size.width - 30 - 60,
                                    ),
                                    SizedBox(height: 3),
                                    Row(
                                      children: [
                                        SizedBox(
                                          child: Text('${details['title']}',
                                              style: TextStyle(fontSize: 16)),
                                          width: size.width - 30 - 60,
                                        ),
                                        SizedBox(width: 10),
                                        details['coin'] > 0
                                            ? Icon(
                                                Icons.add_circle_rounded,
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                Icons.remove_circle_rounded,
                                                color: Colors.redAccent,
                                              ),
                                        Text('${details['coin'].abs()}'),
                                      ],
                                    ),
                                    Divider(),
                                  ],
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

BoxDecoration contaionerBlackOutlineButtonDecoration = BoxDecoration(
  border: Border.all(color: Colors.black),
  borderRadius: BorderRadius.all(Radius.circular(4)),
);
