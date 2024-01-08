// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileFunctions{

  Future<bool> setUserName(User? userCreds, String username) async {
  if (userCreds != null) {
    bool isUsernameTaken = await isUsernameInUse(username);
    if (!isUsernameTaken) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCreds.email)
          .update({
        'username': username,
      });
      await userCreds.updateDisplayName(username); 
      return false;
    } 
      else {
        return true;
    }
  }
  else{ return true; }
}

Future<bool> isUsernameInUse(String username) async {
  QuerySnapshot querySnapshot = await FirebaseFirestore.instance
      .collection("Users")
      .where('username', isEqualTo: username)
      .get();

  return querySnapshot.docs.isNotEmpty;
}

setAboutMe(User? userCreds, String aboutMe) async {
  if (userCreds != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCreds.email)
          .update({
        'about': aboutMe,
      }); 
    } 
}

uploadProfileImages(String fileName, Uint8List file, User? userCreds, String imgType) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref().child(fileName);
  UploadTask uploadTask = ref.putData(file);
  TaskSnapshot snapshot = await uploadTask;
  String location = await snapshot.ref.getDownloadURL();

  if (userCreds != null) {
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(userCreds.email)
          .update({
        imgType: location,
      }); 
    } 
}

delHighlights(User? userCreds, Map<String, dynamic>? userData, int index) async {
  FirebaseStorage storage = FirebaseStorage.instance;

  if (userCreds != null && userData != null && userData['highlights'] != null) {
    List<String> existingHighlights = List<String>.from(userData['highlights']);

    if (index >= 0 && index < existingHighlights.length) {
      String downloadUrl = existingHighlights[index];
      Reference ref = storage.refFromURL(downloadUrl);
      await ref.delete();
      existingHighlights.removeAt(index);
      if (existingHighlights.isNotEmpty) {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userCreds.email)
            .update({
          'highlights': existingHighlights,
        });
      } else {
        await FirebaseFirestore.instance
            .collection("Users")
            .doc(userCreds.email)
            .update({
          'highlights': FieldValue.delete(),
        });
      }
    } 
  }
}

Future<void> uploadHighlights(Uint8List file, User? userCreds, Map<String, dynamic>? userData) async {
  FirebaseStorage storage = FirebaseStorage.instance;

  if (userCreds != null && userData != null && userData['email'] != null) {
    String userEmail = userData['email'];
    Reference userFolderRef = storage.ref().child(userEmail);
    String randomFileName = generateRandomFileName();
    Reference fileRef = userFolderRef.child(randomFileName);
    UploadTask uploadTask = fileRef.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String location = await snapshot.ref.getDownloadURL();
    List<String> existingHighlights = List<String>.from(userData['highlights'] ?? []);
    existingHighlights.add(location);

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userCreds.email)
        .update({
      'highlights': existingHighlights,
    });
  }
}

String generateRandomFileName() {
  final Random random = Random();
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(10, (index) => chars[random.nextInt(chars.length)]).join();
}

}