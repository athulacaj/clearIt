import 'package:clearit/screens/mindMath/MindMathBrain.dart';
import 'package:clearit/utility/loadingWidget/ModalProgressHudWidget.dart';
import 'package:clearit/utility/provider/adState.dart';
import 'package:clearit/utility/provider/savedDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clearit/screens/homeScreen/homeScreen.dart';
import 'package:clearit/utility/widgets/ImageView.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../mindMath.dart';

class AnswerWrong extends StatefulWidget {
  final String reason;
  final String wrongAnswer;
  final int wrongQIndex;
  final List questions;
  AnswerWrong(
      {required this.reason,
      required this.wrongQIndex,
      required this.questions,
      required this.wrongAnswer});

  @override
  _AnswerWrongState createState() => _AnswerWrongState();
}

bool _showSpinner = false;
BannerAd? mediumBanner;

class _AnswerWrongState extends State<AnswerWrong> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _showSpinner = false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    try {
      Provider.of<SavedDataProvider>(context).getSavedData();
      final AdSize adSize = AdSize(width: 320, height: 250);

      final adstate = Provider.of<AdState>(context, listen: true);
      adstate.initialization.then((status) {
        setState(() {
          // 320x250
          mediumBanner = BannerAd(
              size: AdSize.mediumRectangle,
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
    print("wrongQIndex ${widget.wrongQIndex}");
    Size size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
        appBar: commonAppBar(title: 'Mind Math', context: context),
        body: SafeArea(
          child: SizedBox(
            width: size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 14),
                widget.reason == 'Wrong'
                    ? Text('Your entered answer ${widget.wrongAnswer} is wrong',
                        style: reasonTextStyle)
                    : Text('Time Out', style: reasonTextStyle),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(18),
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black26)),
                  child: Column(
                    children: [
                      SizedBox(height: 55),
                      Text(
                        widget.questions[widget.wrongQIndex]['question'] +
                            " = " +
                            "${widget.questions[widget.wrongQIndex]['answer']}",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      SizedBox(height: 55),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FlatButton(
                        color: Color(0xff6369f2),
                        onPressed: () async {
                          _showSpinner = true;
                          setState(() {});
                          List questions = await MindMathBrain().getData();

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MindMathScreen(questions)));
                        },
                        child: Text(
                          'Try Again',
                          style: TextStyle(color: Colors.white),
                        )),
                    FlatButton(
                        color: Color(0xff6369f2),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Home',
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
                SizedBox(height: 30),
                Container(
                  color: Colors.white,
                  height: 250,
                  child: mediumBanner == null
                      ? Container()
                      : AdWidget(ad: mediumBanner!),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

TextStyle reasonTextStyle = TextStyle(fontSize: 16);
