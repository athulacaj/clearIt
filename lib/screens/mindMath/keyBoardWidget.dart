import 'package:flutter/material.dart';

class KeyBoardWidget extends StatefulWidget {
  final Function onSubmit;
  KeyBoardWidget({required this.onSubmit});
  @override
  _KeyBoardWidgetState createState() => _KeyBoardWidgetState();
}

late Size size;
late double padding;
late double h;
String result = '';

class _KeyBoardWidgetState extends State<KeyBoardWidget> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    result = '';
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    padding = 14;
    h = size.height / 2.7;
    return Container(
      margin: EdgeInsets.all(6),
      height: size.height / 2.5 + 50,
      child: Column(
        children: [
          Container(
            height: 40,
            // padding: EdgeInsets.all(8),
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(result, style: resultTextStyle),
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                border: Border.all(color: Colors.black26)),
          ),
          SizedBox(height: 6),
          Row(
            children: [
              numberButton(1),
              numberButton(2),
              numberButton(3),
            ],
          ),
          Row(
            children: [
              numberButton(4),
              numberButton(5),
              numberButton(6),
            ],
          ),
          Row(
            children: [
              numberButton(7),
              numberButton(8),
              numberButton(9),
            ],
          ),
          Row(
            children: [
              iconButton(
                  Icon(Icons.clear,
                      color: result.length > 0 ? Colors.black : Colors.grey),
                  () {
                if (result.length > 0) {
                  result = result.substring(0, result.length - 1);
                  setState(() {});
                }
              }),
              numberButton(0),
              iconButton(
                  Icon(
                    Icons.check,
                    color: result.length > 0 ? Colors.black : Colors.grey,
                  ), () {
                if (result.length > 0) {
                  widget.onSubmit(result);
                  result = '';
                  setState(() {});
                }
              })
            ],
          ),
        ],
      ),
    );
  }

  Widget numberButton(int num) {
    double margin = 12;
    return Material(
      elevation: 3,
      child: InkWell(
        onTap: () {
          result = result + '$num';
          setState(() {});
        },
        child: Container(
          alignment: Alignment.center,
          width: (size.width - margin) / 3,
          height: h / 4,
          child: Text('$num', style: buttonTextStyle),
        ),
      ),
    );
  }

  Widget iconButton(Icon icon, Function onclick) {
    double margin = 12;
    return Material(
      elevation: 3,
      child: InkWell(
        onTap: () {
          onclick();
        },
        child: Container(
          alignment: Alignment.center,
          width: (size.width - margin) / 3,
          height: h / 4,
          child: icon,
        ),
      ),
    );
  }
}

TextStyle resultTextStyle = TextStyle(color: Colors.black54, fontSize: 20);
TextStyle buttonTextStyle = TextStyle(fontSize: 18);
