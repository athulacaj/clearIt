import 'package:clearit/screens/daily%20word/dailyWordScreen.dart';
import 'package:clearit/screens/notes%20&%20equation/indvidualTopics/Notes&Equation.dart';
import 'package:clearit/screens/numerical%20methods/shortNotesIndexScreen.dart';
import 'package:clearit/utility/functions/navigatorFunctions.dart';
import 'package:clearit/utility/provider/savedDataProvider.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'savedDailyWords.dart';

class SavedItemsScreen extends StatefulWidget {
  @override
  _SavedItemsScreenState createState() => _SavedItemsScreenState();
}

class _SavedItemsScreenState extends State<SavedItemsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: commonAppBar(title: 'Saved Items', context: context),
      body: Column(
        children: [
          Expanded(
            child: Consumer<SavedDataProvider>(
              builder: (BuildContext context, provider, Widget? child) {
                List keys = provider.savedData.keys.toList();
                return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: provider.savedData.keys.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      elevation: 3,
                      child: InkWell(
                        onTap: () {
                          if (keys[index] == "Notes & Equations") {
                            navigatorSlideAnimationFunction(
                                context,
                                NotesAndEquationScreen(
                                  savedNotesList:
                                      provider.savedData["Notes & Equations"],
                                ));
                          } else if (keys[index] == "Short Notes") {
                            navigatorSlideAnimationFunction(
                                context,
                                ShortNotesIndexScreen.NumericalMethodsScreen(
                                  savedNotesList:
                                      provider.savedData["Short Notes"],
                                ));
                          } else if (keys[index] == "Daily Word") {
                            print(keys[index]);
                            print(provider.savedData["Daily Word"]);
                            navigatorSlideAnimationFunction(
                                context,
                                SavedDailyWords(
                                  savedWordsList:
                                      provider.savedData["Daily Word"],
                                ));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 40),
                            child: Container(
                                alignment: Alignment.centerLeft,
                                child: Text(keys[index])),
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
    );
  }
}
