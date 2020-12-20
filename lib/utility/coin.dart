import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Widget coinBuilder(double radius) {
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.symmetric(horizontal: 3),
    child: Stack(
      children: [
        Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
              color: Color(0xffF2C210),
              borderRadius: BorderRadius.all(Radius.circular(radius))),
        ),
        Positioned(
          left: (radius / 2) - ((radius / 1.5) / 2),
          top: (radius / 2) - ((radius / 1.5) / 2),
          child: Container(
            width: radius / 1.5,
            height: radius / 1.5,
            alignment: Alignment.center,
            child: Icon(Icons.star_half,
                size: radius / 2.2, color: Color(0xffF4E528)),
            decoration: BoxDecoration(
                color: Color(0xffDEB226),
                borderRadius: BorderRadius.all(Radius.circular(radius))),
          ),
        ),
      ],
    ),
  );
}

class CoinAnimation extends StatelessWidget {
  final Animation<Color> colorTween;
  CoinAnimation(this.colorTween);
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: colorTween,
      builder: (BuildContext context, Widget child) {
        return coinWithBadgeBuilder(20, colorTween.value);
      },
    );
  }
}

Widget coinWithBadgeBuilder(double radius, Color color) {
  return Container(
    alignment: Alignment.center,
    margin: EdgeInsets.symmetric(horizontal: 0),
    child: Stack(
      children: [
        Container(
          width: radius,
          height: radius,
          alignment: Alignment.center,
          // child: Text(
          //   '25',
          //   style: TextStyle(color: color, fontWeight: FontWeight.w800),
          // ),
          decoration: BoxDecoration(
              color: Color(0xffF2C210),
              borderRadius: BorderRadius.all(Radius.circular(radius))),
        ),
        Positioned(
          left: (radius / 2) - ((radius / 1.5) / 2),
          top: (radius / 2) - ((radius / 1.5) / 2),
          child: Container(
            width: radius / 1.5,
            height: radius / 1.5,
            alignment: Alignment.center,
            child: Icon(Icons.star, size: radius / 2.2, color: color
                // Color(0xffF4E528),
                ),
            decoration: BoxDecoration(
                color: Color(0xffDEB226),
                borderRadius: BorderRadius.all(Radius.circular(radius))),
          ),
        ),
      ],
    ),
  );
}
