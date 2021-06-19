import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/utility/provider/savedDataProvider.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';
import 'package:studywithfun/utility/pdfViewer.dart';

class NotesAndEquationScreen extends StatefulWidget {
  final String path;
  final List<DocumentSnapshot> notesList;
  NotesAndEquationScreen({this.path, this.notesList});
  @override
  _NotesAndEquationScreenState createState() => _NotesAndEquationScreenState();
}

List<DocumentSnapshot> notesList = [];

class _NotesAndEquationScreenState extends State<NotesAndEquationScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    notesList = widget.notesList;
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
                                                          PdfScreen()));
                                            })
                                        : IconButton(
                                            icon: Icon(Icons.image, size: 40),
                                            onPressed: () {}),
                                  ),
                                ],
                              ),
                              Divider(),
                              TextButton(
                                  onPressed: () {
                                    Provider.of<SavedDataProvider>(context,
                                            listen: false)
                                        .addToList({'path': ''});
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    height: 40,
                                    color: Colors.blue,
                                    width: size.width,
                                    child: Text(
                                      'Save',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ))
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
  //
  // List notesList = [
  //   {
  //     'title': 'notes 1',
  //     'image': null,
  //     'pdf':
  //         'https://firebasestorage.googleapis.com/v0/b/clearit-1b35b.appspot.com/o/hw.pdf?alt=media&token=864191fb-e840-4d2e-a8c5-a95df14e529d'
  //   }
  // ];
}
