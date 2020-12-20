import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/screens/auth/phoneAuth/login.dart';
import 'package:studywithfun/utility/provider/account.dart';
import 'package:studywithfun/screens/homeScreen/drawer/profile/uploadProfilePhoto.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UploadImage uploadImage;
  bool isUploading = false;
  Map user;
  @override
  void initState() {
    user = Provider.of<MyAccount>(context, listen: false).userDetails;
    uploadImage = UploadImage(callBack, user, stopSpinner);
    isUploading = false;
    // TODO: implement initState
    super.initState();
  }

  void callBack(String url) {
    isUploading = false;
    user['photo'] = url;
    Provider.of<MyAccount>(context, listen: false).addUser(user);
    print('got url $url');
    setState(() {});
  }

  void stopSpinner() {
    isUploading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
                            GestureDetector(
                              child: myAccount.userDetails['photo'] != null
                                  ? ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      child: Container(
                                        height: 60,
                                        width: 60,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              myAccount.userDetails['photo'],
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) => SizedBox(
                                              height: 30,
                                              width: 30,
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                    )
                                  : Icon(CupertinoIcons.profile_circled,
                                      size: 100,
                                      color:
                                          theme.accentColor.withOpacity(0.6)),
                              onTap: () {
                                isUploading = true;
                                setState(() {});
                                uploadImage.uploadImage();
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) =>
                                //             UploadProfilePhoto()));
                              },
                            ),
                            SizedBox(width: 20),
                            Container(
                              height: 100,
                              padding: EdgeInsets.symmetric(vertical: 12),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('${myAccount.userDetails['name']}'
                                      .toUpperCase()),
                                  Text('${myAccount.userDetails['email']}'
                                      .toUpperCase()),
                                  Text('${myAccount.userDetails['phone']}'
                                      .toUpperCase()),
                                ],
                              ),
                            ),
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
