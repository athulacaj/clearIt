import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/utility/coin.dart';
import 'package:studywithfun/utility/loadingWidget/loading.dart';
import 'package:studywithfun/utility/provider/account.dart';
import 'package:studywithfun/utility/provider/coinStramProvider.dart';
import 'package:studywithfun/utility/provider/commonprovider.dart';
import 'Tabs/Courses/Courses.dart';
import 'Tabs/TopPlayer.dart';
import 'Tabs/sureShort/sureShort.dart';
import 'drawer/drawer1(default).dart';
import 'drawer/drawer2.dart';

class HomeScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool flip = true;
    Map userDetails =
        Provider.of<MyAccount>(context, listen: false).userDetails;
    Widget child = StreamProvider<CoinsClass>.value(
        initialData: getInitialData(),
        value: CoinsStream(userDetails['uid'], context).getCoin,
        child: HomeScreen1());
    Widget newchild;
    if (flip) {
      newchild = Drawer1(child: child);
    } else {
      newchild = Drawer2(child: child);
    }
    return Drawer1(child: child);
  }
}

class HomeScreen1 extends StatefulWidget {
  @override
  _HomeScreen1State createState() => _HomeScreen1State();
}

class _HomeScreen1State extends State<HomeScreen1>
    with TickerProviderStateMixin {
  AnimationController _animationController;
  TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: 2);

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    colorTween = ColorTween(begin: Colors.white54, end: Colors.white
            // end: Color(0xffF4E528),
            )
        .animate(_animationController);
    _animationController.repeat(reverse: true);
    secureScreen();
    super.initState();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  Animation<Color> colorTween;

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  void update() {}
  @override
  Widget build(BuildContext context) {
    CoinsClass coinsClass = Provider.of<CoinsClass>(context);
    var size = MediaQuery.of(context).size;
    return CoinLoading(
      showSpinner: Provider.of<CommonProvider>(context, listen: true).isSpinner,
      child: Scaffold(
        appBar: AppBar(
          brightness: Brightness.light,
          // backgroundColor: Colors.white,
          backgroundColor: Color(0xff7078ff),
          leading: Container(),
          // leading: IconButton(
          //   // onPressed: () => CustomDrawer.of(context).open(),
          //   icon: Icon(
          //     Icons.sort,
          //     color: Colors.black,
          //   ),
          // ),
          title: Text(
            'ClearIt',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.notifications_active,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Text(
                  '${coinsClass.coins}',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                SizedBox(width: 1),
                CoinAnimation(colorTween),
                SizedBox(width: 6),
              ],
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              TabBar(
                controller: _tabController,
                tabs: [
                  Tab(
                    text: 'Courses',
                  ),
                  Tab(
                    text: 'Top Player',
                  ),
                  // Tab(
                  //   text: 'Sure Short',
                  // ),
                ],
              ),
              SizedBox(height: 20),
              // ask a doubt
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    Courses(),
                    TopPlayer(),
                    // SureShort(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
