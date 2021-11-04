import 'package:clearit/screens/homeScreen/drawer/Get%20Coins/Promocode/promoBrain.dart';
import 'package:clearit/utility/coin.dart';
import 'package:clearit/utility/functions/showToastFunction.dart';
import 'package:clearit/utility/loadingWidget/loading.dart';
import 'package:clearit/utility/provider/account.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PromoCodeScreen extends StatefulWidget {
  const PromoCodeScreen({Key? key}) : super(key: key);

  @override
  _PromoCodeScreenState createState() => _PromoCodeScreenState();
}

late TextEditingController textEditingController;
String result = '';
bool _showSpinner = false;

class _PromoCodeScreenState extends State<PromoCodeScreen> {
  @override
  void initState() {
    textEditingController = new TextEditingController();
    result = '';
    super.initState();
    _showSpinner = false;
  }

  @override
  Widget build(BuildContext context) {
    int coins = Provider.of<MyAccount>(context, listen: true).coins;
    Size size = MediaQuery.of(context).size;
    return CoinLoading(
      showSpinner: _showSpinner,
      child: Scaffold(
        appBar: commonAppBar(title: "Promocodes", context: context),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Material(
                    color: Colors.white,
                    elevation: 2,
                    child: Container(
                        alignment: Alignment.center,
                        height: 50,
                        width: double.infinity,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Total Coins : $coins',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            coinBuilder(20),
                          ],
                        ))),
              ),
              SizedBox(height: 20),
              Spacer(),
              TextField(
                decoration: dec,
                controller: textEditingController,
                onChanged: (value) {
                  result = '';
                  setState(() {});
                },
              ),
              Flexible(
                child: SizedBox(height: 10),
              ),
              result != ''
                  ? Text(
                      result,
                      style: TextStyle(
                          color: result == "Successfully Applied"
                              ? Colors.green
                              : Colors.redAccent),
                    )
                  : Container(),
              SizedBox(height: 30),
              FlatButton(
                  minWidth: MediaQuery.of(context).size.width - 150,
                  color: Color(0xff7078ff),
                  onPressed: () async {
                    _showSpinner = true;
                    setState(() {});
                    String promocode = textEditingController.text;
                    result =
                        await PromocodeBrain(context).checkPromocode(promocode);
                    _showSpinner = false;
                    setState(() {});
                    // showToast(result);
                  },
                  child: Text(
                    "Submit",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration dec = InputDecoration(
      border: new OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.blue)),
      // hintText: 'Enter promocode',
      labelText: 'Enter promocode',
      prefixText: ' ',
      suffixStyle: const TextStyle(color: Colors.green));
}
