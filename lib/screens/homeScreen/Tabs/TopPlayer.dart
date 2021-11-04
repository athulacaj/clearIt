import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:clearit/utility/coin.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:clearit/utility/provider/account.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class TopPlayer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String uid =
        Provider.of<MyAccount>(context, listen: false).userDetails!['uid'];
    ThemeData theme = Theme.of(context);
    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: _firestore
            .collection('uid')
            .orderBy('coins', descending: true)
            // .where('score', isGreaterThan: 0)
            .snapshots(),
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty) {
            return Text('empty');
          }
          // List result = List<Map>.from(snapshot.data.docs);
          List<QueryDocumentSnapshot<Map<String, dynamic>>> result =
              snapshot.data!.docs;
          print(result.length - 1);
          int high = result.length - 1;
          int low = 0;
          // List<DocumentSnapshot> sortedList = quickSort(result, low, high);
          return Stack(
            children: [
              Positioned(
                  height: size.height,
                  top: size.height * .08,
                  width: size.width,
                  child: Image.asset("images/arts/topPlayer.png")),
              Column(
                children: [
                  Container(
                      color: Colors.white,
                      height: 40,
                      child: FractionallySizedBox(
                        widthFactor: 0.95,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 12),
                          child: Row(
                            children: [
                              Text('Rank'),
                              SizedBox(width: 50),
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
                        padding: EdgeInsets.only(bottom: 60),
                        itemBuilder: (BuildContext context, int index) {
                          Map<String, dynamic> data = result[index].data();
                          print(data['photo']);
                          return AnimationConfiguration.staggeredList(
                            position: index,
                            duration: const Duration(milliseconds: 375),
                            child: SlideAnimation(
                              verticalOffset: 50.0,
                              child: FadeInAnimation(
                                child: Container(
                                  margin: EdgeInsets.all(4),
                                  child: FractionallySizedBox(
                                    widthFactor: 0.95,
                                    child: Material(
                                      color: data['uid'] == uid
                                          ? Colors.yellow
                                          : Colors.white.withOpacity(0.9),
                                      elevation: 2,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text('${index + 1}'),
                                            SizedBox(width: 20),
                                            data['photo'] != null
                                                ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(
                                                                30)),
                                                    child: Container(
                                                      height: 50,
                                                      width: 50,
                                                      child: CachedNetworkImage(
                                                        imageUrl: data['photo'],
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            Icon(
                                                                CupertinoIcons
                                                                    .profile_circled,
                                                                size: 50,
                                                                color: theme
                                                                    .accentColor
                                                                    .withOpacity(
                                                                        0.6)),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(
                                                                CupertinoIcons
                                                                    .profile_circled,
                                                                size: 50,
                                                                color: theme
                                                                    .accentColor
                                                                    .withOpacity(
                                                                        0.6)),
                                                      ),
                                                    ),
                                                  )
                                                : Icon(
                                                    CupertinoIcons
                                                        .profile_circled,
                                                    size: 50,
                                                    color: theme.accentColor
                                                        .withOpacity(0.6)),
                                            SizedBox(width: 10),
                                            AutoSizeText(
                                              '${data['name']}'
                                                  .capitalizeFirstofEach,
                                              maxLines: 1,
                                            ),
                                            Spacer(),
                                            SizedBox(width: 5),
                                            Text('${data['coins']}'),
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
              ),
            ],
          );
        });
  }
}

extension CapExtension on String {
  String get inCaps =>
      this.length > 0 ? '${this[0].toUpperCase()}${this.substring(1)}' : '';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstofEach => this
      .toLowerCase()
      .replaceAll(RegExp(' +'), ' ')
      .split(" ")
      .map((str) => str.inCaps)
      .join(" ");
}

// extension StringExtension on String {
//   String capitalize() {
//     return "${this[0].toUpperCase()}${this.substring(1)}";
//   }
//
//   String capitalizeFirstofEach() {
//     return this.split(" ").map((str) => str.capitalize()).join(" ");
//   }
// }
