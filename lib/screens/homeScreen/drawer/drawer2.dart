// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:studywithfun/utility/coin.dart';
//
// class Drawer2 extends StatefulWidget {
//   final Widget child;
//
//   const Drawer2({Key key, @required this.child}) : super(key: key);
//
//   static Drawer2State of(BuildContext context) =>
//       context.findAncestorStateOfType<Drawer2State>();
//
//   @override
//   Drawer2State createState() => new Drawer2State();
// }
//
// class Drawer2State extends State<Drawer2> with SingleTickerProviderStateMixin {
//   static const Duration toggleDuration = Duration(milliseconds: 250);
//   static const double maxSlide = 225;
//   static const double minDragStartEdge = 60;
//   static const double maxDragStartEdge = maxSlide - 16;
//   AnimationController _animationController;
//   bool _canBeDragged = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: Drawer2State.toggleDuration,
//     );
//   }
//
//   void close() => _animationController.reverse();
//
//   void open() => _animationController.forward();
//
//   void toggleDrawer() => _animationController.isCompleted ? close() : open();
//
//   @override
//   void dispose() {
//     _animationController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         if (_animationController.isCompleted) {
//           close();
//           return false;
//         }
//         return true;
//       },
//       child: GestureDetector(
//         onHorizontalDragStart: _onDragStart,
//         onHorizontalDragUpdate: _onDragUpdate,
//         onHorizontalDragEnd: _onDragEnd,
//         child: AnimatedBuilder(
//           animation: _animationController,
//           child: widget.child,
//           builder: (context, child) {
//             double animValue = _animationController.value;
//             final slideAmount = maxSlide * animValue;
//             final contentScale = 1.0 - (0.3 * animValue);
//             return Stack(
//               children: <Widget>[
//                 MyDrawer(),
//                 Transform(
//                   transform: Matrix4.identity()
//                     ..translate(slideAmount)
//                     ..scale(contentScale, contentScale),
//                   alignment: Alignment.centerLeft,
//                   child: GestureDetector(
//                     onTap: _animationController.isCompleted ? close : null,
//                     child: child,
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
//
//   void _onDragStart(DragStartDetails details) {
//     bool isDragOpenFromLeft = _animationController.isDismissed &&
//         details.globalPosition.dx < minDragStartEdge;
//     bool isDragCloseFromRight = _animationController.isCompleted &&
//         details.globalPosition.dx > maxDragStartEdge;
//
//     _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
//   }
//
//   void _onDragUpdate(DragUpdateDetails details) {
//     if (_canBeDragged) {
//       double delta = details.primaryDelta / maxSlide;
//       _animationController.value += delta;
//     }
//   }
//
//   void _onDragEnd(DragEndDetails details) {
//     //I have no idea what it means, copied from Drawer
//     double _kMinFlingVelocity = 365.0;
//
//     if (_animationController.isDismissed || _animationController.isCompleted) {
//       return;
//     }
//     if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
//       double visualVelocity = details.velocity.pixelsPerSecond.dx /
//           MediaQuery.of(context).size.width;
//
//       _animationController.fling(velocity: visualVelocity);
//     } else if (_animationController.value < 0.5) {
//       close();
//     } else {
//       open();
//     }
//   }
// }
//
// class MyDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Color(0xff6369f2).withOpacity(0.8),
//       // color: Colors.white,
//       elevation: 2,
//       child: SafeArea(
//         child: Theme(
//           data: ThemeData(brightness: Brightness.dark),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.max,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.account_circle),
//                 title: Text('Athul Jacob'),
//               ),
//               ListTile(
//                 leading: Icon(Icons.person),
//                 title: Text('My Account'),
//               ),
//               ListTile(
//                 leading: Icon(Icons.map),
//                 title: Text('Services'),
//               ),
//               ListTile(
//                 leading: Icon(Icons.notifications),
//                 title: Text('Notifications'),
//               ),
//               ListTile(
//                 leading: Icon(Icons.monetization_on),
//                 title: Text('Get a coin'),
//               ),
//               ListTile(
//                 leading: Icon(Icons.chrome_reader_mode),
//                 title: Text('Privacy Policy'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
