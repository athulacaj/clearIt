import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

class HomeBox extends StatelessWidget {
  final String title;
  final String image;
  final size;
  HomeBox({
    required this.title,
    required this.size,
    required this.image,
  });
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.all(Radius.circular(16)),
      child: CustomPaint(
        painter: ShapePainter(16),
        child: Container(
          width: (size.width / 3.6),
          height: size.height / 6,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                    height: (size.width / 4) / 2.3,
                    // color: Colors.white,
                    width: (size.width / 4) / 2.3,
                    child: Image.asset('$image')),
                Spacer(),
                AutoSizeText(
                  '$title',
                  textAlign: TextAlign.center,
                  style:
                      TextStyle(color: Colors.blueGrey.shade900, fontSize: 16),
                ),
              ],
            ),
          ),
          decoration: BoxDecoration(
              // gradient: LinearGradient(
              //     colors: [Color(0xff7f86ff), Color(0xff6369f2)]),
              // color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
        ),
      ),
    );
  }
}

// FOR PAINTING LINES
class ShapePainter extends CustomPainter {
  double radius;
  ShapePainter(this.radius);
  @override
  void paint(Canvas canvas, Size size) {
    double width = size.width;
    double height = size.height;
    var paint = Paint();
    paint.color = Colors.grey.shade200.withOpacity(0.4);
    // paint.color = Colors.black.withOpacity(0.1);
    paint.strokeWidth = 4;
    var path = Path();
    path.moveTo(0, height * 0.7);
    path.quadraticBezierTo(width * .3, height * .7, width / 2, height);
    path.lineTo(radius, height);
    path.quadraticBezierTo(0, height, 0, height - radius);
    path.lineTo(0, height - radius);
    path.close();
    canvas.drawPath(path, paint);
    var upperPath = Path();
    upperPath.moveTo(width * .35, 0);
    upperPath.quadraticBezierTo(
        width * .3, height * .2, width * .6, height * .28);
    upperPath.quadraticBezierTo(
        width * .82, height * .3, width * .88, height * .58);
    upperPath.quadraticBezierTo(width * .93, height * .67, width, height * .62);
    // upperPath.lineTo(width, 0);
    upperPath.lineTo(width, radius);
    // upperPath.lineTo(width - radius, 0);
    upperPath.quadraticBezierTo(width, 0, width - radius, 0);
    // upperPath.lineTo(width, height);
    upperPath.close();
    canvas.drawPath(upperPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
