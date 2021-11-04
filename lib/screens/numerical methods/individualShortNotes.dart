import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clearit/utility/widgets/ImageView.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:url_launcher/url_launcher.dart';

class IndividualShortNotes extends StatefulWidget {
  final Map shortNotesData;
  IndividualShortNotes({required this.shortNotesData});
  @override
  _IndividualShortNotesState createState() => _IndividualShortNotesState();
}

late Map shortNotesData;

class _IndividualShortNotesState extends State<IndividualShortNotes> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    shortNotesData = widget.shortNotesData;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: commonAppBar(title: 'Short Notes', context: context),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              SizedBox(height: 25),
              shortNotesData['image'] != null
                  ? Container(
                      width: size.width,
                      height: 250,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ImageViewScreen(
                                        image: shortNotesData['image'],
                                      )));
                        },
                        child: SizedBox(
                          height: 200,
                          width: size.width - 20,
                          child: shortNotesData['image'] != null
                              ? Hero(
                                  tag: shortNotesData['image'],
                                  child: Image.network(shortNotesData['image']))
                              : Container(),
                        ),
                      ),
                    )
                  : Container(),
              SizedBox(height: 25),
              shortNotesData['youtube'] != null
                  ? InkWell(
                      onTap: () async {
                        String _url = "${shortNotesData['youtube']}";
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
              SizedBox(height: 25),
            ],
          ),
        ),
      ),
    );
  }
}
