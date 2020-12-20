import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/screens/homeScreen/Tabs/sureShort/questionsPage/questionWidget.dart';
import 'package:studywithfun/screens/homeScreen/Tabs/sureShort/questionsPage/qusetionAnswerProvider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

TabController _questionController;

class QuestionsPage extends StatefulWidget {
  final Map testDetails;

  QuestionsPage({this.testDetails});
  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

ThemeData theme;
bool runTimer;
bool _isMore = false;
bool _isBookmarked = false;
List<dynamic> _questionAnswers = [];

class _QuestionsPageState extends State<QuestionsPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final CountdownController _countController = CountdownController();

  @override
  void initState() {
    _questionAnswers = widget.testDetails['questionsList'];
    print(widget.testDetails['questionsList']);
    runTimer = true;
    _isMore = false;
    _isBookmarked = false;
    var provider = Provider.of<QuestionAnswersProvider>(context, listen: false);
    _questionController =
        TabController(vsync: this, length: _questionAnswers.length);
    _questionController.index = provider.questionIndex;
    tabListener();
    print('index is ${_questionController.index}');
    provider.totalNoOfAnswersList(_questionAnswers.length);

    super.initState();
  }

  void changeIndex(int index) async {
    await Future.delayed(Duration(milliseconds: 500));
    Provider.of<QuestionAnswersProvider>(context, listen: false)
        .changeQuestionIndex(index);
  }

  void tabListener() {
    _questionController.addListener(() {
      int index = _questionController.index;
      Provider.of<QuestionAnswersProvider>(context, listen: false)
          .changeQuestionIndex(index);
    });
  }

  void closeModal(void value) {
    int index = Provider.of<QuestionAnswersProvider>(context, listen: false)
        .questionIndex;
    _questionController.index = index;
    print('modal closed');
  }

  @override
  void dispose() {
    _questionController.dispose();
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.white));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    changeIndex(_questionController.index);
    theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Color(0xff7078ff),
          statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white.withOpacity(0.9),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Consumer<QuestionAnswersProvider>(
                builder: (context, provider, child) {
                  return Material(
                    // textStyle: TextStyle(color: Colors.white),
                    color: Colors.white,
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 6, right: 19, top: 5, bottom: 5),
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                              ),
                              onPressed: () {}),
                          Text(
                            'Q ${_questionController.index + 1}/${_questionAnswers.length}',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Icon(Icons.timer),
                          Countdown(
                            controller: _countController,
                            seconds: widget.testDetails['time'],
                            build: (BuildContext context, double time) =>
                                Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
//                border: Border.all(color: Colors.grey),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(6))),
                              child: returnText(time, context),
                            ),
                            interval: Duration(seconds: 1),
                            onFinished: () {
                              print('Timer is done!');
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Expanded(
                child: TabBarView(
                  controller: _questionController,
                  children: <Widget>[
                    for (int i = 0; i < _questionAnswers.length; i++)
                      QuestionAndOption(
                        questionAnswer: _questionAnswers[i],
                        qNo: i,
                        totalQNo: _questionAnswers.length,
                        totalTime: widget.testDetails['time'],
                      ),
                  ],
                ),
              ),
              Container(
                // height: 70,
                width: double.infinity,
                color: Colors.white,
                child: BottomQuestionSelector(
                  totalQuestions: _questionAnswers.length,
                  tabController: _questionController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomQuestionSelector extends StatelessWidget {
  final int totalQuestions;
  final TabController tabController;
  BottomQuestionSelector({@required this.totalQuestions, this.tabController});

  @override
  Widget build(context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<QuestionAnswersProvider>(
        builder: (context, provider, child) {
      List<Map> answeredList = provider.answeredList;
      print(provider.questionIndex);
      return Container(
        width: width,
        padding: EdgeInsets.all(1),
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: totalQuestions,
            itemBuilder: (context, i) {
              return TextButton(
                child: Column(
                  children: [
                    Text(
                      '${i + 1}',
                      style: TextStyle(
                          color: answeredList[i]['selected'] == -1
                              ? Colors.grey
                              : Colors.green),
                    ),
                    i == provider.questionIndex
                        ? Container(
                            height: 2,
                            width: 10,
                            color: Colors.deepPurple,
                          )
                        : Container(),
                  ],
                ),
                onPressed: () {
                  tabController.index = i;
                },
              );
            },
          ),
        ),
      );
    });
  }
}
