import 'package:flutter/material.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';
import 'package:studywithfun/screens/rapidfire/questionsPage/questionsIndex.dart';
import 'RapiFireClass.dart';

class RapidFireScreen extends StatefulWidget {
  const RapidFireScreen({Key key}) : super(key: key);

  @override
  _RapidFireScreenState createState() => _RapidFireScreenState();
}

class _RapidFireScreenState extends State<RapidFireScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: 'Rapid Fire', context: context),
      body: Column(
        children: [
          FlatButton(
            onPressed: () {
              RapidFireClass rapidFireClass = RapidFireClass();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => QuestionsPage(
                            testDetails: rapidFireClass.questionsDatabase,
                          )));
            },
            child: Text("View questions"),
          )
        ],
      ),
    );
  }
}
