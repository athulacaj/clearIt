import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:studywithfun/screens/mindMath/mindMath.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';

class ReviewPage extends StatefulWidget {
  final List<Map> questionsList;
  final List answeredList;
  ReviewPage({this.questionsList, this.answeredList});
  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  AnswerClass answerClass;
  @override
  void initState() {
    answerClass = AnswerClass(widget.questionsList, widget.answeredList);
    super.initState();
  }

  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    print(widget.questionsList);
    return Scaffold(
      appBar: commonAppBar(title: 'Review Page', context: context),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ResultBox(
                title: 'Correct : ${answerClass.checkAnswer()['correct']}',
                duration: 800,
                size: size,
                begin: -100.0,
                end: size.width / 4,
                icon: Icons.check,
                iconColor: Colors.green,
              ),
              ResultBox(
                title: 'Wrong : ${answerClass.checkAnswer()['wrong']}',
                duration: 900,
                size: size,
                begin: size.width,
                end: size.width / 4,
                icon: Icons.close,
                iconColor: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResultBox extends StatelessWidget {
  final String title;
  final Size size;
  final int duration;
  final double begin;
  final double end;
  final IconData icon;
  final Color iconColor;
  ResultBox(
      {this.size,
      this.title,
      this.duration,
      this.begin,
      this.end,
      this.icon,
      this.iconColor});
  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      duration: Duration(milliseconds: duration),
      builder: (BuildContext context, value, Widget child) {
        return Container(
          alignment: Alignment.topLeft,
          height: 70,
          child: Stack(
            children: [
              Positioned(
                child: Material(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: Container(
                    width: size.width / 2,
                    alignment: Alignment.center,
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                        ),
                        SizedBox(width: 10),
                        Icon(
                          icon,
                          size: 30,
                          color: iconColor,
                        )
                      ],
                    ),
                  ),
                  elevation: 6,
                ),
                left: value,
                top: 0,
              ),
            ],
          ),
        );
      },
      tween: Tween<double>(begin: begin, end: end),
    );
  }
}

class AnswerClass {
  List questionList;
  List answeredList;
  AnswerClass(this.questionList, this.answeredList);
  Map checkAnswer() {
    int i = 0;
    int correct = 0;
    int wrong = 0;

    for (Map questionMap in questionList) {
      if (questionMap['answer'] == answeredList[i]) {
        correct++;
      } else {
        wrong++;
      }
      i++;
    }
    return {
      'correct': correct,
      'wrong': wrong,
    };
  }
}
