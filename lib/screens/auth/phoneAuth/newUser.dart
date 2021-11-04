import 'package:cached_network_image/cached_network_image.dart';
import 'package:clearit/screens/homeScreen/drawer/profile/uploadProfilePhoto.dart';
import 'package:clearit/splashscreen.dart';
import 'package:clearit/utility/loadingWidget/ModalProgressHudWidget.dart';
import 'package:clearit/utility/provider/coinStramProvider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearit/screens/auth/ExtractedButton.dart';
import 'package:clearit/screens/auth/constants.dart';
import 'package:clearit/screens/homeScreen/homeScreen.dart';
import 'package:clearit/utility/provider/account.dart';

class NewUser extends StatefulWidget {
  final String phoneNo;
  final String uid;
  NewUser({required this.phoneNo, required this.uid});
  @override
  _NewUserState createState() => _NewUserState();
}

bool _showSpinner = false;
String phone = '';
String name = '';
String email = '';

class _NewUserState extends State<NewUser> {
  UploadImage? uploadImage;
  bool isUploading = false;
  String? photoUrl;

  @override
  void initState() {
    uploadImage = UploadImage(callBack, {"uid": widget.uid}, stopSpinner);
    super.initState();
    category = dropDown[0];
  }

  void callBack(String url) {
    isUploading = false;
    photoUrl = url;
    setState(() {});
  }

  void stopSpinner() {
    isUploading = false;
    setState(() {});
  }

  static List dropDown = ['bank', 'psc'];
  String? category = dropDown[0];
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      // progressIndicator: RefreshProgressIndicator(
      //   valueColor: new AlwaysStoppedAnimation<Color>(theme.primaryColorDark),
      // ),
      child: Scaffold(
        // key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              // Flexible(
              //   child: Hero(
              //     tag: 'logo',
              //     child: Container(
              //       height: 110.0,
              //       child: Image.asset('assets/logo.png'),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 20.0,
              ),
              GestureDetector(
                child: photoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: Container(
                          color: Colors.lightBlueAccent,
                          height: 60,
                          width: 60,
                          child: Image.network(
                            photoUrl!,
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    : Icon(CupertinoIcons.profile_circled,
                        size: 100, color: theme.accentColor.withOpacity(0.6)),
                onTap: () {
                  isUploading = true;
                  setState(() {});
                  uploadImage?.uploadImage();
                },
              ),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                obscureText: false,
                onChanged: (value) {
                  name = value;
                  setState(() {});
                  //Do something with the user input.
                },
                style: TextStyle(color: Colors.black),
                decoration: KtextfieldDecoration.copyWith(
                    hintText: 'Enter name',
                    suffixIcon: name.length > 2
                        ? Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.cancel,
                            size: 20,
                            color: Colors.redAccent,
                          )),
              ),
              SizedBox(height: 8.0),
              TextField(
                textAlign: TextAlign.center,
                obscureText: false,
                onChanged: (value) {
                  email = value;
                  setState(() {});
                },
                style: TextStyle(color: Colors.black),
                decoration: KtextfieldDecoration.copyWith(
                    hintText: 'Enter email',
                    suffixIcon: checkEmail('$email')
                        ? Icon(
                            Icons.check_circle_outline,
                            color: Colors.green,
                          )
                        : Icon(
                            Icons.cancel,
                            size: 20,
                            color: Colors.redAccent,
                          )),
              ),
              SizedBox(height: 15.0),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    'Category :',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  DropdownButton<String>(
                      items: dropDown.map((var value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: Container(
                            alignment: Alignment.center,
                            width: (MediaQuery.of(context).size.width / 2) - 50,
                            child: Text(
                              '$value',
                              maxLines: 1,
                            ),
                          ),
                        );
                      }).toList(),
                      value: category,
                      onChanged: (String? value) {
                        int i = 0;
                        print(value);
                        category = value!;

                        setState(() {});
                      }),
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              ExtractedButton(
                text: 'Register',
                colour: checkEmail('$email') && name.length > 2
                    ? Color(0xff7078ff)
                    : Colors.grey.withOpacity(0.5),
                onclick: () async {
                  _showSpinner = true;
                  setState(() {});
                  print(category);
                  if (checkEmail('$email') && name.length > 2) {
                    int dateInMS = DateTime.now().millisecondsSinceEpoch;
                    DocumentReference ref1 = FirebaseFirestore.instance
                        .collection('uid')
                        .doc(widget.uid);

                    DocumentReference ref3 = FirebaseFirestore.instance
                        .collection(
                            'users/byUid/${widget.uid}/category/coinsHistory')
                        .doc('$dateInMS');
                    WriteBatch batch = FirebaseFirestore.instance.batch();
                    Map<String, dynamic> data = {
                      'phone': widget.phoneNo,
                      'name': name,
                      'email': email,
                      'photo': photoUrl,
                      'uid': widget.uid,
                      'coins': 20,
                      'category': category
                    };
                    batch.set(ref1, data);
                    batch.set(ref3, {
                      'coin': 20,
                      'isAdded': true,
                      'date': dateInMS,
                      'title': 'New user reward'
                    });
                    try {
                      await batch.commit();
                      Provider.of<MyAccount>(context, listen: false)
                          .addUser(data);
                      await Future.delayed(Duration(milliseconds: 1000));

                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => SplashScreenWindow()),
                          (Route<dynamic> route) => false);
                    } catch (e) {
                      print('error $e');
                    }

                    _showSpinner = false;
                  }
                  setState(() {});
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}

bool checkPhone(String phone) {
  if (phone.length == 10) {
    return true;
  }
  return false;
}

bool checkEmail(String email) {
  List a = email.split('@');

  if (a.length == 2) {
    if (email.length > 10) {
      if (email.endsWith('.com')) {
        return true;
      }
    }
  }

  return false;
}
