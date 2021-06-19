import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studywithfun/screens/homeScreen/homeScreen.dart';
import 'package:studywithfun/utility/widgets/ImageView.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';
import 'package:url_launcher/url_launcher.dart';

import '../mindMath.dart';

class AnswerWrong extends StatefulWidget {
  final String reason;
  final String wrongAnswer;
  final int wrongQIndex;
  List<Map> questions;
  AnswerWrong(
      {this.reason, this.wrongQIndex, this.questions, this.wrongAnswer});

  @override
  _AnswerWrongState createState() => _AnswerWrongState();
}

class _AnswerWrongState extends State<AnswerWrong> {
  @override
  Widget build(BuildContext context) {
    print("wrongQIndex ${widget.wrongQIndex}");
    Size size = MediaQuery.of(context).size;
    return Scaffold(
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
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MindMathScreen()));
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
            ],
          ),
        ),
      ),
    );
  }
}

TextStyle reasonTextStyle = TextStyle(fontSize: 16);
