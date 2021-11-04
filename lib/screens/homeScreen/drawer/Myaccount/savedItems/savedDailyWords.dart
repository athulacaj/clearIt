import 'package:clearit/screens/daily%20word/dailyWordScreen.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:flutter/material.dart';

class SavedDailyWords extends StatefulWidget {
  final List savedWordsList;
  SavedDailyWords({required this.savedWordsList});

  @override
  _SavedDailyWordsState createState() => _SavedDailyWordsState();
}

class _SavedDailyWordsState extends State<SavedDailyWords> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: commonAppBar(title: "Saved Word", context: context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.savedWordsList.length,
                itemBuilder: (BuildContext context, int index) {
                  Map data = widget.savedWordsList[index];
                  String? word = data['word'];
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DailyWordScreen(
                                      data: data,
                                    )));
                      },
                      child: Container(
                        height: 50,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            border: Border.all(color: Colors.black38)),
                        child: word != null
                            ? Text(word)
                            : Image.network(data['image']),
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
}
