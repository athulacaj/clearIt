import 'package:clearit/utility/functions/coinDectectionFunction.dart';
import 'package:clearit/utility/functions/coinUpdateInDatabaseFunction.dart';
import 'package:clearit/utility/functions/showToastFunction.dart';
import 'package:clearit/utility/loadingWidget/ModalProgressHudWidget.dart';
import 'package:clearit/utility/provider/account.dart';
import 'package:clearit/utility/provider/adState.dart';
import 'package:clearit/utility/provider/savedDataProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:clearit/screens/rapidfire/questionsPage/questionsIndex.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'RapiFireClass.dart';
import 'RapidFireDatabaseManager.dart';
import 'rankPage/rapidFireRanking.dart';

class RapidFireScreen extends StatefulWidget {
  final Map testDetails;
  final String id;
  RapidFireScreen({required this.testDetails, required this.id});
  @override
  _RapidFireScreenState createState() => _RapidFireScreenState();
}

late String dateString;
bool _showSpinner = false;
BannerAd? banner;

class _RapidFireScreenState extends State<RapidFireScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(
        widget.testDetails['date'],
        isUtc: true);
    var format = new DateFormat("dd-MM-yyyy");
    dateString = format.format(dt);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      Provider.of<SavedDataProvider>(context).getSavedData();
      // 320x100	Large Banner	largeBanner

      final adstate = Provider.of<AdState>(context, listen: true);
      adstate.loadInterstitialAd(adstate.videoInterstitialAdUnnit);
      adstate.initialization.then((status) {
        setState(() {
          // 320x250
          banner = BannerAd(
              size: AdSize.largeBanner,
              adUnitId: adstate.getBannerAdUnnit,
              listener: adstate.listener,
              request: AdRequest())
            ..load();
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    String uid =
        Provider.of<MyAccount>(context, listen: false).userDetails!['uid'];
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        appBar: commonAppBar(title: 'Rapid Fire', context: context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height - 120,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Material(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(
                              width: size.width - 50,
                              child: Row(
                                children: [
                                  Text("Date: $dateString"),
                                  Spacer(),
                                  Icon(Icons.timer),
                                  Text(
                                      "${timeConvertor(widget.testDetails['time'])}"),
                                ],
                              ),
                            ),
                          ),
                          elevation: 3,
                        ),
                      ],
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${widget.testDetails["name"]}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 18),
                          ),
                          SizedBox(height: 20),
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26)),
                            child: Text(
                              widget.id != widget.testDetails['date'].toString()
                                  ? "Note: You can take this quiz only once in a day"
                                  : "You already taken this quiz please wait for new questions.",
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 30),
                          FlatButton(
                            minWidth: size.width - 100,
                            color: widget.id !=
                                    widget.testDetails['date'].toString()
                                ? Color(0xff7078ff)
                                : Colors.grey,
                            onPressed: () {
                              if (widget.id !=
                                  widget.testDetails['date'].toString()) {
                                coinDetectFunction(context, () async {
                                  _showSpinner = true;
                                  setState(() {});
                                  await coinUpdateFunction(uid, () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QuestionsPage(
                                                  testDetails:
                                                      widget.testDetails,
                                                )));
                                  });
                                });
                              } else {
                                showToast("Please wait for new questions");
                              }
                              _showSpinner = false;
                            },
                            child: Text("   Start Quiz  ",
                                style: TextStyle(color: Colors.white)),
                          ),
                          SizedBox(height: 50),
                          widget.id != ''
                              ? Container(
                                  child: StreamBuilder<DocumentSnapshot<Map>>(
                                    stream: FirebaseFirestore.instance
                                        .collection(
                                            "rapidFire/result/${widget.id}")
                                        .doc(uid)
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData) {
                                        return CircularProgressIndicator();
                                      }
                                      if (!snapshot.data!.exists) {
                                        return Container();
                                      } else {
                                        return FlatButton(
                                            minWidth: size.width - 100,
                                            color: Colors.green,
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          RapidFireRankingScreen(
                                                            id: widget.id,
                                                          )));
                                            },
                                            child: Text(
                                              widget.id !=
                                                      widget.testDetails['date']
                                                          .toString()
                                                  ? "Previous ranking"
                                                  : "Current Ranking",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ));
                                      }
                                    },
                                  ),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      height: 100,
                      child:
                          banner == null ? Container() : AdWidget(ad: banner!),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    _showSpinner = false;
  }
}

String timeConvertor(var time) {
  if (time >= 3600) {
    double toReturn = time / 3600;
    int q = time ~/ 3600;
    int r = (time % 3600).toInt();
    if (r == 0) {
      return '$q h';
    } else {
      int qOfMin = r ~/ 60;
      return '$q h $qOfMin m';
    }
//    toReturn = num.parse(toReturn.toStringAsFixed(2));
//    return '$toReturn h';
  } else if (time >= 60) {
//    double toReturn = time / 60;
    int q = time ~/ 60;
    int r = (time % 60).toInt();
    if (r == 0) {
      return '$q m';
    } else {
      return '$q m $r s';
    }
  } else {
    return '${time.toInt()} s';
  }
}
