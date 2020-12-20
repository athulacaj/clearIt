import 'package:flutter/material.dart';
import 'package:studywithfun/screens/homeScreen/homeScreen.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';

import '../mindMath.dart';

class AnswerWrong extends StatefulWidget {
  final String reason;
  AnswerWrong({this.reason});

  @override
  _AnswerWrongState createState() => _AnswerWrongState();
}

class _AnswerWrongState extends State<AnswerWrong> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commonAppBar(title: 'Mind Math', context: context),
      body: SafeArea(
        child: SizedBox(
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              widget.reason == 'wrong'
                  ? Text('Your Answer Is Wrong!!')
                  : Text('Time Out'),
              SizedBox(height: 45),
              InkWell(
                  onTap: () {},
                  child: Container(
                    height: 50,
                    width: size.width / 2,
                    alignment: Alignment.center,
                    child: Text(
                      'Youtube Link',
                      style: TextStyle(color: Colors.white),
                    ),
                    decoration: BoxDecoration(
                        color: Color(0xff6369f2),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                  )),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                      color: Color(0xff6369f2),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MindMathScreen()));
                      },
                      child: Text(
                        'Try Again',
                        style: TextStyle(color: Colors.white),
                      )),
                  FlatButton(
                      color: Color(0xff6369f2),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Home',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
