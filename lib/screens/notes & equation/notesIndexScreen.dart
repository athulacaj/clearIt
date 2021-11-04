import 'package:clearit/utility/provider/adState.dart';
import 'package:clearit/utility/provider/savedDataProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:clearit/utility/loadingWidget/loading.dart';
import 'package:clearit/utility/provider/commonprovider.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:clearit/screens/notes & equation/topicsScreen.dart';

class NotesScreen extends StatefulWidget {
  final List coursesList;
  NotesScreen({required this.coursesList});
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

late List coursesList;
FirebaseFirestore _fireStore = FirebaseFirestore.instance;
bool _showSpinner = false;

class _NotesScreenState extends State<NotesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coursesList = widget.coursesList;
    _showSpinner = false;
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
    List coursesList = widget.coursesList;
    return CoinLoading(
      showSpinner: _showSpinner,
      child: Scaffold(
        appBar: commonAppBar(title: 'Notes & Equations', context: context),
        body: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            children: [
              SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: coursesList.length,
                  itemBuilder: (BuildContext context, int i) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Material(
                        elevation: 2,
                        child: InkWell(
                          onTap: () async {
                            _showSpinner = true;
                            setState(() {});
                            List topicsList = [];
                            DocumentSnapshot<Map> doc = (await _fireStore
                                .collection(
                                    'notes/subjects/all/${coursesList[i]}/subjects')
                                .doc('topics')
                                .get());
                            if (doc.exists) {
                              topicsList = doc.data()?['topicsList'];
                            }
                            print(topicsList);
                            _showSpinner = false;
                            setState(() {});
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TopicsScreen(
                                          topicsList: topicsList,
                                          courseName: coursesList[i],
                                        )));
                          },
                          child: ConstrainedBox(
                            constraints: BoxConstraints(minHeight: 60),
                            child: Container(
                                padding: EdgeInsets.all(8),
                                alignment: Alignment.center,
                                child: Text(coursesList[i])),
                          ),
                        ),
                      ),
                    );
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
        ),
      ),
    );
  }
}
