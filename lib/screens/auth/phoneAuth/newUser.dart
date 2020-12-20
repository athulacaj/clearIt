import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/screens/auth/ExtractedButton.dart';
import 'package:studywithfun/screens/auth/constants.dart';
import 'package:studywithfun/screens/auth/phoneAuth/uploadProfilePhoto.dart';
import 'package:studywithfun/screens/homeScreen/homeScreen.dart';
import 'package:studywithfun/utility/provider/account.dart';

class NewUser extends StatefulWidget {
  final String phoneNo;
  final String uid;
  NewUser({@required this.phoneNo, this.uid});
  @override
  _NewUserState createState() => _NewUserState();
}

bool _showSpinner = false;
String phone = '';
String name = '';
String email = '';

class _NewUserState extends State<NewUser> {
  UploadImage uploadImage;
  bool isUploading = false;
  String photoUrl;

  @override
  void initState() {
    uploadImage = UploadImage(callBack, widget.uid, stopSpinner);
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return ModalProgressHUD(
      inAsyncCall: _showSpinner,
      progressIndicator: RefreshProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(theme.primaryColorDark),
      ),
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
                          child: CachedNetworkImage(
                            imageUrl: photoUrl,
                            fit: BoxFit.contain,
                            placeholder: (context, url) => SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      )
                    : Icon(CupertinoIcons.profile_circled,
                        size: 100, color: theme.accentColor.withOpacity(0.6)),
                onTap: () {
                  isUploading = true;
                  setState(() {});
                  uploadImage.uploadImage();
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
              SizedBox(
                height: 8.0,
              ),
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
              SizedBox(
                height: 12.0,
              ),
              ExtractedButton(
                text: 'Register',
                colour: checkEmail('$email') && name.length > 2
                    ? Colors.green
                    : Colors.grey.withOpacity(0.5),
                onclick: () async {
                  _showSpinner = true;
                  setState(() {});
                  if (checkEmail('$email') && name.length > 2) {
                    int dateInMS = DateTime.now().millisecondsSinceEpoch;
                    DocumentReference ref1 = FirebaseFirestore.instance
                        .collection('uid')
                        .doc(widget.uid);
                    DocumentReference ref2 = FirebaseFirestore.instance
                        .collection('users/userEvents/coins')
                        .doc(widget.uid);
                    DocumentReference ref3 = FirebaseFirestore.instance
                        .collection(
                            'users/byUid/${widget.uid}/category/coinsHistory')
                        .doc('$dateInMS');
                    WriteBatch batch = FirebaseFirestore.instance.batch();
                    batch.set(ref1, {
                      'phone': widget.phoneNo,
                      'name': name,
                      'email': email,
                      'photo': photoUrl,
                      'uid': widget.uid,
                    });
                    batch.set(ref2, {'coins': 20, 'name': name});
                    batch.set(ref3, {
                      'coin': 20,
                      'isAdded': true,
                      'title': 'New user reward'
                    });
                    try {
                      await batch.commit();
                      Provider.of<MyAccount>(context, listen: false).addUser({
                        'phone': widget.phoneNo,
                        'name': name,
                        'email': email,
                        'photo': photoUrl,
                        'uid': widget.uid,
                      });
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomeScreen()));
                    } catch (e) {
                      print('error $e');
                    }

                    _showSpinner = false;
                  }
                  // setState(() {});
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
