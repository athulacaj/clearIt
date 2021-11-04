import 'package:clearit/utility/provider/adState.dart';
import 'package:clearit/utility/provider/savedDataProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'individualShortNotes.dart';

class ShortNotesIndexScreen extends StatefulWidget {
  final List<QueryDocumentSnapshot>? shortNoteList;
  final List? savedNotesList; // if data is comming from saved notes

  ShortNotesIndexScreen.NumericalMethodsScreen(
      {this.shortNoteList, this.savedNotesList});
  @override
  _ShortNotesIndexScreenState createState() => _ShortNotesIndexScreenState();
}

late List shortNoteList;

class _ShortNotesIndexScreenState extends State<ShortNotesIndexScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.shortNoteList != null) {
      shortNoteList = widget.shortNoteList!;
    } else {
      shortNoteList = widget.savedNotesList!;
    }
  }

  BannerAd? banner;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final adstate = Provider.of<AdState>(context, listen: true);
    adstate.loadInterstitialAd(adstate.videoInterstitialAdUnnit);
    adstate.initialization.then((status) {
      setState(() {
        banner = BannerAd(
            size: AdSize.banner,
            adUnitId: adstate.getBannerAdUnnit,
            listener: adstate.listener,
            request: AdRequest())
          ..load();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: commonAppBar(title: 'Numerical Methods', context: context),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: shortNoteList.length,
              itemBuilder: (BuildContext context, int index) {
                return Consumer<SavedDataProvider>(
                    builder: (BuildContext context, provider, Widget? child) {
                  List savedDataList = [];
                  if (provider.savedData["Short Notes"] != null) {
                    savedDataList = provider.savedData["Short Notes"];
                    print("saved notes list $savedDataList");
                  }
                  bool isSaved = isInSavedList(
                      savedDataList, shortNoteList[index]['title']);

                  return Material(
                    elevation: 3,
                    child: InkWell(
                      onTap: () {
                        showModalBottomSheet<void>(
                            isScrollControlled: true,
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                height: size.height - 30,
                                child: IndividualShortNotes(
                                    shortNotesData: widget.shortNoteList != null
                                        ? shortNoteList[index].data()
                                        : shortNoteList[index]),
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: ConstrainedBox(
                          constraints: BoxConstraints(minHeight: 40),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text("${index + 1} ) " +
                                        shortNoteList[index]['title'])),
                              ),
                              IconButton(
                                icon: isSaved
                                    ? Icon(
                                        Icons.favorite,
                                        size: 30,
                                        color: Colors.blueAccent,
                                      )
                                    : Icon(Icons.favorite_border, size: 30),
                                onPressed: () {
                                  Map data = {};
                                  if (widget.shortNoteList != null) {
                                    data = shortNoteList[index]
                                        .data(); // from home screen
                                  } else {
                                    data =
                                        shortNoteList[index]; // from saved data
                                  }
                                  if (isSaved) {
                                    print("remove");
                                    Provider.of<SavedDataProvider>(context,
                                            listen: false)
                                        .removeDataFromList(
                                            "Short Notes", data, "title");
                                  } else {
                                    Provider.of<SavedDataProvider>(context,
                                            listen: false)
                                        .addToList("Short Notes", data);
                                  }
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                });
              },
            ),
          ),
          Container(
            color: Colors.white,
            height: 50,
            child: banner == null ? Container() : AdWidget(ad: banner!),
          ),
        ],
      ),
    );
  }
}

bool isInSavedList(List savedDataList, String title) {
  for (Map data in savedDataList) {
    if (data["title"] == title) {
      return true;
    }
  }
  return false;
}
