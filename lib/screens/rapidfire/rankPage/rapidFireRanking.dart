import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clearit/utility/provider/account.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class RapidFireRankingScreen extends StatefulWidget {
  final String id;
  RapidFireRankingScreen({required this.id});

  @override
  _RapidFireRankingScreenState createState() => _RapidFireRankingScreenState();
}

class _RapidFireRankingScreenState extends State<RapidFireRankingScreen> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    String uid =
        Provider.of<MyAccount>(context, listen: false).userDetails!['uid'];
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: commonAppBar(title: "Ranking", context: context),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("rapidFire/result/${widget.id}")
              .orderBy('order', descending: true)
              .snapshots(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return Text('');
            }
            // List result = List<Map>.from(snapshot.data.docs);
            List<QueryDocumentSnapshot<Map<String, dynamic>>> result =
                snapshot.data!.docs;
            print(result.length - 1);
            int high = result.length - 1;
            int low = 0;
            return Stack(
              children: [
                // Positioned(
                //     height: size.height,
                //     top: size.height * .08,
                //     width: size.width,
                //     child: Image.asset("images/arts/topPlayer.png")),
                SafeArea(
                  child: Column(
                    children: [
                      SizedBox(height: 15),
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
                                  Text('Score   & '),
                                  SizedBox(width: 5),
                                  Text('Time'),
                                  // SizedBox(width: 5),
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
                                                data['user']['photo'] != null
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    30)),
                                                        child: Container(
                                                          height: 50,
                                                          width: 50,
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                data['user']
                                                                    ['photo'],
                                                            fit: BoxFit.cover,
                                                            placeholder: (context, url) => Icon(
                                                                CupertinoIcons
                                                                    .profile_circled,
                                                                size: 50,
                                                                color: theme
                                                                    .accentColor
                                                                    .withOpacity(
                                                                        0.6)),
                                                            errorWidget: (context,
                                                                    url,
                                                                    error) =>
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
                                                Expanded(
                                                  child: AutoSizeText(
                                                    '${data['user']['name']}'
                                                        .capitalizeFirstofEach,
                                                    maxLines: 1,
                                                  ),
                                                ),
                                                Spacer(),
                                                SizedBox(width: 5),
                                                CircleAvatar(
                                                    backgroundColor:
                                                        Colors.grey.shade200,
                                                    radius: 18,
                                                    child: Text(
                                                        '${data['score']}')),
                                                SizedBox(width: 15),
                                                SizedBox(
                                                    width: 35,
                                                    child: AutoSizeText(
                                                      '${data['time']}s',
                                                      maxLines: 1,
                                                    )),
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
                ),
              ],
            );
          }),
    );
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
