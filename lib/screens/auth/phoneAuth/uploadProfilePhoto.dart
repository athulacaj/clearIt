import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:studywithfun/utility/provider/account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class UploadImage {
  String uid;
  UploadImage(this.callBack, this.uid, this.stopSpinner);
  Function(String) callBack;
  Function stopSpinner;
  double progress = 0.4;
  PickedFile pickedFile;
  File image;
  String url;
  uploadImage() async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );
    print(' is null ${pickedFile == null}');
    if (pickedFile == null) {
      stopSpinner();
    } else {
      image = File(pickedFile.path);
      int dateInMs = DateTime.now().millisecondsSinceEpoch;
      int year = DateTime.now().year;
      StorageReference ref = FirebaseStorage.instance
          .ref()
          .child('user')
          .child('$uid')
          .child("profilePhoto.jpg");

      StorageUploadTask uploadTask = ref.putFile(image);
      uploadTask.events.listen((event) {
        progress = event.snapshot.bytesTransferred.toDouble() /
            event.snapshot.totalByteCount.toDouble();
        // callBack();
        // set state is called using callback function
      }).onError((error) {
        // do something to handle error
      });

      url = await (await uploadTask.onComplete).ref.getDownloadURL();
      // await _firestore
      //     .collection('uid')
      //     .doc(uid)
      //     .update({'photo': url});
      callBack(url);
    }
  }
}
