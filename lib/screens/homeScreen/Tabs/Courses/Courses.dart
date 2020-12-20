import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/screens/RecentlyAskedQuestions/recentlyAsked.dart';
import 'package:studywithfun/screens/askADoubt/askADoubt.dart';
import 'package:studywithfun/screens/askADoubt/uploadImage.dart';
import 'package:studywithfun/screens/daily%20word/flareDemo.dart';
import 'package:studywithfun/screens/mindMath/mindMath.dart';
import 'package:studywithfun/utility/functions/navigatorFunctions.dart';
import 'package:studywithfun/utility/provider/commonprovider.dart';
import 'extracted/HomeBox.dart';

class Courses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.white, Colors.white])),
        ),
        SingleChildScrollView(
          child: AnimationLimiter(
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  GestureDetector(
                    onTap: () async {
                      await Provider.of<CommonProvider>(context, listen: false)
                          .showSpinner(true);
                      navigatorSlideAnimationFunction(context, AskADoubt());
                    },
                    child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        elevation: 4,
                        child: SizedBox(
                            width: size.width / 1.5,
                            height: size.height / 5.5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                    height: (size.height / 5.5) / 1.95,
                                    width: (size.width / 1.5) / 2,
                                    child:
                                        Image.asset('images/clearit/ask.png')),
                                SizedBox(height: 6),
                                Text('Ask A Doubt')
                              ],
                            ))),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () async {
                          await Provider.of<CommonProvider>(context,
                                  listen: false)
                              .showSpinner(true);
                          navigatorSlideAnimationFunction(
                              context, MindMathScreen());
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: HomeBox(
                              title: 'Mind Math',
                              size: size,
                              image: 'images/clearit/math.png'),
                        ),
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        onTap: () async {
                          await Provider.of<CommonProvider>(context,
                                  listen: false)
                              .showSpinner(true);

                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Demo()));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: HomeBox(
                              title: 'Daily Word',
                              size: size,
                              image: 'images/clearit/dailyWords.png'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        alignment: Alignment.center,
                        child: HomeBox(
                          title: 'Rapid Fire',
                          size: size,
                          image: 'images/clearit/rapidFiore.png',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: HomeBox(
                          title: 'Notes & Equation',
                          size: size,
                          image: 'images/clearit/notes.png',
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: (size.width / 3.5) / 2,
                        color: Colors.white,
                        width: size.width / 3.6,
                      ),
                      SizedBox(width: 10),
                      Container(
                        height: size.width / 3.6,
                        color: Colors.white,
                        width: size.width / 3.6,
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  SizedBox(
                    width: size.width / 1.2,
                    height: 50,
                    child: FlatButton(
                      color: Color(0xffffbf56),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecentlyAsked()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Icon(Icons.live_help, size: 40, color: Colors.white),
                          SizedBox(width: 10),
                          Text(
                            'Recently Asked Questions',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Container(
                    height: 50,
                    width: size.width / 1.2,
                    child: FlatButton(
                      color: Colors.white,
                      onPressed: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.asset(
                              'images/clearit/solutions.png',
                              // color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 10),
                          Text(
                            'View Our Solution',
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                        border: Border.all(color: Color(0xffffbf56))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
