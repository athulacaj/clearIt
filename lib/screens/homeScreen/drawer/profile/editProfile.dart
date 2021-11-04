import 'package:cached_network_image/cached_network_image.dart';
import 'package:clearit/screens/homeScreen/drawer/profile/uploadProfilePhoto.dart';
import 'package:clearit/utility/loadingWidget/ModalProgressHudWidget.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clearit/screens/auth/ExtractedButton.dart';
import 'package:clearit/screens/auth/constants.dart';
import 'package:clearit/screens/homeScreen/homeScreen.dart';
import 'package:clearit/utility/provider/account.dart';

class EditProfile extends StatefulWidget {
  final String phoneNo;
  final String uid, name, email;
  final String? photo;

  EditProfile(
      {required this.phoneNo,
      required this.uid,
      required this.name,
      required this.email,
      this.photo});
  @override
  _EditProfileState createState() => _EditProfileState();
}

bool _showSpinner = false;
String phone = '';
String name = '';
String email = '';
late TextEditingController _nameController, _emailController;

class _EditProfileState extends State<EditProfile> {
  UploadImage? uploadImage;
  bool isUploading = false;
  String? photoUrl;

  @override
  void initState() {
    uploadImage = UploadImage(callBack, {"uid": widget.uid}, stopSpinner);
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _nameController.text = widget.name;
    _emailController.text = widget.email;
    if (widget.photo != null) {
      photoUrl = widget.photo;
    }
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
      child: Scaffold(
        appBar: commonAppBar(title: "Edit Profile", context: context),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20.0),
              GestureDetector(
                child: photoUrl != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                        child: Container(
                          color: Colors.lightBlueAccent.withOpacity(.4),
                          height: 100,
                          width: 100,
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
                controller: _nameController,
                style: TextStyle(color: Colors.black),
                decoration: KtextfieldDecoration.copyWith(
                    hintText: 'Enter name',
                    suffixIcon: _nameController.text.length > 2
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
                controller: _emailController,
                style: TextStyle(color: Colors.black),
                decoration: KtextfieldDecoration.copyWith(
                    hintText: 'Enter email',
                    suffixIcon: checkEmail(_emailController.text)
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
                text: 'Save',
                colour: checkEmail(_emailController.text) &&
                        _nameController.text.length > 2
                    ? Color(0xff7078ff)
                    : Colors.grey.withOpacity(0.5),
                onclick: () async {
                  _showSpinner = true;
                  setState(() {});
                  print(category);
                  if (checkEmail(_emailController.text) &&
                      _nameController.text.length > 2) {
                    int dateInMS = DateTime.now().millisecondsSinceEpoch;
                    DocumentReference ref1 = FirebaseFirestore.instance
                        .collection('uid')
                        .doc(widget.uid);

                    Map<String, dynamic> data = {
                      'phone': widget.phoneNo,
                      'name': _nameController.text,
                      'email': _emailController.text,
                      'photo': photoUrl,
                      'uid': widget.uid,
                      'category': category
                    };

                    try {
                      await ref1.update(data);
                      Provider.of<MyAccount>(context, listen: false)
                          .addUser(data);
                      Navigator.pop(context);
                    } catch (e) {
                      print('error $e');
                      _showSpinner = false;
                      setState(() {});
                    }
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _showSpinner = false;
  }
}

String? category = dropDown[0];
List dropDown = ['bank', 'psc'];
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
