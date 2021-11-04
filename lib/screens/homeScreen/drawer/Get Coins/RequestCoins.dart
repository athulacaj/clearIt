import 'package:clearit/utility/loadingWidget/loading.dart';
import 'package:clearit/utility/provider/account.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RequestCoinsScreen extends StatefulWidget {
  const RequestCoinsScreen({Key? key}) : super(key: key);

  @override
  _RequestCoinsScreenState createState() => _RequestCoinsScreenState();
}

bool _showSpinner = false;

class _RequestCoinsScreenState extends State<RequestCoinsScreen> {
  @override
  void initState() {
    super.initState();
    _showSpinner = false;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> user = Provider.of<MyAccount>(context, listen: false)
        .userDetails! as Map<String, dynamic>;
    Size size = MediaQuery.of(context).size;
    return CoinLoading(
      showSpinner: _showSpinner,
      child: Scaffold(
        appBar: commonAppBar(title: "Request Coins", context: context),
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: FirebaseFirestore.instance
              .collection("common/getCoins/request")
              .doc(user['uid'])
              .get(),
          builder: (BuildContext context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.all(18.0),
              child: SizedBox(
                width: size.width - 36,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    !snapshot.data!.exists
                        ? FlatButton(
                            minWidth: size.width - 100,
                            color: Colors.blueAccent,
                            onPressed: () async {
                              _showSpinner = true;
                              setState(() {});
                              user['canceled'] = false;
                              await FirebaseFirestore.instance
                                  .collection("common/getCoins/request")
                                  .doc(user['uid'])
                                  .set(user);
                              _showSpinner = false;
                              setState(() {});
                            },
                            child: Text("Request Coins",
                                style: TextStyle(color: Colors.white)))
                        : Text("You have already requested ",
                            style: TextStyle(fontSize: 17)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
