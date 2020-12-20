import 'package:flutter/material.dart';

class HomeBox extends StatelessWidget {
  final String title;
  final String image;
  final Function onPressed;
  final size;
  HomeBox({this.title, this.size, this.image, this.onPressed});
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: InkWell(
        onTap: onPressed,
        child: Container(
          width: (size.width / 3.6),
          height: size.height / 6,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                    height: (size.width / 3.5) / 2,
                    color: Colors.white,
                    width: (size.width / 3.5) / 2,
                    child: Image.asset('$image')),
                Spacer(),
                Text(
                  '$title',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.blue),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //     colors: [Color(0xff7f86ff), Color(0xff6369f2)]),
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
      ),
    );
  }
}
