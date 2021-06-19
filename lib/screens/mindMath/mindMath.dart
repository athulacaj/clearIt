import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';

import 'keyBoardWidget.dart';
import 'result/answerWrong.dart';
import 'reviewPage.dart';

class MindMathScreen extends StatefulWidget {
  @override
  _MindMathScreenState createState() => _MindMathScreenState();
}

class _MindMathScreenState extends State<MindMathScreen> {
  List answeredList = [];

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
    // onChange: (value) => print('onChange $value'),
    // onChangeRawSecond: (value) => print('onChangeRawSecond $value'),
    // onChangeRawMinute: (value) => print('onChangeRawMinute $value'),
  );
  PageController pageController;
  TextEditingController searchController;
  int timeLimit = 1000;
  int prvsIndex = -1;
  @override
  void initState() {
    answeredList = [];
    pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
    searchController = TextEditingController();
    super.initState();
  }

  bool _disposed = false;
  @override
  void dispose() async {
    super.dispose();
    print('called dispose');
    pageController.dispose();
    await _stopWatchTimer.dispose();
    _disposed = true; // Need to call dispose function.
  }

  void ifWrong(String reason, int wrongQIndex, String wrongAnser) async {
    _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
    _disposed = true;
    await _stopWatchTimer.dispose();
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => AnswerWrong(
                  reason: reason,
                  wrongQIndex: wrongQIndex,
                  questions: questions,
                  wrongAnswer: wrongAnser,
                )));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commonAppBar(title: 'Mind Math', context: context),
      body: SafeArea(
        child: _disposed
            ? Container()
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Container(
                          // color: Colors.blue.shade400,
                          color: Color(0xff6EA1D6),
                          child: PageView.builder(
                            controller: pageController,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: questions.length,
                            itemBuilder: (context, index) {
                              if (_disposed == false && prvsIndex != index) {
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.reset);
                                _stopWatchTimer.onExecute
                                    .add(StopWatchExecute.start);
                              }
                              prvsIndex = index;
                              return ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 1000),
                                child: ListView(
                                  children: [
                                    TweenAnimationBuilder(
                                      tween: Tween<double>(begin: 0, end: 1),
                                      duration: Duration(milliseconds: 600),
                                      builder: (BuildContext context,
                                          double opacity, Widget child) {
                                        return Opacity(
                                          opacity: opacity,
                                          child: Container(
                                            padding: EdgeInsets.all(16),
                                            alignment: Alignment.centerLeft,
                                            // color: Color(0xff6369f2),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      'Q${index + 1}',
                                                      style: TextStyle(
                                                          fontSize: 18,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          color: Colors.white),
                                                    ),
                                                    Spacer(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 0),
                                                      child: _disposed
                                                          ? Container()
                                                          : StreamBuilder<int>(
                                                              stream:
                                                                  _stopWatchTimer
                                                                      .secondTime,
                                                              initialData: 0,
                                                              builder: (context,
                                                                  snap) {
                                                                final value =
                                                                    snap.data;
                                                                if ((timeLimit -
                                                                        value) ==
                                                                    0) {
                                                                  ifWrong(
                                                                      "Time Out",
                                                                      index,
                                                                      "");
                                                                }
                                                                return Row(
                                                                  children: [
                                                                    Icon(
                                                                        Icons
                                                                            .timer,
                                                                        size:
                                                                            30,
                                                                        color: Colors
                                                                            .white),
                                                                    Text(
                                                                      '${timeLimit - value}' +
                                                                          ' s',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              17,
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w500),
                                                                    ),
                                                                  ],
                                                                );
                                                              },
                                                            ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Container(
                                                  color: Colors.black
                                                      .withOpacity(0.1),
                                                  padding: EdgeInsets.all(8),
                                                  alignment: Alignment.center,
                                                  width: double.infinity,
                                                  child: Text(
                                                    questions[index]
                                                        ['question'],
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color: Colors.white),
                                                  ),
                                                  constraints: BoxConstraints(
                                                      minHeight:
                                                          size.height / 4.1),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      KeyBoardWidget(
                        onSubmit: (String result) {
                          print(result);
                          nextFunction(questions, result);
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void nextFunction(List<Map> questions, String answer) async {
    int i = pageController.page.toInt();
    int answered = int.parse(answer);
    answeredList.add(answered);
    print(answered);
    if (questions[i]['answer'] != answered) {
      ifWrong("Wrong", i, answered.toString());
    } else if (i + 1 == questions.length) {
      _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
      _disposed = true;
      await _stopWatchTimer.dispose();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => ReviewPage(
                    questionsList: questions,
                    answeredList: answeredList,
                  )));
    } else {
      pageController.animateToPage(i + 1,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
      searchController.clear();
    }
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    print('called deactivate');
    super.deactivate();
  }
}

List<Map> questions = [
  {
    'question': '1+3',
    'answer': 4,
    'solution': {
      'image':
          'https://d138zd1ktt9iqe.cloudfront.net/media/seo_landing_files/afshan-us-addition-03-1605863466.png',
      'youtube': 'https://www.youtube.com/watch?v=HJ1AlSrgZVQ'
    }
  },
  {'question': '1+5', 'answer': 6},
  {'question': '1+7', 'answer': 8},
  {'question': '1+5', 'answer': 6},
  {'question': '1+4', 'answer': 5}
];
