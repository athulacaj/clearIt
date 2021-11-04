import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'screens/homeScreen/fmc.dart';
import 'utility/provider/adState.dart';
import 'utility/widgets/otpWidget.dart';
import 'screens/homeScreen/Tabs/sureShort/questionsPage/qusetionAnswerProvider.dart';
import 'splashscreen.dart';
import 'utility/provider/account.dart';
import 'utility/provider/commonprovider.dart';
import 'utility/provider/coinStramProvider.dart';
import 'screens/rapidfire/qusetionAnswerProvider.dart';
import 'utility/provider/savedDataProvider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlareCache.doesPrune = false;
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final initFuture = MobileAds.instance.initialize();
  // TODO Enable ads
  final adState = AdState(initFuture);
  FcmMain.fcmMain();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<CommonProvider>(
        create: (context) => CommonProvider(),
      ),
      ChangeNotifierProvider<MyAccount>(
        create: (context) => MyAccount(),
      ),
      ChangeNotifierProvider<SureShotAnswersProvider>(
        create: (context) => SureShotAnswersProvider(),
      ),
      ChangeNotifierProvider<RapidFireQuestionAnswersProvider>(
        create: (context) => RapidFireQuestionAnswersProvider(),
      ),
      ChangeNotifierProvider<SavedDataProvider>(
        create: (context) => SavedDataProvider(),
      ),
    ],
    child: Provider.value(
      value: adState,
      builder: (context, child) {
        return MyApp();
      },
    ),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Color(0xff7078ff),
        statusBarIconBrightness: Brightness.light));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'ClearIt',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: Color(0xff7f86ff),
          visualDensity: VisualDensity.adaptivePlatformDensity,
          tabBarTheme: TabBarTheme(
              labelColor: Colors.black, unselectedLabelColor: Colors.grey),
        ),
        home: SplashScreenWindow(),
        // initialRoute: HomeScreen.id,
        // routes: {
        //   HomeScreen.id: (context) => HomeScreen(),
        // },
      ),
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling a background message");
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  FcmMain.saveData({"title": notification!.title, "body": notification.body});
}

Future<void> preCache() async {
  await cachedActor(
    AssetFlare(bundle: rootBundle, name: 'images/coin.flr'),
  );
  await cachedActor(
    AssetFlare(bundle: rootBundle, name: 'images/coin.flr'),
  );
}
