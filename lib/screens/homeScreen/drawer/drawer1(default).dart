import 'dart:math' as math;

import 'package:cached_network_image/cached_network_image.dart';
import 'package:clearit/screens/viewOurSolution/ViewOurSolutionScreen.dart';
import 'package:clearit/utility/provider/account.dart';
import 'package:clearit/utility/provider/commonprovider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Get Coins/Promocode/PromoCodeScreen.dart';
import 'Get Coins/RequestCoins.dart';
import 'Myaccount/CoinDetails.dart';
import 'Myaccount/savedItems/savedItemsScreen.dart';
import 'profile/profile.dart';

import 'services/servicesBrain.dart';
import 'services/servicesIndex.dart';
import 'package:clearit/utility/loadingWidget/loading.dart';

class Drawer1 extends StatefulWidget {
  final Widget child;

  const Drawer1({required this.child});

  static Drawer1State of(BuildContext context) =>
      context.findAncestorStateOfType<Drawer1State>()!;

  @override
  Drawer1State createState() => new Drawer1State();
}

class Drawer1State extends State<Drawer1> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  bool _canBeDragged = false;
  final double maxSlide = 300.0;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 250),
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void toggle() => animationController.isDismissed
      ? animationController.forward()
      : animationController.reverse();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onHorizontalDragStart: _onDragStart,
        onHorizontalDragUpdate: _onDragUpdate,
        onHorizontalDragEnd: _onDragEnd,
        behavior: HitTestBehavior.translucent,
        onTap: () {
          if (animationController.isDismissed != true) {
            toggle();
          }
        },
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, _) {
            return Material(
              // color: Colors.white,
              child: Stack(
                children: <Widget>[
                  Container(
                      color: Colors.white, height: 90, width: double.infinity),
                  Transform.translate(
                    offset:
                        Offset(maxSlide * (animationController.value - 1), 0),
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(
                            math.pi / 2 * (1 - animationController.value)),
                      alignment: Alignment.centerRight,
                      child: MyDrawer(),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(maxSlide * animationController.value, 0),
                    child: Transform(
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(-math.pi * animationController.value / 2),
                      alignment: Alignment.centerLeft,
                      child: widget.child,
                    ),
                  ),
                  Positioned(
                    top: 4.0 + MediaQuery.of(context).padding.top,
                    left: 4.0 + animationController.value * maxSlide,
                    child: IconButton(
                      icon: Icon(Icons.sort),
                      onPressed: toggle,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onDragStart(DragStartDetails details) {
    bool isDragOpenFromLeft = animationController.isDismissed;
    bool isDragCloseFromRight = animationController.isCompleted;
    _canBeDragged = isDragOpenFromLeft || isDragCloseFromRight;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    if (_canBeDragged) {
      double delta = details.primaryDelta! / maxSlide;
      animationController.value += delta;
    }
  }

  void _onDragEnd(DragEndDetails details) {
    //I have no idea what it means, copied from Drawer
    double _kMinFlingVelocity = 365.0;

    if (animationController.isDismissed || animationController.isCompleted) {
      return;
    }
    if (details.velocity.pixelsPerSecond.dx.abs() >= _kMinFlingVelocity) {
      double visualVelocity = details.velocity.pixelsPerSecond.dx /
          MediaQuery.of(context).size.width;

      animationController.fling(velocity: visualVelocity);
    } else if (animationController.value < 0.5) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }
}

int _index = 0;

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  void initState() {
    _index = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map userData = Provider.of<MyAccount>(context, listen: false).userDetails!;

    return GestureDetector(
      onTap: () {},
      child: SizedBox(
        width: 300,
        height: MediaQuery.of(context).size.height,
        child: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 24,
              child: Material(
                color: Color(0xff6369f2).withOpacity(0.8),
                // color: Colors.white,
                elevation: 2,
                child: SafeArea(
                  child: Theme(
                    data: ThemeData(brightness: Brightness.dark),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: 10),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage()),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(width: 20),
                              userData['photo'] != null
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        child: CachedNetworkImage(
                                          imageUrl: userData['photo'],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => SizedBox(
                                              height: 30,
                                              width: 30,
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    )
                                  : Icon(CupertinoIcons.profile_circled,
                                      size: 100, color: Colors.white),
                              SizedBox(width: 10),
                              SizedBox(
                                height: 70,
                                width: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(height: 8),
                                    Text(
                                      '${Provider.of<MyAccount>(context, listen: false).userDetails!['name']}',
                                      style: TextStyle(
                                          fontSize: 17,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    SizedBox(height: 15),
                                    Text(
                                      'My profile',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 10),
                                  ],
                                ),
                              ),
                              SizedBox(width: 20),
                            ],
                          ),
                        ),
                        Divider(),
                        InkWell(
                            onTap: () {
                              if (_index == 1) {
                                _index = 0;
                              } else {
                                _index = 1;
                              }
                              setState(() {});
                            },
                            child: buildChildDiagram(
                                ListTile(
                                  leading: Icon(Icons.person),
                                  title: Text('My Account'),
                                ),
                                [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  CoinDetails()));
                                    },
                                    child: Container(
                                      child: Text('Coin Details',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ViewOurSolutionScreen()));
                                    },
                                    child: Container(
                                      child: Text(
                                        'My Questions',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                    ),
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SavedItemsScreen()));
                                    },
                                    child: Container(
                                      child: Text('Saved Items',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                    ),
                                  ),
                                ],
                                isTrue(_index, 1))),
                        InkWell(
                          onTap: () {
                            if (_index == 2) {
                              _index = 0;
                            } else {
                              _index = 2;
                            }
                            setState(() {});
                          },
                          child: buildChildDiagram(
                              ListTile(
                                leading: Icon(Icons.map),
                                title: Text('Services '),
                              ),
                              [
                                FlatButton(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ServicesIndexScreen(
                                                  id: "currentServices",
                                                  title: "Current Services",
                                                )));
                                  },
                                  child: Container(
                                    child: Text('Current',
                                        style: TextStyle(color: Colors.white)),
                                    alignment: Alignment.centerLeft,
                                  ),
                                  // alignment: Alignment.centerLeft,
                                  // height: 30,
                                ),
                                FlatButton(
                                  onPressed: () async {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ServicesIndexScreen(
                                                  id: 'upcomingServices',
                                                  title: "Upcoming Services",
                                                )));
                                  },
                                  child: Container(
                                    child: Text(
                                      'Upcoming',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    height: 30,
                                  ),
                                ),
                              ],
                              isTrue(_index, 2)),
                        ),
                        InkWell(
                            onTap: () {
                              if (_index == 3) {
                                _index = 0;
                              } else {
                                _index = 3;
                              }
                              setState(() {});
                            },
                            child: buildChildDiagram(
                                ListTile(
                                  leading: Icon(Icons.monetization_on),
                                  title: Text('Get coins'),
                                ),
                                [
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PromoCodeScreen()));
                                    },
                                    child: Container(
                                      child: Text('Use a Promocode',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      alignment: Alignment.centerLeft,
                                    ),
                                    // alignment: Alignment.centerLeft,
                                    // height: 30,
                                  ),
                                  FlatButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RequestCoinsScreen()));
                                    },
                                    child: Container(
                                      child: Text(
                                        'Request Coins',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      alignment: Alignment.centerLeft,
                                      height: 30,
                                    ),
                                  ),
                                ],
                                isTrue(_index, 3))),
                        ListTile(
                          leading: Icon(Icons.share),
                          title: Text('Share'),
                        ),
                        ListTile(
                          leading: Icon(Icons.chrome_reader_mode),
                          title: Text('Privacy Policy'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

bool isTrue(int index, int value) {
  if (index == value) {
    return true;
  }
  return false;
}

Widget buildChildDiagram(Widget child, List<Widget> widgets, bool show) {
  int milliSecond = 400;
  return AnimatedContainer(
    duration: Duration(milliseconds: milliSecond),
    height: show ? 40.0 + (50 * widgets.length) : 55,
    // height: 110,
    child: Stack(
      children: [
        child,
        // big line
        Positioned(
          left: 62,
          top: 28,
          child: AnimatedContainer(
            height: show ? widgets.length * 47.5 : 0,
            // height: 0,
            width: 1,
            color: Colors.white38,
            duration: Duration(milliseconds: milliSecond),
          ),
        ),
        Positioned(
          left: 62,
          top: 74,
          child: AnimatedContainer(
            width: show ? 30 : 0,
            height: 1,
            color: Colors.white38,
            duration: Duration(milliseconds: milliSecond),
          ),
        ),
        widgets.length > 1
            ? Positioned(
                left: 62,
                top: 122,
                child: AnimatedContainer(
                  width: show ? 30 : 0,
                  height: 1,
                  color: Colors.white38,
                  duration: Duration(milliseconds: milliSecond),
                ),
              )
            : Container(),
        widgets.length > 2
            ? Positioned(
                left: 62,
                top: 170,
                child: AnimatedContainer(
                  width: show ? 30 : 0,
                  height: 1,
                  color: Colors.white38,
                  duration: Duration(milliseconds: milliSecond),
                ),
              )
            : Container(),
        Positioned(
          top: 50,
          left: 100,
          height: 48.0 * widgets.length,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: widgets,
          ),
        ),
      ],
    ),
  );
}
