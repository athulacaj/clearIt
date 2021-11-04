import 'package:clearit/utility/provider/adState.dart';
import 'package:clearit/utility/provider/savedDataProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:clearit/utility/coin.dart';
import 'package:clearit/utility/loadingWidget/loading.dart';
import 'package:clearit/utility/provider/account.dart';
import 'package:clearit/utility/provider/coinStramProvider.dart';
import 'package:clearit/utility/provider/commonprovider.dart';
import 'NotificationScreen.dart';
import 'Tabs/HomeTab/home_tab.dart';
import 'Tabs/TopPlayer.dart';
import 'Tabs/sureShort/sureShort.dart';
import 'drawer/drawer1(default).dart';
import 'drawer/drawer2.dart';
import 'fmc.dart';

class HomeScreen extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    bool flip = true;
    Map userDetails =
        Provider.of<MyAccount>(context, listen: false).userDetails!;
    Widget child = HomeScreen1();
    // StreamProvider<CoinsClass>.value(
    //     initialData: getInitialData(),
    //     value: CoinsStream(userDetails['uid'], context).getCoin,
    //     child: HomeScreen1());
    Widget newchild;
    if (flip) {
      newchild = Drawer1(child: child);
    } else {
      // newchild = Drawer2(child: child);
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
  late AnimationController _animationController;
  late TabController _tabController;
  late Animation<Color?> colorTween;
  @override
  void initState() {
    super.initState();
    FcmMain.onMessageReceived();
    _tabController = TabController(vsync: this, length: 2);

    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    ColorTween cl = ColorTween(begin: Colors.white54, end: Colors.white
        // end: Color(0xffF4E528),
        );
    colorTween = cl.animate(_animationController);
    _animationController.repeat(reverse: true);
    secureScreen();
    RewardAds.createRewardedAd();
  }

  Future<void> secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<SavedDataProvider>(context).getSavedData();
    final AdSize adSize = AdSize(width: 320, height: 250);

    final adstate = Provider.of<AdState>(context, listen: true);
    adstate.loadInterstitialAd(adstate.videoInterstitialAdUnnit);
    adstate.initialization.then((status) {
      setState(() {
        banner = BannerAd(
            size: AdSize.banner,
            adUnitId: adstate.getBannerAdUnnit,
            listener: adstate.listener,
            request: AdRequest())
          ..load();
      });
    });
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
              onPressed: () async {
                // clearNotificationList();
                List notificationList = await getNotificationList();
                print(notificationList);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NotificationScreen(
                              notificationList: notificationList,
                            )));
              },
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
          child: Stack(
            children: [
              SizedBox(
                height: size.height - 50,
                child: Column(
                  children: [
                    TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(
                          text: 'Home',
                        ),
                        Tab(
                          text: 'Top Player',
                        ),
                        // Tab(
                        //   text: 'Sure Short',
                        // ),
                      ],
                    ),
                    // SizedBox(height: 10),
                    Divider(),
                    // ask a doubt
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          HomeTab(),
                          TopPlayer(),
                          // SureShort(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                width: size.width,
                child: Container(
                  color: Colors.white,
                  height: 50,
                  child: banner == null ? Container() : AdWidget(ad: banner!),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
