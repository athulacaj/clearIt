import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/auth/phoneAuth/newUser.dart';
import 'screens/homeScreen/homeScreen.dart';
import 'screens/auth/phoneAuth/login.dart';
import 'utility/loadingWidget/ModalProgressHudWidget.dart';
import 'utility/provider/account.dart';
import 'utility/provider/coinStramProvider.dart';

bool _showSpinner = true;

class SplashScreenWindow extends StatefulWidget {
  static String id = 'Splash_Screen';

  @override
  _SplashScreenWindowState createState() => _SplashScreenWindowState();
}

class _SplashScreenWindowState extends State<SplashScreenWindow> {
  @override
  void initState() {
    _showSpinner = true;
    initFunctions();
    super.initState();
  }

  Future<void> preCache() async {
    await cachedActor(
      AssetFlare(bundle: rootBundle, name: 'images/coin.flr'),
    );
    await cachedActor(
      AssetFlare(bundle: rootBundle, name: 'images/success.flr'),
    );
  }

  initFunctions() async {
    await preCache();
    await initializeFlutterFire();
    bool _isLogin = await login(context);
    if (_isLogin == true) {
      Map? userDetails =
          await Provider.of<MyAccount>(context, listen: false).getUserData();
      if (userDetails == null) {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    NewUser(phoneNo: _user!.phoneNumber!, uid: _user!.uid)));
      } else {
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => StreamProvider.value(
                  initialData: getInitialData(),
                  value: CoinsStream(userDetails['uid'], context).getCoin,
                  child: HomeScreen()),
            ));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => PhoneLoginScreen()));
    }
    _showSpinner = false;
  }

  Future initializeFlutterFire() async {
    try {
      await Firebase.initializeApp();
      setState(() {
//        _initialized = true;
//        print('firebase initialized');
      });
    } catch (e) {
      setState(() {
//        _error = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      // progressIndicator: RefreshProgressIndicator(
      //   valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
      // ),
      inAsyncCall: _showSpinner,
      child: Scaffold(
        body: Center(
          child: SizedBox(
              height: 80, width: 80, child: Image.asset("images/logo.png")),
        ),
      ),
    );
  }
}

User? _user;

final FirebaseAuth _auth = FirebaseAuth.instance;

login(BuildContext context) async {
  bool isLogin = false;
  final User? user = _auth.currentUser;
  if (user != null) {
    _user = user;
    final uid = user.uid;
    print('uid $uid');
    Provider.of<MyAccount>(context, listen: false).setUid(uid);
    isLogin = true;
  } else {
    isLogin = false;
  }
  return isLogin;
}
