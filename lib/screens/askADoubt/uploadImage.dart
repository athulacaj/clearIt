import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UploadImage {
  UploadImage(this.callBack);
  Function callBack;
  double progress = 0.4;
  PickedFile pickedFile;
  File image;
  String url;
  uploadImage() async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 20,
    );
    image = File(pickedFile.path);
    int dateInMs = DateTime.now().millisecondsSinceEpoch;
    int year = DateTime.now().year;
    StorageReference ref = FirebaseStorage.instance
        .ref()
        .child('$year')
        .child('doubts')
        .child('uid')
        .child("$dateInMs.jpg");

    StorageUploadTask uploadTask = ref.putFile(image);
    uploadTask.events.listen((event) {
      progress = event.snapshot.bytesTransferred.toDouble() /
          event.snapshot.totalByteCount.toDouble();
      callBack();
      // set state is called using callback function
    }).onError((error) {
      // do something to handle error
    });

    url = await (await uploadTask.onComplete).ref.getDownloadURL();
    callBack();
  }
}
