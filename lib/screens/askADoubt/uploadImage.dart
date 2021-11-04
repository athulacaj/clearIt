import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage {
  UploadImage(this.callBack);
  Function callBack;
  double progress = 0.4;
  File? image;
  String? url;
  FilePickerResult? result;
  Future<bool> uploadImage() async {
    result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result != null) {
      image = File(result!.files.single.path!);
    } else {
      return false;
    }
    int dateInMs = DateTime.now().millisecondsSinceEpoch;
    int year = DateTime.now().year;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('$year')
        .child('doubts')
        .child('uid')
        .child("$dateInMs.jpg");
    if (image != null) {
      UploadTask uploadTask = ref.putFile(image!);
      uploadTask.snapshotEvents.listen((event) {
        progress =
            event.bytesTransferred.toDouble() / event.totalBytes.toDouble();
        callBack();
        // set state is called using callback function
      }).onError((error) {
        // do something to handle error
      });

      url = await (await uploadTask.whenComplete(() => null))
          .ref
          .getDownloadURL();
      callBack();
    } else {
      print("image null");
      return false;
    }
    return true;
  }
}
