import 'package:audioplayers/audioplayers.dart';
import 'package:clearit/utility/widgets/ImageView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearit/utility/functions/showToastFunction.dart';
import 'package:clearit/utility/loadingWidget/loading.dart';
import 'package:clearit/utility/provider/account.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:clearit/utility/pdfViewer.dart';
import 'package:clearit/utility/widgets/ExtractedButton.dart';
import 'package:clearit/utility/widgets/audioPlayerWidget.dart';
import 'package:clearit/utility/functions/coinDectectionFunction.dart';
import 'database.dart';

class IndividualQuestionsScreen extends StatefulWidget {
  final List detailsList;
  final String docId;
  final bool havePermission;
  IndividualQuestionsScreen(
      {required this.detailsList,
      required this.docId,
      required this.havePermission});
  @override
  _IndividualQuestionsScreenState createState() =>
      _IndividualQuestionsScreenState();
}

List detailsList = [];
bool purchased = false;
bool havePermission = false;
bool _showSpinner = false;

class _IndividualQuestionsScreenState extends State<IndividualQuestionsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    havePermission = widget.havePermission;
    detailsList = widget.detailsList;
    _showSpinner = false;
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return CoinLoading(
      showSpinner: _showSpinner,
      child: Scaffold(
        appBar:
            commonAppBar(title: 'Recently Asked Questions', context: context),
        backgroundColor: Colors.white.withOpacity(.95),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: detailsList.length,
                  itemBuilder: (BuildContext context, int i) {
                    Map details = detailsList[i];
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 9),
                      // height: size.height - 80,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.all(Radius.circular(4))),
                      // padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                SizedBox(height: 10),
                                details['query'] != null
                                    ? Container(
                                        width: size.width,
                                        decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: Colors.black12,
                                                  width: 1)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6, vertical: 8),
                                          child: Text(
                                            '${details['query']}',
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      )
                                    : Container(),
                                SizedBox(height: 12),
                                details['imageUrl'] != null
                                    ? GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ImageViewScreen(
                                                        image:
                                                            details['imageUrl'],
                                                      )));
                                        },
                                        child: Container(
                                          width: size.width,
                                          alignment: Alignment.topLeft,
                                          height: 150,
                                          child: Hero(
                                            tag: details['imageUrl'],
                                            child: Image.network(
                                              details['imageUrl'],
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          details['solution'] != null && havePermission
                              ? Container(
                                  padding: EdgeInsets.all(12),
                                  color: Colors.green.withOpacity(0.15),
                                  width: double.infinity,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        // SizedBox(height: 40),
                                        // Divider(),
                                        Text(
                                          'solution',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600),
                                        ),
                                        SizedBox(height: 10),
                                        details['solution']['text'] != ''
                                            ? Material(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      12.0),
                                                  child: Text(
                                                    details['solution']['text'],
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                ),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(6)),
                                              )
                                            : Container(),
                                        SizedBox(height: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: new List.generate(
                                              details['solution']['attachments']
                                                  .length, (index) {
                                            Map attachment = details['solution']
                                                ['attachments'][index];
                                            return Container(
                                              alignment: Alignment.centerRight,
                                              height: 100,
                                              width: double.infinity,
                                              child: attachment['type'] ==
                                                          'image' ||
                                                      attachment['type'] ==
                                                          'camera'
                                                  ? GestureDetector(
                                                      onTap: () {
                                                        Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder:
                                                                    (context) =>
                                                                        ImageViewScreen(
                                                                          image:
                                                                              attachment['url'],
                                                                        )));
                                                      },
                                                      child: Image.network(
                                                          attachment['url']))
                                                  : attachment['type'] ==
                                                              'audio' ||
                                                          attachment['type'] ==
                                                              'mic'
                                                      ? AudioWidget(
                                                          url:
                                                              attachment['url'])
                                                      : IconButton(
                                                          icon: Icon(
                                                              Icons
                                                                  .picture_as_pdf,
                                                              size: 40),
                                                          onPressed: () {
                                                            Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                    builder: (context) =>
                                                                        PdfScreen(
                                                                            url:
                                                                                attachment['url'])));
                                                          }),
                                            );
                                          }),
                                        )
                                      ]),
                                )
                              : Container(),
                        ],
                      ),
                    );
                  },
                ),
              ),
              !havePermission
                  ? SizedBox(
                      width: size.width,
                      height: 90,
                      child: ExtractedButton(
                        textColour: Colors.blue,
                        text: "Get Solution",
                        onclick: () async {
                          _showSpinner = true;
                          setState(() {});

                          Map user =
                              Provider.of<MyAccount>(context, listen: false)
                                  .userDetails!;
                          // print(user);
                          await coinDetectFunction(context, () async {
                            try {
                              await RecentlyAskedQuestionsDatabase()
                                  .saveUidToQuestion(widget.docId, user['uid']);
                              havePermission = true;
                              setState(() {});
                              showToast('Success');
                            } catch (e) {
                              showToast('Something went wrong ...');
                            }
                          });
                          _showSpinner = false;
                          setState(() {});
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void deactivate() async {
    // TODO: implement deactivate

    super.deactivate();
  }
}

BoxDecoration contaionerBlackOutlineButtonDecoration = BoxDecoration(
  border: Border.all(color: Colors.black),
  borderRadius: BorderRadius.all(Radius.circular(4)),
);
