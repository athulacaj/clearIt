import 'package:cached_network_image/cached_network_image.dart';
import 'package:clearit/screens/auth/phoneAuth/login.dart';
import 'package:clearit/utility/functions/showToastFunction.dart';
import 'package:clearit/utility/loadingWidget/ModalProgressHudWidget.dart';
import 'package:clearit/utility/provider/account.dart';
import 'package:clearit/utility/widgets/commonAppBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'editProfile.dart';
import 'uploadProfilePhoto.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UploadImage uploadImage;
  bool isUploading = false;
  late Map user;
  @override
  void initState() {
    user = Provider.of<MyAccount>(context, listen: false).userDetails!;
    uploadImage = UploadImage(callBack, user, stopSpinner);
    isUploading = false;
    // TODO: implement initState
    super.initState();
  }

  void callBack(String url) async {
    try {
      await FirebaseFirestore.instance
          .collection("uid")
          .doc(user['uid'])
          .update({"photo": url});
      isUploading = false;
      user['photo'] = url;
      Provider.of<MyAccount>(context, listen: false).addUser(user);
      print('got url $url');
    } catch (e) {
      showToast("something error happened");
    }
    setState(() {});
  }

  void stopSpinner() {
    isUploading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Size _size = MediaQuery.of(context).size;
    return Consumer<MyAccount>(
      builder: (context, myAccount, child) {
        return ModalProgressHUD(
          inAsyncCall: isUploading,
          child: Scaffold(
            appBar: commonAppBar(title: 'Profile', context: context),
            body: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            myAccount.userDetails!['photo'] != null
                                ? ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    child: Container(
                                      height: _size.width / 5,
                                      width: _size.width / 5,
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            myAccount.userDetails!['photo'],
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => SizedBox(
                                            height: _size.width / 7,
                                            width: _size.width / 7,
                                            child: CircularProgressIndicator()),
                                        errorWidget: (context, url, error) =>
                                            Icon(Icons.error),
                                      ),
                                    ),
                                  )
                                : Icon(CupertinoIcons.profile_circled,
                                    size: _size.width / 5,
                                    color: theme.accentColor.withOpacity(0.6)),
                            SizedBox(width: 20),
                            Container(
                              height: 100,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('${myAccount.userDetails!['name']}'
                                      .toUpperCase()),
                                  Text('${myAccount.userDetails!['email']}'
                                      .toUpperCase()),
                                  Text('${myAccount.userDetails!['phone']}'
                                      .toUpperCase()),
                                  Text('${myAccount.userDetails!['category']}'
                                      .toUpperCase()),
                                ],
                              ),
                            ),
                            Spacer(),
                            IconButton(
                                onPressed: () {
                                  Map details = myAccount.userDetails!;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfile(
                                                uid: details['uid'],
                                                phoneNo: details['phone'],
                                                name: details['name'],
                                                email: details['email'],
                                                photo: details['photo'],
                                              )));
                                },
                                icon: Icon(Icons.settings)),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Provider.of<MyAccount>(context, listen: false)
                                .removeUser();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => PhoneLoginScreen()),
                                (Route<dynamic> route) => false);
                          },
                          child: Container(
                            height: 35,
                            width: 80,
                            alignment: Alignment.center,
                            child: Text('Logout'),
                            decoration: contaionerBlackOutlineButtonDecoration,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

BoxDecoration contaionerBlackOutlineButtonDecoration = BoxDecoration(
  border: Border.all(color: Colors.black),
  borderRadius: BorderRadius.all(Radius.circular(4)),
);
