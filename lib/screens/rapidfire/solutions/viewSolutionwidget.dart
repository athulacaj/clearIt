import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearit/screens/homeScreen/homeScreen.dart';
import 'package:clearit/screens/rapidfire/qusetionAnswerProvider.dart';
import 'package:clearit/utility/widgets/ImageView.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:url_launcher/url_launcher.dart';

class ViewSolutionWidget extends StatelessWidget {
  final int qIndex;
  final List questionsList;
  ViewSolutionWidget({required this.qIndex, required this.questionsList});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Consumer<RapidFireQuestionAnswersProvider>(
        builder: (context, provider, child) {
      return SizedBox(
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 3),
                child: Text(
                  'Q${qIndex + 1}',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
              questionsList[qIndex]['solution'] != null &&
                      questionsList[qIndex]['solution']['image'] != null
                  ? Container(
                      width: size.width,
                      height: 250,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageViewScreen(
                                        image: questionsList[qIndex]['solution']
                                            ['image'],
                                      )));
                        },
                        child: SizedBox(
                          height: 200,
                          width: size.width - 20,
                          child:
                              questionsList[qIndex]['solution']['image'] != null
                                  ? Hero(
                                      tag: questionsList[qIndex]['solution']
                                          ['image'],
                                      child: Image.network(questionsList[qIndex]
                                          ['solution']['image']))
                                  : Container(),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(height: 25),
              questionsList[qIndex]['solution'] != null &&
                      questionsList[qIndex]['solution']['youtube'] != null
                  ? InkWell(
                      onTap: () async {
                        String _url =
                            "${questionsList[qIndex]['solution']['youtube']}";
                        await canLaunch(_url)
                            ? await launch(_url)
                            : throw 'Could not launch $_url';
                      },
                      child: Container(
                        height: 50,
                        width: size.width / 2,
                        alignment: Alignment.center,
                        child: Text(
                          'Youtube Link',
                          style: TextStyle(color: Colors.white),
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xff6369f2),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                      ))
                  : Container(),
              SizedBox(height: 35),
            ],
          ),
        ),
      );
    });
  }
}
