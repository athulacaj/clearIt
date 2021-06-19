import 'package:flutter/material.dart';

Future<void> coinDetectFunction(
    BuildContext context, Function successFunction) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Are you sure !!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('On submitting a coin is deducted'),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            child: Text('ok'),
            onPressed: () {
              Navigator.of(context).pop();
              successFunction();
            },
          ),
        ],
      );
    },
  );
}
