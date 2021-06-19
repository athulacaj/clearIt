import 'package:flutter/material.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';
import 'package:studywithfun/utility/widgets/ImageView.dart';

class DailyWordScreen extends StatefulWidget {
  final Map data;
  DailyWordScreen({@required this.data});
  @override
  _DailyWordScreenState createState() => _DailyWordScreenState();
}

Map data;

class _DailyWordScreenState extends State<DailyWordScreen> {
  @override
  void initState() {
    data = widget.data;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String n = '34783vsD';
    Size size = MediaQuery.of(context).size;
    print('data is $data');
    return Scaffold(
      backgroundColor: Color(0xffDAECF0),
      appBar: commonAppBar(title: 'Daily Word', context: context),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 30),
              data['image'] != null
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ImageViewScreen(
                                      image: data['image'],
                                    )));
                      },
                      child: SizedBox(
                        height: size.height - 100,
                        width: size.width - 20,
                        child: data['image'] != null
                            ? Hero(
                                tag: data['image'],
                                child: Image.network(data['image']))
                            : Container(),
                      ),
                    )
                  : Container(),
              data['word'] != null
                  ? Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 40),
                            Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                  color: Color(0xffFFFEF2),
                                  border: Border.all(
                                      color: Color(0xff4C4C4D), width: 2),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minHeight: 300),
                                child: Column(
                                  children: [
                                    data['word'] != null
                                        ? ConstrainedBox(
                                            constraints: BoxConstraints(
                                                minHeight: 60,
                                                minWidth: size.width),
                                            child: Container(
                                              alignment: Alignment.center,
                                              padding: EdgeInsets.all(4),
                                              child: Text(
                                                data['word'][0].toUpperCase() +
                                                    data['word'].substring(
                                                      1,
                                                    ),
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    Divider(),
                                    data['desc'] != null
                                        ? Text(
                                            data['desc'],
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w400),
                                          )
                                        : Container(),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                                color: Color(0xffFFFEF2),
                                border: Border.all(
                                    color: Color(0xff4C4C4D), width: 2),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(80))),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: SizedBox(
                            height: 60,
                            width: size.width,
                            child: Image.asset(
                              'images/dailyWord/clip.png',
                              fit: BoxFit.fitHeight,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
