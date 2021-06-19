import 'package:flare_flutter/flare_cache.dart';
import 'package:flare_flutter/provider/asset_flare.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'screens/homeScreen/Tabs/sureShort/questionsPage/qusetionAnswerProvider.dart';
import 'splashscreen.dart';
import 'utility/provider/account.dart';
import 'utility/provider/commonprovider.dart';
import 'utility/provider/coinStramProvider.dart';
import 'screens/rapidfire/qusetionAnswerProvider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  FlareCache.doesPrune = false;

  preCache().then((_) {
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
        // StreamProvider(
        //   create: (BuildContext context) =>
        //       FirebaseServices().getUsersCoin('UPeQoO4eY6OAwLGtHoULKAE6oEi1'),
        // ),
        // StreamProvider<CoinsClass>.value(value: CoinsStream('fgdfg').getCoin)
      ],
      child: MyApp(),
    ));
  });
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

Future<void> preCache() async {
  await cachedActor(
    AssetFlare(bundle: rootBundle, name: 'images/coin.flr'),
  );
}
