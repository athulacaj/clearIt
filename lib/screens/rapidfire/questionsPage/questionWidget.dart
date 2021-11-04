import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'optionsWidget.dart';
import '../qusetionAnswerProvider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'package:clearit/utility/calculateHeightOfWidget.dart';

int _selectedIndex = -1;

class QuestionAndOption extends StatefulWidget {
  final Map questionAnswer;
  final int qNo;
  final int totalQNo;
  final int totalTime;
  QuestionAndOption(
      {required this.questionAnswer,
      required this.qNo,
      required this.totalQNo,
      required this.totalTime});

  @override
  _QuestionAndOptionState createState() => _QuestionAndOptionState();
}

class _QuestionAndOptionState extends State<QuestionAndOption> {
  double box1 = 0;
  double box2 = 0;
  double calculatedH = 0;
  void totalHeight() {
    calculatedH = box1 + box2;
    print('calculated h :$calculatedH');
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print('max h : ${MediaQuery.of(context).size.height}');
    // ScrollController _scrollController = ScrollController();
    ThemeData theme = Theme.of(context);
    String question = widget.questionAnswer['question'];
    List options = widget.questionAnswer['options'];
    int answerIndex = widget.questionAnswer['answerIndex'];

    return TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: 1),
        duration: Duration(milliseconds: 900),
        builder: (BuildContext context, double opacity, Widget? child) {
          return Opacity(
            opacity: opacity,
            child: Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: 1,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: [
                            SizedBox(height: 10),
                            Container(
                              color: Colors.white.withOpacity(0.1),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                    minWidth: size.width - 20,
                                    minHeight: size.height / 4.5),
                                child: Padding(
                                  padding: EdgeInsets.only(top: 1),
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 22,
                                        right: 22,
                                        top: 15,
                                        bottom: 15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          '$question',
                                          style: TextStyle(
                                              fontSize: 17,
                                              height: 1,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            buildOptions(options, widget.qNo, context)
                          ],
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return SizedBox(
                          height: size.height / 5 - box1 > 0
                              ? size.height / 5 - box1
                              : 0,
                          // height: box1 > size.height / 3 ? 50 : 100,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void deactivate() {
    super.deactivate();
  }
}

Widget buildOptions(List options, int qNo, BuildContext context) {
  return Padding(
    padding: EdgeInsets.only(left: 23, right: 19, bottom: 20),
    child: Options(
      selectedIndex: _selectedIndex,
      options: options,
      qNo: qNo,
    ),
  );
}

Widget returnText(var time, BuildContext context) {
  // Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false)
  //     .addTimeOfEachQuestion();

  return Text(
    timeConvertor(time),
    style: TextStyle(fontSize: 17, color: Colors.white),
  );
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
