import 'package:flutter/material.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';

import 'individualShortNotes.dart';
import 'shortNotesBrain.dart';

class ShortNotesIndexScreen extends StatefulWidget {
  @override
  _ShortNotesIndexScreenState createState() => _ShortNotesIndexScreenState();
}

List shortNoteList;

class _ShortNotesIndexScreenState extends State<ShortNotesIndexScreen> {
  @override
  void initState() {
    super.initState();
    shortNoteList = ShortNotesBrain().shortNoteList;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: commonAppBar(title: 'Short Notes', context: context),
      body: Column(
        children: [
          SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: shortNoteList.length,
              itemBuilder: (BuildContext context, int index) {
                return Material(
                  elevation: 3,
                  child: InkWell(
                    onTap: () {
                      showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: size.height - 120,
                              child: IndividualShortNotes(
                                  shortNotesData: shortNoteList[index]),
                            );
                          });
                      // Navigator.push(
                      //     context,
                      //     MaterialPageRoute(
                      //         builder: (context) => IndividualShortNotes(
                      //             shortNotesData: shortNoteList[index])));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(minHeight: 40),
                        child: Container(
                            alignment: Alignment.centerLeft,
                            child: Text("${index + 1} )  " +
                                shortNoteList[index]['title'])),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
