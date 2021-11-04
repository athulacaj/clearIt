import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'qusetionAnswerProvider.dart';

class Options extends StatefulWidget {
  final int selectedIndex;
  final List options;
  final int qNo;
  Options(
      {required this.selectedIndex, required this.options, required this.qNo});
  @override
  _OptionsState createState() => _OptionsState();
}

late int selectedIndex;

class _OptionsState extends State<Options> {
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
                return GestureDetector(
                  onTap: () {
                    if (i == selectedIndex) {
                      selectedIndex = -1;
                    } else {
                      selectedIndex = i;
                    }
                    Provider.of<SureShotAnswersProvider>(context, listen: false)
                        .addOptionToAnswerList(optionSelected: selectedIndex);
                    setState(() {});
                  },
                  child: Consumer<SureShotAnswersProvider>(
                    builder: (BuildContext context, provider, Widget? child) {
                      int optionSelected = -1;
                      if (provider.answeredList.length > 0) {
                        optionSelected =
                            provider.answeredList[widget.qNo]['selected'];
                      }
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: <Widget>[
//                      optionSelected != i
//                          ? Icon(Icons.check_box_outline_blank,
//                              color: Colors.black, size: 30)
//                          : Icon(Icons.check_box,
//                              size: 30, color: theme.buttonColor),
//                      SizedBox(width: 10),
                            Material(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                              elevation: 2,
                              color: optionSelected == i
                                  ? theme.buttonColor.withOpacity(0.95)
                                  : null,
                              child: AnimatedContainer(
                                width: MediaQuery.of(context).size.width - 42,
                                padding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 6),
                                duration: Duration(milliseconds: 200),
                                child: Text(
                                  '${widget.options[i]}',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: optionSelected == i
                                          ? Colors.white
                                          : null),
                                ),
                                decoration: BoxDecoration(
                                    color: optionSelected == i
                                        ? theme.primaryColor.withOpacity(0.95)
                                        : null,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(10))),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            )
          : null,
    );
  }
}
