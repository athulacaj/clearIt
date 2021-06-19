import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/utility/loadingWidget/loading.dart';
import 'package:studywithfun/utility/provider/commonprovider.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';
import 'package:studywithfun/screens/notes & equation/indvidualTopics/Notes&Equation.dart';

class TopicsScreen extends StatefulWidget {
  final List topicsList;
  final String courseName;
  TopicsScreen({this.topicsList, @required this.courseName});
  @override
  _TopicsScreenState createState() => _TopicsScreenState();
}

List topicsList;
FirebaseFirestore _fireStore = FirebaseFirestore.instance;
bool _showSpinner = false;

class _TopicsScreenState extends State<TopicsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    topicsList = widget.topicsList;
    _showSpinner = false;
  }

  @override
  Widget build(BuildContext context) {
    List topicsList = widget.topicsList;
    String image;
    String pdf;
    String title;
    return CoinLoading(
      showSpinner: _showSpinner,
      child: Scaffold(
        appBar: commonAppBar(title: 'Topics', context: context),
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: topicsList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 2,
                        child: InkWell(
                          onTap: () async {
                            _showSpinner = true;
                            setState(() {});
                            List<QueryDocumentSnapshot> notesList = [];
                            QuerySnapshot doc = await _fireStore
                                .collection('notes/topics/${topicsList[i]}')
                                .get();
                            notesList = doc.docs;
                            print(doc.docs);
                            String path =
                                widget.courseName + '/' + topicsList[i];
                            // print(topicsList[i]);
                            _showSpinner = false;
                            setState(() {});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        NotesAndEquationScreen(
                                          path: path,
                                          notesList: notesList,
                                        )));
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 60),
                            child: Container(
                                padding: EdgeInsets.all(8),
                                alignment: Alignment.center,
                                child: Text(topicsList[i])),
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
      ),
    );
  }
}
