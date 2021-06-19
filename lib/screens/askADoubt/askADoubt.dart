import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:studywithfun/screens/askADoubt/uploadImage.dart';
import 'package:studywithfun/utility/loadingWidget/loading.dart';
import 'package:studywithfun/utility/provider/account.dart';
import 'package:studywithfun/utility/provider/commonprovider.dart';
import 'package:studywithfun/utility/widgets/commonAppBar.dart';
import 'dataBase.dart';
import 'package:studywithfun/utility/functions/coinDectectionFunction.dart';
import 'package:studywithfun/utility/functions/showToastFunction.dart';

class AskADoubt extends StatefulWidget {
  @override
  _AskADoubtState createState() => _AskADoubtState();
}

Size size;

class _AskADoubtState extends State<AskADoubt> {
  TextEditingController doubtController;
  UploadImage uploadImage;
  String query;
  String imgUrl;
  bool isUploading = false;
  @override
  void initState() {
    uploadImage = UploadImage(callBack);
    isUploading = false;
    TextEditingController doubtController = TextEditingController();
    // TODO: implement initState
    super.initState();
  }

  void callBack() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    Map user = Provider.of<MyAccount>(context, listen: false).userDetails;
    return CoinLoading(
      showSpinner: Provider.of<CommonProvider>(context, listen: true).isSpinner,
      child: Scaffold(
        appBar: commonAppBar(title: 'Ask A Doubt', context: context),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          'Exam :',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                        DropdownButton<String>(
                            items: dropDown.map((var value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: Container(
                                  alignment: Alignment.center,
                                  width:
                                      (MediaQuery.of(context).size.width / 2) -
                                          50,
                                  child: Text(
                                    '$value',
                                    maxLines: 1,
                                  ),
                                ),
                              );
                            }).toList(),
                            value: dropValue,
                            onChanged: (String value) {
                              int i = 0;
                              print(value);
                              dropValue = value;

                              setState(() {});
                            }),
                      ],
                    ),
                    SizedBox(height: 10),
                    Theme(
                      data: ThemeData(
                        primaryColor: Color(0xff6369f2),
                        primaryColorDark: Color(0xff6369f2),
                      ),
                      child: TextField(
                        textInputAction: TextInputAction.newline,
                        keyboardType: TextInputType.multiline,
                        controller: doubtController,
                        autofocus: false,
                        maxLines: 6,
                        onSubmitted: (value) {},
                        onChanged: (value) {
                          query = value;
                          // setState(() {});
                        },
                        decoration: InputDecoration(
                          hintText: 'Write your Doubt',
                          border: OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    uploadImage.pickedFile != null
                        ? Container(
                            height: 80,
                            width: 240,
                            child: Stack(
                              children: [
                                Container(
                                  height: 80,
                                  width: 240,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                    image: FileImage(
                                        File(uploadImage.pickedFile.path)),
                                  )),
                                ),
                                uploadImage.progress == 1.0
                                    ? Container()
                                    : Positioned(
                                        left: 105,
                                        top: 25,
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            backgroundColor: Colors.grey,
                                            value: uploadImage.progress,
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          )
                        : Container(),
                    SizedBox(height: 10),
                    FlatButton(
                      color: Colors.lightBlueAccent,
                      child: Text(
                        'Upload an Image',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        isUploading = true;
                        uploadImage.uploadImage();
                      },
                    ),
                    SizedBox(
                        height: uploadImage.pickedFile != null
                            ? size.height / 13
                            : size.height / 5.2),
                    FlatButton(
                      color: Color(0xff6369f2),
                      child: Container(
                        width: double.infinity,
                        height: 55,
                        alignment: Alignment.center,
                        child: Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        if (isUploading && uploadImage.progress != 1.0) {
                          showToast(
                              "You are uploading a image ..!! Please wait until the upload finish");
                        } else if (query == null) {
                          showToast('Enter Doubt before submit..!!');
                        } else {
                          Map queryDetails = {
                            'query': query,
                            'imageUrl': uploadImage.url
                          };

                          AskDoubtDatabase askDoubtDatabase = AskDoubtDatabase(
                              user['uid'], queryDetails, context);
                          coinDetectFunction(context, () {
                            askDoubtDatabase.saveData(queryDetails);
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// int dropIndex=0;
String dropValue = dropDown[0];
List dropDown = ['bank', 'psc'];
//
// Future<void> showMyDialog(BuildContext context, Map queryDetails,
//     AskDoubtDatabase askDoubtDatabase) async {
//   return showDialog<void>(
//     context: context,
//     barrierDismissible: false, // user must tap button!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: Text('Are you sure !!'),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: <Widget>[
//               Text('On submitting a coin is deducted'),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           FlatButton(
//             child: Text('Cancel'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//           FlatButton(
//             child: Text('ok'),
//             onPressed: () {
//               Navigator.of(context).pop();
//               askDoubtDatabase.saveData(queryDetails);
//             },
//           ),
//         ],
//       );
//     },
//   );
// }
