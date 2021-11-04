import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:clearit/utility/pdfViewer.dart';
import 'package:clearit/utility/widgets/audioPlayerWidget.dart';
import 'package:clearit/utility/widgets/ImageView.dart';

class IndividualQuestionsScreen extends StatefulWidget {
  final List detailsList;
  IndividualQuestionsScreen({required this.detailsList});
  @override
  _IndividualQuestionsScreenState createState() =>
      _IndividualQuestionsScreenState();
}

List detailsList = [];

class _IndividualQuestionsScreenState extends State<IndividualQuestionsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    detailsList = widget.detailsList;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commonAppBar(title: 'View Our Solution', context: context),
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
                        details['solution'] != null
                            ? Container(
                                padding: EdgeInsets.all(12),
                                width: double.infinity,
                                color: Colors.green.withOpacity(0.15),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        'solution',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 20),
                                      details['solution']['text'] != ''
                                          ? Material(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(6)),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(12.0),
                                                child: Text(
                                                  details['solution']['text'],
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(height: 10),
                                      // Column(
                                      //   crossAxisAlignment:
                                      //       CrossAxisAlignment.end,
                                      //   children: new List.generate(
                                      //       details['solution']['attachments']
                                      //           .length, (index) {
                                      //     Map attachment = details['solution']
                                      //         ['attachments'][index];
                                      //     return Container(
                                      //       alignment: Alignment.centerRight,
                                      //       height: 100,
                                      //       width: double.infinity,
                                      //       child: attachment['type'] == 'image'
                                      //           ? GestureDetector(
                                      //               onTap: () {
                                      //                 Navigator.push(
                                      //                     context,
                                      //                     MaterialPageRoute(
                                      //                         builder: (context) =>
                                      //                             ImageViewScreen(
                                      //                               image: attachment[
                                      //                                   'url'],
                                      //                             )));
                                      //               },
                                      //               child: Image.network(
                                      //                   attachment['url']))
                                      //           : attachment['type'] == 'audio'
                                      //               ? AudioWidget(
                                      //                   url: attachment['url'])
                                      //               : IconButton(
                                      //                   icon: Icon(
                                      //                       Icons
                                      //                           .picture_as_pdf,
                                      //                       size: 40),
                                      //                   onPressed: () {
                                      //                     Navigator.push(
                                      //                         context,
                                      //                         MaterialPageRoute(
                                      //                             builder: (context) =>
                                      //                                 PdfScreen(
                                      //                                     url: attachment[
                                      //                                         'url'])));
                                      //                   }),
                                      //     );
                                      //   }),
                                      // )
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
                                                              builder: (context) =>
                                                                  ImageViewScreen(
                                                                    image: attachment[
                                                                        'url'],
                                                                  )));
                                                    },
                                                    child: Image.network(
                                                        attachment['url']))
                                                : attachment['type'] ==
                                                            'audio' ||
                                                        attachment['type'] ==
                                                            'mic'
                                                    ? AudioWidget(
                                                        url: attachment['url'])
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
                                                                          url: attachment[
                                                                              'url'])));
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
          ],
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
