import 'package:clearit/screens/homeScreen/drawer/services/servicesBrain.dart';
import 'package:clearit/utility/loadingWidget/loading.dart';
import 'package:clearit/utility/provider/commonprovider.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServicesIndexScreen extends StatefulWidget {
  final String title;
  final String id;
  ServicesIndexScreen({required this.title, required this.id});
  @override
  _ServicesIndexScreenState createState() => _ServicesIndexScreenState();
}

List items = [];
bool _showSpinner = false;

class _ServicesIndexScreenState extends State<ServicesIndexScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    _showSpinner = true;
    items = await ServiceBrain().get(widget.id);
    print(items);
    _showSpinner = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CoinLoading(
      showSpinner: _showSpinner,
      child: Scaffold(
        appBar: commonAppBar(title: widget.title, context: context),
        body: Column(
          children: [
            SizedBox(height: 20),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.black26)),
                      height: 40,
                      child: Row(
                        children: [
                          Icon(Icons.circle, size: 10),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              items[index].toString(),
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
