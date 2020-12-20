import 'package:flutter/material.dart';

import 'ClassSureShort.dart';
import 'questionsPage/questionsIndex.dart';

class SureShort extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 100,
      child: Column(
        children: SureShortClass()
            .questions
            .map((e) => Material(
                  elevation: 3,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => QuestionsPage(
                                    testDetails: e,
                                  )));
                    },
                    child: Container(
                      width: size.width / 1.2,
                      padding: EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${e['name']}'),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.timer),
                              Text('${e['time']} s'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
      // child: ListView.builder(
      //   itemBuilder: (BuildContext context, int index) {
      //     return Container();
      //   },
      // ),
    );
  }
}
