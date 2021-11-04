import 'package:clearit/utility/provider/savedDataProvider.dart';
import 'package:clearit/utility/widgets/ImageView.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DailyWordScreen extends StatefulWidget {
  final Map data;
  DailyWordScreen({required this.data});
  @override
  _DailyWordScreenState createState() => _DailyWordScreenState();
}

late Map data;

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
        child: SingleChildScrollView(child: Consumer<SavedDataProvider>(
            builder: (BuildContext context, provider, Widget? child) {
          List savedDataList = [];
          if (provider.savedData["Daily Word"] != null) {
            savedDataList = provider.savedData["Daily Word"];
            print("saved notes list $data['id']");
            print("id $savedDataList");
          }
          // provider.removeAllData();
          bool isSaved = isInSavedList(savedDataList, data['id']);
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 10),
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
                      child: Stack(
                        children: [
                          Container(
                            height: size.height - 100,
                            width: size.width - 20,
                            alignment: Alignment.center,
                            child: data['image'] != null
                                ? Hero(
                                    tag: data['image'],
                                    child: Image.network(
                                      data['image'],
                                      loadingBuilder: (BuildContext context,
                                          Widget child,
                                          ImageChunkEvent? loadingProgress) {
                                        if (loadingProgress == null)
                                          return child;
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: loadingProgress
                                                        .expectedTotalBytes !=
                                                    null
                                                ? loadingProgress
                                                        .cumulativeBytesLoaded /
                                                    loadingProgress
                                                        .expectedTotalBytes!
                                                : null,
                                          ),
                                        );
                                      },
                                    ))
                                : Container(),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: isSaved
                                  ? Icon(
                                      Icons.favorite,
                                      size: 30,
                                      color: Colors.blueAccent,
                                    )
                                  : Icon(Icons.favorite_border, size: 30),
                              onPressed: () {
                                print(isSaved);
                                if (isSaved) {
                                  print("remove");
                                  Provider.of<SavedDataProvider>(context,
                                          listen: false)
                                      .removeDataFromList(
                                          "Daily Word", data, "id");
                                } else {
                                  Provider.of<SavedDataProvider>(context,
                                          listen: false)
                                      .addToList("Daily Word", data);
                                }
                                setState(() {});
                              },
                            ),
                          ),
                        ],
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
                                              child: Row(
                                                children: [
                                                  Text(
                                                    data['word'][0]
                                                            .toUpperCase() +
                                                        data['word'].substring(
                                                          1,
                                                        ),
                                                    style: TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  IconButton(
                                                    icon: isSaved
                                                        ? Icon(
                                                            Icons.favorite,
                                                            size: 30,
                                                            color: Colors
                                                                .blueAccent,
                                                          )
                                                        : Icon(
                                                            Icons
                                                                .favorite_border,
                                                            size: 30),
                                                    onPressed: () {
                                                      print(isSaved);
                                                      if (isSaved) {
                                                        print("remove");
                                                        Provider.of<SavedDataProvider>(
                                                                context,
                                                                listen: false)
                                                            .removeDataFromList(
                                                                "Daily Word",
                                                                data,
                                                                "word");
                                                      } else {
                                                        Provider.of<SavedDataProvider>(
                                                                context,
                                                                listen: false)
                                                            .addToList(
                                                                "Daily Word",
                                                                data);
                                                      }
                                                      setState(() {});
                                                    },
                                                  ),
                                                ],
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
          );
        })),
      ),
    );
  }
}

bool isInSavedList(List savedDataList, String id) {
  for (Map data in savedDataList) {
    if (data["id"] == id) {
      return true;
    }
  }
  return false;
}
