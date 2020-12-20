import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/utility/provider/account.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';
import 'package:studywithfun/utility/provider/coinStramProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyQuestions extends StatefulWidget {
  @override
  _MyQuestionsState createState() => _MyQuestionsState();
}

class _MyQuestionsState extends State<MyQuestions> {
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
            appBar: commonAppBar(
                title: 'Recently Asked Questions', context: context),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection(
                                'users/byUid/${user['uid']}/category/questionsHistory')
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          List<DocumentSnapshot> historyList =
                              snapshot.data.docs;
                          print(historyList);
                          return ListView.builder(
                              itemCount: historyList.length,
                              itemBuilder: (context, int i) {
                                Map details = historyList[i].data();
                                return InkWell(
                                  onTap: () {
                                    showMaterialModalBottomSheet(
                                      context: context,
                                      builder: (context, scrollController) =>
                                          Container(
                                        height: size.height - 80,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Text(
                                                '${details['queryDetails']['query']}',
                                                style: TextStyle(fontSize: 16),
                                              ),
                                              SizedBox(height: 12),
                                              details['queryDetails']
                                                          ['imageUrl'] !=
                                                      null
                                                  ? SizedBox(
                                                      width: size.width - 70,
                                                      height: 200,
                                                      child: FullScreenWidget(
                                                        child: Center(
                                                          child: Hero(
                                                            tag: details[
                                                                    'queryDetails']
                                                                ['query'],
                                                            child:
                                                                Image.network(
                                                              details['queryDetails']
                                                                  ['imageUrl'],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Material(
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              details['queryDetails']
                                                          ['imageUrl'] !=
                                                      null
                                                  ? SizedBox(
                                                      width: 70,
                                                      height: 70,
                                                      child: FullScreenWidget(
                                                        child: Center(
                                                          child: Hero(
                                                            tag: details[
                                                                    'queryDetails']
                                                                ['query'],
                                                            child:
                                                                Image.network(
                                                              details['queryDetails']
                                                                  ['imageUrl'],
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  : Container(),
                                              SizedBox(width: 10),
                                              SizedBox(
                                                child: Text(
                                                    '${details['queryDetails']['query']}'),
                                                width: size.width - 16 - 106,
                                              ),
                                              SizedBox(width: 10),
                                              Text(''),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
