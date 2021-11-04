import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearit/utility/provider/savedDataProvider.dart';
import 'package:clearit/utility/widgets/ImageView.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:clearit/utility/pdfViewer.dart';

class NotesAndEquationScreen extends StatefulWidget {
  final List<DocumentSnapshot>? notesList;
  final List? savedNotesList; // if data is comming from saved notes
  NotesAndEquationScreen({this.notesList, this.savedNotesList});
  @override
  _NotesAndEquationScreenState createState() => _NotesAndEquationScreenState();
}

List notesList = [];

class _NotesAndEquationScreenState extends State<NotesAndEquationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.notesList != null) {
      notesList = widget.notesList!;
    } else if (widget.notesList != null) {
      notesList = widget.savedNotesList!;
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: commonAppBar(title: 'Topics', context: context),
      body: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (BuildContext context, int i) {
                  return Consumer<SavedDataProvider>(
                    builder: (BuildContext context, provider, Widget? child) {
                      List savedDataList = [];
                      if (provider.savedData["Notes & Equations"] != null) {
                        savedDataList = provider.savedData["Notes & Equations"];
                      }
                      bool isSaved =
                          isInSavedList(savedDataList, notesList[i]['title']);
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Material(
                          elevation: 2,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 80),
                            child: Container(
                              padding: EdgeInsets.all(8),
                              alignment: Alignment.center,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SizedBox(width: 10),
                                      Spacer(),
                                      Expanded(
                                        flex: 6,
                                        child: Text(notesList[i]['title']),
                                      ),
                                      Spacer(),
                                      Expanded(
                                        flex: 3,
                                        child: notesList[i]['pdf'] != null
                                            ? IconButton(
                                                icon: Icon(Icons.picture_as_pdf,
                                                    size: 40),
                                                onPressed: () {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              PdfScreen(
                                                                  url: notesList[
                                                                          i][
                                                                      'pdf'])));
                                                })
                                            : IconButton(
                                                icon:
                                                    Icon(Icons.image, size: 40),
                                                onPressed: () {
                                                  if (notesList[i]['image'] !=
                                                      null) {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                ImageViewScreen(
                                                                  image: notesList[
                                                                          i]
                                                                      ['image'],
                                                                )));
                                                  }
                                                }),
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Material(
                                      elevation: 2,
                                      child: InkWell(
                                          onTap: () {
                                            // Map data = {
                                            //   "title": notesList[i]['title'],
                                            //   "pdf": notesList[i]['pdf'],
                                            //   "image": notesList[i]['pdf'],
                                            // };
                                            Map data = {};
                                            if (widget.notesList != null) {
                                              data = notesList[i]
                                                  .data(); // from home screen
                                            } else {
                                              data = notesList[
                                                  i]; // from saved data
                                            }
                                            if (isSaved) {
                                              print("remove");
                                              Provider.of<SavedDataProvider>(
                                                      context,
                                                      listen: false)
                                                  .removeDataFromList(
                                                      "Notes & Equations",
                                                      notesList[i].data(),
                                                      "title");
                                            } else {
                                              Provider.of<SavedDataProvider>(
                                                      context,
                                                      listen: false)
                                                  .addToList(
                                                      "Notes & Equations",
                                                      notesList[i].data());
                                            }
                                            setState(() {});
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            height: 40,
                                            color: isSaved
                                                ? Colors.blueAccent
                                                : Colors.white,
                                            width: size.width,
                                            child: Text(
                                              isSaved ? 'Saved' : "Save",
                                              style: TextStyle(
                                                  color: isSaved
                                                      ? Colors.white
                                                      : Colors.black),
                                            ),
                                          )),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          ],
        ),
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
