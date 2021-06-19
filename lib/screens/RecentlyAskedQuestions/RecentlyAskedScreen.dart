import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/utility/provider/account.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'individualQuestion.dart';

class RecentlyAskedQuestionsScreen extends StatefulWidget {
  @override
  _ViewOurSolutionScreenState createState() => _ViewOurSolutionScreenState();
}

class _ViewOurSolutionScreenState extends State<RecentlyAskedQuestionsScreen> {
  bool loading = false;
  Map user;
  int coins = 0;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    user = Provider.of<MyAccount>(context, listen: false).userDetails;
    loading = false;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    coins = Provider.of<MyAccount>(context, listen: true).coins;
    Size size = MediaQuery.of(context).size;
    return Consumer<MyAccount>(
      builder: (context, myAccount, child) {
        return ModalProgressHUD(
          inAsyncCall: loading,
          child: Scaffold(
            appBar: commonAppBar(
                title: 'Recently Asked Questions', context: context),
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: _firestore
                            .collection('askDoubt')
                            .where('isReplied', isEqualTo: true)
                            .limit(10)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          List<DocumentSnapshot> historyList =
                              snapshot.data.docs;
                          print(user['uid']);
                          return ListView.builder(
                              itemCount: historyList.length,
                              itemBuilder: (context, int i) {
                                Map details = historyList[i].data();
                                List usersHavePermission = details['usersList'];
                                bool havePermission =
                                    usersHavePermission.contains(user['uid']);
                                return Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  IndividualQuestionsScreen(
                                                    detailsList:
                                                        details['queryDetails'],
                                                    docId: historyList[i].id,
                                                    havePermission:
                                                        havePermission,
                                                  )));
                                    },
                                    // onTap: showQuestionBottomSheet(
                                    //     context, size, details),
                                    child: Material(
                                      elevation: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 8),
                                        child: ConstrainedBox(
                                          constraints:
                                              BoxConstraints(minHeight: 60),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  details['queryDetails'][0]
                                                              ['imageUrl'] !=
                                                          null
                                                      ? SizedBox(
                                                          width: 70,
                                                          height: 70,
                                                          child:
                                                              FullScreenWidget(
                                                            child: Center(
                                                              child: Hero(
                                                                tag: details[
                                                                        'queryDetails']
                                                                    [
                                                                    0]['query'],
                                                                child: Image
                                                                    .network(
                                                                  details['queryDetails']
                                                                          [0][
                                                                      'imageUrl'],
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      : Container(),
                                                  SizedBox(width: 10),
                                                  Expanded(
                                                    child: Text(
                                                        '${details['queryDetails'][0]['query']}'),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(''),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
