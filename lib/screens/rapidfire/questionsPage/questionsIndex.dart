import 'package:clearit/screens/rapidfire/RapidFireDatabaseManager.dart';
import 'package:clearit/screens/rapidfire/Resultpage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:clearit/screens/rapidfire/RapiFireClass.dart';
import 'package:clearit/screens/rapidfire/solutions/solutionsIndex.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'questionWidget.dart';
import '../qusetionAnswerProvider.dart';
// import 'solutionAnswerProvider.dart';
// import 'package:clearit/screens/rapidfire/solutions/SolutionIndex.dart';

late TabController _questionController;
Map testDetailsFromPvsScreen = {};
int s = 0;

class QuestionsPage extends StatefulWidget {
  final Map testDetails;

  QuestionsPage({required this.testDetails});
  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

late ThemeData theme;
late bool runTimer;
bool _isMore = false;
bool _isBookmarked = false;
List<dynamic> _questionAnswers = [];

class _QuestionsPageState extends State<QuestionsPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final CountdownController _countController = CountdownController();
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    isLapHours: true,
  );

  @override
  void initState() {
    s = 0;
    testDetailsFromPvsScreen = widget.testDetails;
    _questionAnswers = widget.testDetails['questionsList'];
    print(widget.testDetails['questionsList']);
    runTimer = true;
    _isMore = false;
    _isBookmarked = false;
    var provider =
        Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false);
    _questionController =
        TabController(vsync: this, length: _questionAnswers.length);
    _questionController.index = provider.questionIndex;
    tabListener();
    print('index is ${_questionController.index}');
    provider.totalNoOfAnswersList(_questionAnswers.length);
    _countController.start();
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    super.initState();
  }

  void changeIndex(int index) async {
    await Future.delayed(Duration(milliseconds: 500));
    Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false)
        .changeQuestionIndex(index);
  }

  void tabListener() {
    _questionController.addListener(() {
      int index = _questionController.index;
      Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false)
          .changeQuestionIndex(index);
    });
  }

  void closeModal(void value) {
    int index =
        Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false)
            .questionIndex;
    _questionController.index = index;
    print('modal closed');
  }

  @override
  void dispose() {
    _questionController.dispose();
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.white));
    _stopWatchTimer.dispose();

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
        // backgroundColor: Colors.white.withOpacity(0.9),
        backgroundColor: Colors.blueAccent.withOpacity(0.3),
        body: SafeArea(
          child: Column(
            children: <Widget>[
              Consumer<RapidFireQuestionAnswersProvider>(
                builder: (context, provider, child) {
                  return Material(
                    // textStyle: TextStyle(color: Colors.white),
                    // color: Colors.white,
                    color: Colors.blueAccent.withOpacity(0.3),
                    elevation: 2,
                    child: Padding(
                      padding: EdgeInsets.only(
                          left: 6, right: 19, top: 5, bottom: 5),
                      child: Row(
                        children: [
                          IconButton(
                              icon: Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          Text(
                            'Q ${_questionController.index + 1}/${_questionAnswers.length}',
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          Spacer(),
                          Icon(Icons.timer, color: Colors.white),
                          StreamBuilder(
                            stream: _stopWatchTimer.secondTime,
                            initialData: 0,
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              if (snapshot.data == widget.testDetails['time']) {
                                print('Timer is done!');
                                submitFunction(context);
                              }
                              if (!snapshot.hasData) {
                                return Container();
                              }
                              s = snapshot.data as int;
                              return Text(
                                timeConvertor(snapshot.data),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              );
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

void submitFunction(context) {
  try {
    RapidFireManger.saveResult(context, testDetailsFromPvsScreen, s);
    saveRapidFireId(context, testDetailsFromPvsScreen['date'].toString());
    Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false)
        .questionIndex = 0;
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ResulPageScreen(
                  testDetails: testDetailsFromPvsScreen,
                )));
  } catch (e) {}
}

class BottomQuestionSelector extends StatefulWidget {
  final int totalQuestions;
  final TabController tabController;
  BottomQuestionSelector({
    required this.totalQuestions,
    required this.tabController,
  });

  @override
  _BottomQuestionSelectorState createState() => _BottomQuestionSelectorState();
}

late ScrollController _scrollController;

class _BottomQuestionSelectorState extends State<BottomQuestionSelector> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = new ScrollController();
  }

  @override
  void dispose() {
    _scrollController
        .dispose(); // it is a good practice to dispose the controller
    super.dispose();
  }

  @override
  Widget build(context) {
    double width = MediaQuery.of(context).size.width;
    return Consumer<RapidFireQuestionAnswersProvider>(
        builder: (context, provider, child) {
      List<Map> answeredList = provider.answeredList;
      print(provider.questionIndex);
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        _scrollController.animateTo(38.5 * provider.questionIndex,
            duration: Duration(milliseconds: 500), curve: Curves.linear);
      });

      return Container(
        width: width,
        padding: EdgeInsets.all(1),
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: ListView.builder(
            controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.totalQuestions,
            itemBuilder: (context, i) {
              return i != widget.totalQuestions - 1
                  ? buildIcon(i, answeredList, provider, widget.tabController)
                  : Row(
                      children: [
                        buildIcon(
                            i, answeredList, provider, widget.tabController),
                        TextButton(
                          onPressed: () {
                            submitFunction(context);
                          },
                          child: Text(
                            'Submit',
                            style: TextStyle(color: Colors.green),
                          ),
                        )
                      ],
                    );
            },
          ),
        ),
      );
    });
  }

  @override
  void deactivate() {
    // TODO: implement deactivate
    super.deactivate();
    Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false)
        .questionIndex = 0;
  }
}

Widget buildIcon(
    int i, List answeredList, provider, TabController tabController) {
  return TextButton(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
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
                height: 3,
                width: 18,
                color: Colors.deepPurple,
              )
            : Container(),
      ],
    ),
    onPressed: () {
      tabController.index = i;
    },
  );
}
