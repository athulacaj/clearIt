import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessfulPageState createState() => _SuccessfulPageState();
}

class _SuccessfulPageState extends State<SuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 30,
            color: Colors.purple[600],
          ),
          SafeArea(
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                        child: Container(
                            width: MediaQuery.of(context).size.width / 2.2,
                            height: 150,
                            child: FlareActor(
                              "images/success.flr",
                              animation: 'animate',
                              fit: BoxFit.contain,
                            ))
                        // CircleDraw()),
                        ),
                    TweenAnimationBuilder(
                        tween:
                            ColorTween(begin: Colors.white, end: Colors.black),
                        duration: Duration(milliseconds: 2000),
                        builder: (context, value, child) {
                          return Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.black26)),
                            child: Text(
                              'You asked you doubt successfully, check View our solution for status.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 16),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void deactivate() {
    super.deactivate();
  }
}
