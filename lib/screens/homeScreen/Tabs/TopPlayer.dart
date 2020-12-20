import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:studywithfun/utility/coin.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/utility/provider/account.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class TopPlayer extends StatelessWidget {
  final String docId;
  TopPlayer({this.docId});
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String uid =
        Provider.of<MyAccount>(context, listen: false).userDetails['uid'];

    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users/userEvents/coins')
            .orderBy('coins', descending: true)
            // .where('score', isGreaterThan: 0)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data.docs.isEmpty) {
            return Text('empty');
          }
          // List result = List<Map>.from(snapshot.data.docs);
          List<DocumentSnapshot> result = snapshot.data.docs;
          print(result.length - 1);
          int high = result.length - 1;
          int low = 0;
          // List<DocumentSnapshot> sortedList = quickSort(result, low, high);
          return Column(
            children: [
              Container(
                  color: Colors.white,
                  height: 50,
                  child: FractionallySizedBox(
                    widthFactor: 0.95,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 12),
                      child: Row(
                        children: [
                          Text('Rank'),
                          SizedBox(width: 15),
                          Text('Name'),
                          Spacer(),
                          Text('Coins'),
                          SizedBox(width: 5),
                        ],
                      ),
                    ),
                  )),
              Expanded(
                child: AnimationLimiter(
                  child: ListView.builder(
                    itemCount: result.length,
                    itemBuilder: (BuildContext context, int index) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: Container(
                              margin: EdgeInsets.all(5),
                              child: FractionallySizedBox(
                                widthFactor: 0.95,
                                child: Material(
                                  color: result[index].data()['uid'] == uid
                                      ? Colors.yellow
                                      : Colors.white,
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text('${index + 1}'),
                                        SizedBox(width: 35),
                                        // SizedBox(
                                        //     width: size.width / 7,
                                        //     child: CircleAvatar(
                                        //         backgroundColor:
                                        //             Color(0xff6369f2),
                                        //         child: Icon(
                                        //           Icons.person,
                                        //           color: Colors.white,
                                        //         ))),
                                        AutoSizeText(
                                          '${result[index].data()['name']}'
                                              .capitalizeFirstofEach(),
                                          maxLines: 1,
                                        ),
                                        Spacer(),
                                        SizedBox(width: 5),
                                        Text(
                                            '${result[index].data()['coins']}'),
                                        coinBuilder(15),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        });
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String capitalizeFirstofEach() {
    return this.split(" ").map((str) => str.capitalize()).join(" ");
  }
}
