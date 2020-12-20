import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/utility/provider/account.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';
import 'package:studywithfun/utility/provider/coinStramProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CoinDetails extends StatefulWidget {
  @override
  _CoinDetailsState createState() => _CoinDetailsState();
}

class _CoinDetailsState extends State<CoinDetails> {
  bool loading = false;
  Map user;
  int coins = 0;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    user = Provider.of<MyAccount>(context, listen: false).userDetails;
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
                              child: Text(
                                'Total Coins : $coins',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ))),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Coins History',
                      style: TextStyle(fontSize: 17),
                    ),
                    SizedBox(height: 15),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection(
                                'users/byUid/${user['uid']}/category/coinsHistory')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          List<DocumentSnapshot> historyList =
                              snapshot.data.docs;
                          print(historyList);
                          return ListView.builder(
                              itemCount: historyList.length,
                              itemBuilder: (context, int i) {
                                Map details = historyList[i].data();
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          child: Text('${details['title']}'),
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
