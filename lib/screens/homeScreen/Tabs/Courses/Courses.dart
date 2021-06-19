import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/screens/RecentlyAskedQuestions/RecentlyAskedScreen.dart';
import 'package:studywithfun/screens/askADoubt/askADoubt.dart';
import 'package:studywithfun/screens/askADoubt/uploadImage.dart';
import 'package:studywithfun/screens/daily%20word/flareDemo.dart';
import 'package:studywithfun/screens/mindMath/mindMath.dart';
import 'package:studywithfun/screens/shortNotes/shortNotesIndexScreen.dart';
import 'package:studywithfun/utility/functions/navigatorFunctions.dart';
import 'package:studywithfun/utility/functions/showToastFunction.dart';
import 'package:studywithfun/utility/provider/commonprovider.dart';
import 'extracted/HomeBox.dart';
import 'package:studywithfun/screens/rapidfire/rapidFIreScreen.dart';
import 'package:studywithfun/screens/daily word/dailyWordScreen.dart';
import 'package:studywithfun/screens/notes & equation/notesIndexScreen.dart';
import 'package:studywithfun/screens/viewOurSolution/ViewOurSolutionScreen.dart';
import 'package:studywithfun/screens/daily word/database.dart';

class Courses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    CommonProvider spinnerProvider =
        Provider.of<CommonProvider>(context, listen: false);
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
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
                      await spinnerProvider.showSpinner(true);
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
                          await spinnerProvider.showSpinner(true);
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
                          await spinnerProvider.showSpinner(false);
                          Map dailyWordData =
                              await DailyWordDatabase().getData();
                          print(dailyWordData);
                          spinnerProvider.hideSpinner();

                          if (dailyWordData.isEmpty) {
                            showToast('No word available');
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DailyWordScreen(
                                          data: dailyWordData,
                                        )));
                          }
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
                      GestureDetector(
                        onTap: () async {
                          await spinnerProvider.showSpinner(true);

                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RapidFireScreen()));
                        },
                        child: Container(
                          alignment: Alignment.center,
                          child: HomeBox(
                            title: 'Rapid Fire',
                            size: size,
                            image: 'images/clearit/rapidFiore.png',
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          child: HomeBox(
                            title: 'Notes & Equation',
                            size: size,
                            image: 'images/clearit/notes.png',
                          ),
                        ),
                        onTap: () async {
                          await spinnerProvider.showSpinner(false);

                          List coursesList = (await _fireStore
                                  .collection('notes')
                                  .doc('courses')
                                  .get())
                              .data()['coursesList'];
                          print(coursesList);
                          spinnerProvider.hideSpinner();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => NotesScreen(
                                        coursesList: coursesList,
                                      )));
                        },
                      ),
                      SizedBox(width: 10),
                      GestureDetector(
                        child: Container(
                          alignment: Alignment.center,
                          child: HomeBox(
                            title: 'Short Notes',
                            size: size,
                            image: 'images/shortNotes.png',
                          ),
                        ),
                        onTap: () async {
                          await spinnerProvider.showSpinner(false);
                          //
                          // List coursesList = (await _fireStore
                          //         .collection('notes')
                          //         .doc('courses')
                          //         .get())
                          //     .data()['coursesList'];
                          // print(coursesList);
                          spinnerProvider.hideSpinner();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ShortNotesIndexScreen()));
                        },
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
                                builder: (context) =>
                                    RecentlyAskedQuestionsScreen()));
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
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewOurSolutionScreen()));
                      },
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
