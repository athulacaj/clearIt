import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/screens/rapidfire/RapiFireClass.dart';
import 'package:studywithfun/screens/rapidfire/qusetionAnswerProvider.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';
import 'SolutionQuestionWidget.dart';
import 'viewSolutionwidget.dart';
// import 'solutionAnswerProvider.dart';
// import 'package:studywithfun/screens/rapidfire/solutions/SolutionIndex.dart';

TabController _questionTabController;
Map testDetailsFromPvsScreen = {};

class SolutionsQuestionsPage extends StatefulWidget {
  final Map testDetails;

  SolutionsQuestionsPage({this.testDetails});
  @override
  _SolutionsQuestionsPageState createState() => _SolutionsQuestionsPageState();
}

ThemeData theme;
bool runTimer;
bool _isMore = false;
bool _isBookmarked = false;
List<dynamic> _questionAnswers = [];

class _SolutionsQuestionsPageState extends State<SolutionsQuestionsPage>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final CountdownController _countController = CountdownController();

  @override
  void initState() {
    testDetailsFromPvsScreen = widget.testDetails;
    _questionAnswers = widget.testDetails['questionsList'];
    print(widget.testDetails['questionsList']);
    runTimer = true;
    _isMore = false;
    _isBookmarked = false;
    var provider =
        Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false);
    _questionTabController =
        TabController(vsync: this, length: _questionAnswers.length);
    _questionTabController.index = provider.questionIndex;
    tabListener();
    print('index is ${_questionTabController.index}');
    provider.totalNoOfAnswersList(_questionAnswers.length);

    super.initState();
  }

  void changeIndex(int index) async {
    await Future.delayed(Duration(milliseconds: 500));
    Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false)
        .changeQuestionIndex(index);
  }

  void tabListener() {
    _questionTabController.addListener(() {
      int index = _questionTabController.index;
      Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false)
          .changeQuestionIndex(index);
    });
  }

  void closeModal(void value) {
    int index =
        Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false)
            .questionIndex;
    _questionTabController.index = index;
    print('modal closed');
  }

  @override
  void dispose() {
    _questionTabController.dispose();
    // SystemChrome.setSystemUIOverlayStyle(
    //     SystemUiOverlayStyle(statusBarColor: Colors.white));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    changeIndex(_questionTabController.index);
    theme = Theme.of(context);
    Size size = MediaQuery.of(context).size;
    List<Map> answeredList =
        Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false)
            .answeredList;
    print(answeredList);
    Map statisticsMap =
        getResult(testDetailsFromPvsScreen['questionsList'], answeredList);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
          statusBarColor: Color(0xff7078ff),
          statusBarIconBrightness: Brightness.light),
      child: Scaffold(
        key: _scaffoldKey,
        // backgroundColor: Colors.white.withOpacity(0.9),
        backgroundColor: Color(0xffDAECF0),
        body: SafeArea(
          child: Consumer<RapidFireQuestionAnswersProvider>(
              builder: (context, provider, child) {
            return Column(
              children: <Widget>[
                Material(
                  // textStyle: TextStyle(color: Colors.white),
                  // color: Colors.white,
                  elevation: 2,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 6, right: 19, top: 5, bottom: 5),
                    child: Row(
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            }),
                        Text(
                          'Solutions',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Spacer(),
                        Icon(
                          Icons.check_circle,
                          color: Colors.green,
                        ),
                        SizedBox(width: 2),
                        Text('${statisticsMap['correct']}'),
                        SizedBox(width: 14),
                        Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                        ),
                        SizedBox(width: 2),
                        Text('${statisticsMap['wrong']}'),
                        SizedBox(width: 14),
                        Icon(
                          Icons.radio_button_unchecked,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 2),
                        Text('${statisticsMap['unAnswered']}'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                  child: Text(
                    'Q${_questionTabController.index + 1}',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _questionTabController,
                    children: <Widget>[
                      for (int i = 0; i < _questionAnswers.length; i++)
                        QuestionAndOption(
                          questionAnswer: _questionAnswers[i],
                          qNo: i,
                          totalQNo: _questionAnswers.length,
                          totalTime: widget.testDetails['time'],
                          testDetailsFromPvsScreen: testDetailsFromPvsScreen,
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
                    tabController: _questionTabController,
                  ),
                ),
              ],
            );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                builder: (BuildContext context) {
                  return Container(
                    height: size.height - 140,
                    padding: EdgeInsets.all(12),
                    child: ViewSolutionWidget(
                        qIndex: _questionTabController.index,
                        questionsList: _questionAnswers),
                  );
                });
          },
          child: Icon(Icons.arrow_circle_up),
        ),
      ),
    );
  }
}

class BottomQuestionSelector extends StatefulWidget {
  final int totalQuestions;
  final TabController tabController;
  BottomQuestionSelector({@required this.totalQuestions, this.tabController});

  @override
  _BottomQuestionSelectorState createState() => _BottomQuestionSelectorState();
}

ScrollController _scrollController;

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
      _scrollController.animateTo(38.5 * provider.questionIndex,
          duration: Duration(milliseconds: 500), curve: Curves.linear);
      return Container(
        width: width,
        padding: EdgeInsets.all(1),
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.totalQuestions,
            controller: _scrollController,
            itemBuilder: (context, i) {
              return i != widget.totalQuestions - 1
                  ? buildIcon(i, answeredList, provider, widget.tabController)
                  : Row(
                      children: [
                        buildIcon(
                            i, answeredList, provider, widget.tabController),
                        SizedBox(width: 70),
                      ],
                    );
            },
          ),
        ),
      );
    });
  }
}

Widget buildIcon(
    int i, List answeredList, provider, TabController tabController) {
  int answerIndex = testDetailsFromPvsScreen['questionsList'][i]['answerIndex'];
  return TextButton(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '${i + 1}',
          style: TextStyle(
              color: answeredList[i]['selected'] == -1
                  ? Colors.grey
                  : answerIndex == answeredList[i]['selected']
                      ? Colors.green
                      : Colors.red),
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

Map getResult(List questionsMapList, List selectedDetails) {
  Map result = {
    'correct': 0,
    'wrong': 0,
    'unAnswered': 0,
  };
  int i = 0;
  for (Map question in questionsMapList) {
    print(selectedDetails[i]);
    if (selectedDetails[i]['selected'] == -1) {
      result['unAnswered'] += 1;
    } else if (selectedDetails[i]['selected'] == question['answerIndex']) {
      result['correct'] += 1;
    } else {
      result['wrong'] += 1;
    }
    i += 1;
  }
  return result;
}
