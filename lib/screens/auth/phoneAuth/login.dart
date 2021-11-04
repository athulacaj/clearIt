import 'package:clearit/screens/auth/ExtractedButton.dart';
import 'package:clearit/utility/loadingWidget/ModalProgressHudWidget.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:country_pickers/country.dart';

import 'OtpAuthClass.dart';

class PhoneLoginScreen extends StatefulWidget {
  static String id = 'Login_Screen';

  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  Country _selectedDialogCountry =
      CountryPickerUtils.getCountryByPhoneCode('91');

  final _phoneController = TextEditingController();
  bool _showSpinner = false;
  late OtpAuthClass _otpAuthClass;
  @override
  void initState() {
    _showSpinner = false;
    super.initState();
    _otpAuthClass = new OtpAuthClass(
        context: context,
        controlSpinner: (bool isSpinner) {
          _showSpinner = isSpinner;
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      child: Scaffold(
          body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: size.height - 30,
            width: size.width,
            padding: EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Hero(
                        tag: 'logo',
                        child: Container(
                          child: Image.asset('images/logo.png'),
                          height: 130.0,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 68,
                            child: Stack(
                              children: [
                                FlatButton(
                                  onPressed: _openCountryPickerDialog,
                                  child: Text(
                                      '+${_selectedDialogCountry.phoneCode}'),
                                ),
                                Positioned(
                                    bottom: 15,
                                    right: 0,
                                    child: Icon(Icons.arrow_drop_down)),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: (size.width - 92) - 70,
                            child: Container(
                              height: 50,
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    disabledBorder: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        left: 15,
                                        bottom: 11,
                                        top: 11,
                                        right: 15),
                                    hintText: "Mobile Number"),
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(
                          height: 1,
                          width: (size.width - 92) - 70 + 68,
                          color: Colors.black12),
                      SizedBox(
                        height: 5,
                      ),
                      ExtractedButton(
                        text: 'Login',
                        colour: Color(0xff7078ff),
                        onclick: () async {
                          final phone = _phoneController.text.trim();
                          print(phone);
                          _otpAuthClass.loginUser(
                              countryCode: _selectedDialogCountry.phoneCode,
                              phone: phone);
                        },
                      ),
                      SizedBox(height: 25),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.purple),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(10.0),
            searchCursorColor: Colors.purpleAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            // title: Text('Select your phone code'),
            onValuePicked: (Country country) =>
                setState(() => _selectedDialogCountry = country),
            itemBuilder: _buildDialogItem,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('IN'),
              CountryPickerUtils.getCountryByIsoCode('AE'),
              CountryPickerUtils.getCountryByIsoCode('SA'),
              CountryPickerUtils.getCountryByIsoCode('QA'),
            ],
          ),
        ),
      );
  Widget _buildDialogItem(Country country) => SizedBox(
        height: 35,
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            // SizedBox(width: 8.0),
            // Text("+${country.phoneCode}"),
            SizedBox(width: 8.0),
            Flexible(child: Text(country.name))
          ],
        ),
      );
}
