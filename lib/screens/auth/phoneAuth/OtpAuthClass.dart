import 'package:argon_buttons_flutter/argon_buttons_flutter.dart';
import 'package:clearit/splashscreen.dart';
import 'package:clearit/utility/loadingWidget/ModalProgressHudWidget.dart';
import 'package:clearit/utility/provider/account.dart';
import 'package:clearit/utility/widgets/otpWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'autoVerify.dart';
import 'newUser.dart';

class OtpAuthClass {
  BuildContext context;
  Function controlSpinner;
  FirebaseAuth _auth = FirebaseAuth.instance;
  var _forceCodeResendToken;
  final _codeController = TextEditingController();
  late String _phoneNumberWIthCode, _phoneNo, _countryCode;
  OtpAuthClass({required this.context, required this.controlSpinner});
  Future<bool?> loginUser({required countryCode, required String phone}) async {
    controlSpinner(true);
    await Future.delayed(Duration(milliseconds: 500));
    _phoneNumberWIthCode = '+$countryCode' + phone;
    _phoneNo = phone;
    _countryCode = countryCode;
    _auth.verifyPhoneNumber(
      phoneNumber: _phoneNumberWIthCode,
      timeout: Duration(seconds: 60),
      verificationCompleted: (AuthCredential credential) async {
        // TODO: after verification complete function
      },
      verificationFailed: (FirebaseAuthException exception) {
        // TODO: after verification failed function
      },
      codeSent: (String verificationId, int? forceResendingToken) {
        controlSpinner(false);
        // TODO: show enter otp widget and call login or resend otp function in that

        showEnterOtpDialog(verificationId);

        _forceCodeResendToken = forceResendingToken;
      },
      forceResendingToken: _forceCodeResendToken,
      codeAutoRetrievalTimeout: (String verificationId) {
        print('otp verification failed dut to time out');
        // Auto-resolution timed out...
      },
    );
  }

  Future<void> showEnterOtpDialog(String verificationId) async {
    bool _showSpinner = false;
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          var size = MediaQuery.of(context).size;
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return ModalProgressHUD(
              inAsyncCall: _showSpinner,
              child: Material(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Autoverify(
                    size: size,
                    child: Material(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        // color: Colors.white,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Hero(
                              tag: 'logo',
                              child: Container(
                                child: Image.asset('images/logo.png'),
                                height: 70.0,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text('Enter OTP received on $_phoneNumberWIthCode'),
                            SizedBox(height: 40),

                            Stack(
                              children: [
                                Container(
                                  height: 70,
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: OtpWidget(
                                        _codeController), // end PinEntryTextField()
                                  ), // end Padding()
                                ),
                              ],
                            ),
                            SizedBox(height: 30), // en
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  child: Container(
                                      height: 40,
                                      width: 90,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: Color(0xff7078ff),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(4))),
                                      child: Text(
                                        "Confirm",
                                        style: TextStyle(color: Colors.white),
                                      )),
                                  onTap: () async {
                                    final code = _codeController.text.trim();
                                    if (code.length == 6) {
                                      _showSpinner = true;
                                      setState(() {});
                                      await Future.delayed(
                                          Duration(milliseconds: 500));

                                      try {
                                        AuthCredential credential =
                                            PhoneAuthProvider.credential(
                                                verificationId: verificationId,
                                                smsCode: code);

                                        print("credential $credential");

                                        // TODO refract
                                        afterVerificationComplete(
                                            credential: credential,
                                            errorFn: () {
                                              _showSpinner = false;
                                              setState(() {});
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "ERROR: Check your OTP and connection ");
                                            });
                                      } on PlatformException catch (e) {
                                        print(e.message);
                                        _showSpinner = false;
                                        setState(() {});
                                        Fluttertoast.showToast(
                                            msg:
                                                "ERROR: Check your OTP and connection ");
                                      } catch (e) {}
                                    }
                                  },
                                ),
                                SizedBox(width: 20),
                                ArgonTimerButton(
                                  height: 40,
                                  width: 90,
                                  minWidth: 90,
                                  highlightColor: Colors.white,
                                  highlightElevation: 0,
                                  roundLoadingShape: false,
                                  onTap: (startTimer, btnState) async {
                                    if (btnState == ButtonState.Idle) {
                                      // Navigator.pop(context);

                                      // TODO: resend otp
                                      Navigator.pop(context);

                                      this.loginUser(
                                        countryCode: _countryCode,
                                        phone: _phoneNo,
                                      );
                                    }
                                  },
                                  initialTimer: 60,
                                  child: Text(
                                    "Resend",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  loader: (timeLeft) {
                                    return Text(
                                      "Resend $timeLeft",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    );
                                  },
                                  borderRadius: 5.0,
                                  color: Colors.transparent,
                                  elevation: 0,
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 1.5),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
        });
  }

  void afterVerificationComplete(
      {required AuthCredential credential, required Function errorFn}) async {
    try {
      var result = await _auth.signInWithCredential(credential);
      var user = result.user;
      if (user != null) {
        Map _userDetails = {
          'name': '${user.phoneNumber}',
          'image': '',
          'email': '${user.phoneNumber}',
          'uid': user.uid
        };
        controlSpinner(false);
      }
      if (user != null) {
        var value = await FirebaseFirestore.instance
            .collection('uid')
            .doc(user.uid)
            .get();

        if (value.exists) {
          Map _userDetails = {
            'phone': user.phoneNumber,
            'name': value.data()?['name'],
            'email': value.data()?['email'],
            'uid': user.uid
          };
          Provider.of<MyAccount>(context, listen: false).addUser(_userDetails);
          await Future.delayed(Duration(milliseconds: 1000));
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => SplashScreenWindow()),
              (Route<dynamic> route) => false);
        } else {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => NewUser(
                        phoneNo: '${user.phoneNumber}',
                        uid: user.uid,
                      )),
              (Route<dynamic> route) => false);
        }

        //add code here

      } else {
        print("Error");
      }
    } on PlatformException catch (e) {
      errorFn();
    } catch (e) {
      errorFn();
    }
  }

  void verificationFailed(FirebaseException exception) {
    controlSpinner(false);
    Fluttertoast.showToast(
        msg: '${exception.code}', backgroundColor: Colors.black45);
  }
}
