import 'package:clearit/screens/mindMath/MindMathBrain.dart';
import 'package:clearit/screens/numerical%20methods/shortNotesBrain.dart';
import 'package:clearit/screens/numerical%20methods/shortNotesIndexScreen.dart';
import 'package:clearit/screens/rapidfire/RapidFireDatabaseManager.dart';
import 'package:clearit/screens/rapidfire/qusetionAnswerProvider.dart';
import 'package:clearit/utility/functions/errorHandleFUnction.dart';
import 'package:clearit/utility/provider/adState.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:provider/provider.dart';
import 'package:clearit/screens/RecentlyAskedQuestions/RecentlyAskedScreen.dart';
import 'package:clearit/screens/askADoubt/askADoubt.dart';
import 'package:clearit/screens/askADoubt/uploadImage.dart';
import 'package:clearit/screens/daily%20word/flareDemo.dart';
import 'package:clearit/screens/mindMath/mindMath.dart';
import 'package:clearit/utility/functions/navigatorFunctions.dart';
import 'package:clearit/utility/functions/showToastFunction.dart';
import 'package:clearit/utility/provider/commonprovider.dart';
import 'extracted/HomeBox.dart';
import 'package:clearit/screens/rapidfire/rapidFIreScreen.dart';
import 'package:clearit/screens/daily word/dailyWordScreen.dart';
import 'package:clearit/screens/notes & equation/notesIndexScreen.dart';
import 'package:clearit/screens/viewOurSolution/ViewOurSolutionScreen.dart';
import 'package:clearit/screens/daily word/database.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    CommonProvider spinnerProvider =
        Provider.of<CommonProvider>(context, listen: false);
    FirebaseFirestore _fireStore = FirebaseFirestore.instance;
    return Stack(
      children: [
        Container(
          height: size.height - 70,
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 375),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  SizedBox(height: 10),
                  GestureDetector(
                    onTap: () async {
                      await spinnerProvider.showSpinner(true);
                      navigatorSlideAnimationFunction(context, AskADoubt(),
                          isReplace: false);
                    },
                    child: Material(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        elevation: 4,
                        color: Colors.white,
                        child: CustomPaint(
                          painter: ShapePainter(8),
                          child: SizedBox(
                              width: size.width / 1.5,
                              height: size.height / 5.8,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: (size.height / 5.8) / 1.95,
                                      width: (size.width / 1.5) / 2,
                                      child: Image.asset(
                                          'images/clearit/ask.png')),
                                  SizedBox(height: 6),
                                  Text(
                                    'Ask A Doubt',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xff7078ff)),
                                  )
                                ],
                              )),
                        )),
                  ),
                  SizedBox(height: 10),
                  Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 60),
                          Container(
                            decoration: BoxDecoration(
                                // color: Color(0xff6EA1D6).withOpacity(0.4),
                                color: Colors.blueAccent.withOpacity(0.4),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(200),
                                    topLeft: Radius.circular(0))),
                            height: (size.height - 201 - (size.height / 5.5)),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  try {
                                    await spinnerProvider.showSpinner(false);

                                    List questions =
                                        await MindMathBrain().getData();

                                    spinnerProvider.hideSpinner();
                                    if (questions.isEmpty) {
                                      showToast("no questions available");
                                    } else {
                                      navigatorSlideAnimationFunction(
                                          context, MindMathScreen(questions));
                                    }
                                  } catch (e) {
                                    spinnerProvider.hideSpinner();
                                    showToast("something went wrong try again");

                                    print(e);
                                  }
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
                                  try {
                                    await spinnerProvider.showSpinner(false);
                                    final adstate = Provider.of<AdState>(
                                        context,
                                        listen: false);
                                    await Future.delayed(
                                        Duration(milliseconds: 5500));
                                    // await adstate.showInterstitialAd(
                                    //     adstate.getInterstitialAdUnnit);
                                    Map dailyWordData =
                                        await DailyWordDatabase().getData();
                                    print(dailyWordData);
                                    spinnerProvider.hideSpinner();

                                    if (dailyWordData.isEmpty) {
                                      await Future.delayed(
                                          Duration(milliseconds: 500));
                                      showToast('Not available');
                                    } else {
                                      navigatorSlideAnimationFunction(
                                          context,
                                          DailyWordScreen(
                                            data: dailyWordData,
                                          ));
                                    }
                                  } catch (e) {
                                    spinnerProvider.hideSpinner();
                                    showToast("something went wrong try again");
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
                                  try {
                                    Provider.of<RapidFireQuestionAnswersProvider>(
                                            context,
                                            listen: false)
                                        .answeredList = [];
                                    await spinnerProvider.showSpinner(false);

                                    Map? data =
                                        await RapidFireManger.getData(context);
                                    String id =
                                        await getSavedRapidFireId(context);
                                    if (data == null) {
                                      showToast("Not available Right now");
                                    } else {
                                      navigatorSlideAnimationFunction(
                                          context,
                                          RapidFireScreen(
                                            testDetails: data,
                                            id: id,
                                          ));
                                    }
                                  } catch (e) {
                                    spinnerProvider.hideSpinner();
                                    showToast("something went wrong try again");
                                  }
                                  spinnerProvider.hideSpinner();
                                  // saveData();
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
                                  try {
                                    await spinnerProvider.showSpinner(false);

                                    List coursesList = (await _fireStore
                                            .collection('notes')
                                            .doc('courses')
                                            .get())
                                        .data()!['coursesList'];
                                    print(coursesList);
                                    spinnerProvider.hideSpinner();
                                    navigatorSlideAnimationFunction(
                                        context,
                                        NotesScreen(
                                          coursesList: coursesList,
                                        ));
                                  } catch (e) {
                                    spinnerProvider.hideSpinner();
                                    showToast("something went wrong try again");
                                  }
                                },
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: HomeBox(
                                    title: 'Numerical Methods',
                                    size: size,
                                    image: 'images/shortNotes.png',
                                  ),
                                ),
                                onTap: () async {
                                  try {
                                    await spinnerProvider.showSpinner(false);
                                    List<QueryDocumentSnapshot> shortNoteList =
                                        await ShortNotesBrain().getData();

                                    navigatorSlideAnimationFunction(
                                        context,
                                        ShortNotesIndexScreen
                                            .NumericalMethodsScreen(
                                                shortNoteList: shortNoteList));
                                    spinnerProvider.hideSpinner();
                                  } catch (e) {
                                    spinnerProvider.hideSpinner();
                                    showToast("something went wrong try again");
                                    print(e);
                                  }
                                },
                              ),
                              SizedBox(width: 10),
                              GestureDetector(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: HomeBox(
                                    title: 'Recently Asked',
                                    size: size,
                                    image: 'images/clearit/recentlyAsked.png',
                                  ),
                                ),
                                onTap: () async {
                                  try {
                                    spinnerProvider.hideSpinner();
                                    final adstate = Provider.of<AdState>(
                                        context,
                                        listen: false);
                                    adstate.showInterstitialAd(
                                        adstate.videoInterstitialAdUnnit);
                                    navigatorSlideAnimationFunction(context,
                                        RecentlyAskedQuestionsScreen());
                                  } catch (e) {
                                    spinnerProvider.hideSpinner();
                                    showToast("something went wrong try again");
                                    print(e);
                                  }
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Container(
                            height: 50,
                            width: size.width / 1.2,
                            child: FlatButton(
                              color: Colors.white,
                              onPressed: () async {
                                final adstate = Provider.of<AdState>(context,
                                    listen: false);

                                adstate.showInterstitialAd(
                                    adstate.getInterstitialAdUnnit);
                                navigatorSlideAnimationFunction(
                                    context, ViewOurSolutionScreen());
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
                                    style: TextStyle(
                                        color: Colors.blueGrey.shade900),
                                  ),
                                ],
                              ),
                            ),
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xffffbf56))),
                          ),
                          SizedBox(height: 60),
                        ],
                      ),
                    ],
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
