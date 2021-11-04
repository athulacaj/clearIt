import 'package:clearit/screens/rapidfire/qusetionAnswerProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'solutions/solutionsIndex.dart';

class ResulPageScreen extends StatefulWidget {
  final Map testDetails;

  ResulPageScreen({required this.testDetails});
  @override
  _ResulPageScreenState createState() => _ResulPageScreenState();
}

class _ResulPageScreenState extends State<ResulPageScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    List<Map> answeredList =
        Provider.of<RapidFireQuestionAnswersProvider>(context, listen: false)
            .answeredList;
    print(answeredList);
    Map statisticsMap =
        getResult(widget.testDetails['questionsList'], answeredList);
    return Scaffold(
      backgroundColor: Colors.blueAccent.withOpacity(0.3),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Result", style: _defaultStyle.copyWith(fontSize: 22)),
            SizedBox(height: 10),
            Center(
              child: Container(
                alignment: Alignment.center,
                width: size.width - 60,
                height: size.width - 60,
                color: Colors.white.withOpacity(.1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Correct:  ${statisticsMap['correct']}',
                            style: _defaultStyle),
                        SizedBox(width: 14),
                        Icon(Icons.check, color: Colors.green)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Wrong:  ${statisticsMap['wrong']}',
                            style: _defaultStyle),
                        SizedBox(width: 14),
                        Icon(
                          Icons.close_rounded,
                          color: Colors.red,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('unanswered: ${statisticsMap['unAnswered']}',
                            style: _defaultStyle),
                        SizedBox(width: 14),
                        Icon(
                          Icons.radio_button_unchecked,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SolutionsQuestionsPage(
                                testDetails: widget.testDetails,
                              )));
                },
                child: Text("Solutions"))
          ],
        ),
      ),
    );
  }
}

TextStyle _defaultStyle = TextStyle(color: Colors.white, fontSize: 16);

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
