import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore _firestore = FirebaseFirestore.instance;

class UploadImage {
  Map userData;
  Function(String) callBack;
  Function stopSpinner;
  double progress = 0.4;
  File? image;
  String? url;
  UploadImage(this.callBack, this.userData, this.stopSpinner);

  uploadImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    //
    // pickedFile = await ImagePicker().getImage(
    //   source: ImageSource.gallery,
    //   // maxWidth: 2000,
    //   // maxHeight: 2000,
    //   // imageQuality: 70,
    // );
    if (result == null) {
      stopSpinner();
    } else {
      // image = File(pickedFile!.path);
      image = await cropImage(result.files.single.path!);
      if (image != null) {
        int year = DateTime.now().year;
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('user')
            .child('${userData['uid']}')
            .child("profilePhoto.jpg");

        UploadTask uploadTask = ref.putFile(image!);
        uploadTask.snapshotEvents.listen((event) {
          progress =
              event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
          // callBack();
          // set state is called using callback function
        }).onError((error) {
          // do something to handle error
        });

        url = await (await uploadTask.whenComplete(() => null))
            .ref
            .getDownloadURL();
        print(url);
        int dateInMs = DateTime.now().millisecondsSinceEpoch;

        // await _firestore
        //     .collection('phoneNumber')
        //     .doc(userData['phone'])
        //     .update({'photo': url});
        callBack(url!);
      } else {
        stopSpinner();
      }
    }
  }
}

Future<File?> cropImage(String path) async {
  File? croppedFile = await ImageCropper.cropImage(
      sourcePath: path,
      // maxHeight: 150,
      // maxWidth: 150,
      compressQuality: 85,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        // CropAspectRatioPreset.ratio3x2,
        // CropAspectRatioPreset.original,
        // CropAspectRatioPreset.ratio4x3,
        // CropAspectRatioPreset.ratio16x9
      ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Color(0xff7078ff),
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        minimumAspectRatio: 1.0,
      ));
  return croppedFile;
}
