import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearit/screens/rapidfire/qusetionAnswerProvider.dart';

class SolutionOptions extends StatefulWidget {
  final int selectedIndex;
  final List options;
  final int qNo;
  final Map testDetailsFromPvsScreen;
  SolutionOptions(
      {required this.selectedIndex,
      required this.options,
      required this.qNo,
      required this.testDetailsFromPvsScreen});
  @override
  _SolutionOptionsState createState() => _SolutionOptionsState();
}

late int selectedIndex;

class _SolutionOptionsState extends State<SolutionOptions> {
  @override
  void initState() {
    selectedIndex = widget.selectedIndex;

    super.initState();
  }

  bool fromOptionButton = false;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: 1000), // **THIS is the important part**
      child: widget.options.length > 1
          ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.options.length,
              itemBuilder: (BuildContext context, int i) {
                return Consumer<RapidFireQuestionAnswersProvider>(
                  builder: (BuildContext context, provider, Widget? child) {
                    int optionSelected = -1;
                    int answerIndex =
                        widget.testDetailsFromPvsScreen['questionsList']
                            [widget.qNo]['answerIndex'];
                    if (provider.answeredList.length > 0) {
                      optionSelected =
                          provider.answeredList[widget.qNo]['selected'];
                    }
                    return GestureDetector(
                      onTap: () {
                        print(widget.testDetailsFromPvsScreen['questionsList']
                            [widget.qNo]);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: <Widget>[
                            Material(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              elevation: 2,
                              color: getOptionColor(
                                  answerIndex, i, optionSelected),
                              child: AnimatedContainer(
                                width: MediaQuery.of(context).size.width - 42,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                                duration: Duration(milliseconds: 200),
                                child: Text(
                                  '${widget.options[i]}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    color: getOptionColor(
                                        answerIndex, i, optionSelected),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            )
          : null,
    );
  }
}

Color? getOptionColor(int correct, int index, int selected) {
  if (index == correct && selected == index) {
    return Colors.green;
  } else if (index == correct) {
    return Colors.greenAccent;
  } else if (selected == index) {
    return Colors.red;
  } else {
    return null;
  }
}
