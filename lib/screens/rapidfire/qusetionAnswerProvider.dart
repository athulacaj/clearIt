import 'package:flutter/material.dart';

class RapidFireQuestionAnswersProvider extends ChangeNotifier {
  int questionIndex = 0;
  int previousIndex = -1;
  List<Map> answeredList = [];
  List<Map> markedList = []; //marked for review,
  int totalTimeSpend = 0;
  List saveQuestionData() {
    return [questionIndex, previousIndex, answeredList, markedList];
  }

  void retrieveSavedQuestionData(Map data, bool isNull) {
    totalTimeSpend = 0;

    if (isNull == true) {
      questionIndex = 0;
      previousIndex = -1;
      answeredList = [];
      markedList = [];
    } else {
//      Map cData = data.fromJson(jsonresponse[0]);
      int qIndex = data['questionIndex'];
      int pIndex = data['questionIndex'];
      List<Map> aList = List<Map>.from(data['answeredList']);
      List<Map> mList = List<Map>.from(data['markedList']);
      questionIndex = qIndex;
      previousIndex = pIndex;
      answeredList = aList;
      markedList = mList;
      for (var answerMap in answeredList) {
        totalTimeSpend = totalTimeSpend + answerMap['timeSpend'];
      }
    }
    notifyListeners();
  }

  void changeQuestionIndex(int index) {
    previousIndex = questionIndex;
    questionIndex = index;
    notifyListeners();
  }

  void totalNoOfAnswersList(int totalNo) {
    for (int i = 0; i < totalNo; i++) {
      int timeSpend;
      if (i == 0) {
        timeSpend = -1;
      } else {
        timeSpend = 0;
      }
      Map toAdd = {
        'question': -1,
        'selected': -1,
        'previousSelected': -1,
        'timeSpend': timeSpend,
        'isBookmarked': false,
        'isGuessed': false,
      };
      answeredList.add(toAdd);
      markedList.add({'marked': false});
    }
  }

  void addOptionToAnswerList({int optionSelected}) {
    if (answeredList[questionIndex]['selected'] != -1) {
      answeredList[questionIndex]['previousSelected'] =
          answeredList[questionIndex]['selected'];
    }
    answeredList[questionIndex]['selected'] = optionSelected;
    answeredList[questionIndex]['question'] = questionIndex;
    notifyListeners();
  }

  void addTimeOfEachQuestion() {
    var time = answeredList[questionIndex]['timeSpend'];
    answeredList[questionIndex]['timeSpend'] = time + 1;
  }

  void addToMarkedList(bool isMarked) {
    markedList[questionIndex]['marked'] = isMarked;
    notifyListeners();
  }

  void addToBookmark(bool isBookmarked) {
    answeredList[questionIndex]['isBookmarked'] = isBookmarked;
    notifyListeners();
  }

  void addToGuess(bool isGuessed) {
    answeredList[questionIndex]['isGuessed'] = isGuessed;
    notifyListeners();
  }

  void submit() {
    answeredList = [];
    markedList = [];
    questionIndex = 0;
//    notifyListeners();
  }
}
