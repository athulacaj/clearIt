import 'dart:async';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class Demo extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<Demo> {
  String _animation = "animate";
  bool isOpen = true;
  String _animationToPlay = 'animation';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: FlareActor(
                "images/coin.flr",
                animation: isOpen ? 'animation' : 'animation Duplicate',
                fit: BoxFit.contain,
                callback: (value) {
                  print(value);
                  isOpen = !isOpen;
                  setState(() {});
                },
              ),
            ),
          ),
          RaisedButton(
            child: Text("Build"),
            onPressed: () {
              setState(() {
                _animation = "Build";
              });
            },
          ),
          RaisedButton(
            child: Text("Build and Fade Out"),
            onPressed: () {
              setState(() {
                isOpen = !isOpen;
                print('on tap pressed');
              });
            },
          ),
        ],
      ),
    );
  }

  void _setAnimationToPlay(String animation) {
    if (animation == _animationToPlay) {
      _animationToPlay = '';
      Timer(const Duration(milliseconds: 1000), () {
        _animationToPlay = animation;
      });
    } else {
      _animationToPlay = animation;
    }
    setState(() {});
  }
}
