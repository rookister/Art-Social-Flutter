import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Verification{

    signInWithGoogle() async{
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken
      );
      UserCredential? userCreds= await FirebaseAuth.instance.signInWithCredential(credential);

      if(userCreds.user != null){
        await FirebaseFirestore.instance
        .collection("Users").doc(userCreds.user!.email)
        .set({
          'email': userCreds.user!.email
        },
         SetOptions(merge: true),
        );
      }
    }

    Future<int> signUserIn(String email,String password) async{
      int flag=1;
      try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      } on FirebaseAuthException {
          flag = -1;
      }
      return flag;
    }

    Future<int> createUser(String email,String password) async{
      int flag=1;
      try{
      UserCredential? userCreds = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

      if(userCreds.user != null){
        await FirebaseFirestore.instance
        .collection("Users").doc(userCreds.user!.email)
        .set({
          'email': userCreds.user!.email
        },
         SetOptions(merge: true),
        );
      }
      
      } on FirebaseAuthException{
          flag = -1;
      }
      return flag;
    }

    Future<int> passwordReset(String email) async{
      int flag=1;
      try{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      } on FirebaseAuthException{
          flag = -1;
      }
      return flag;
    }

    void signUserOut() async{
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
    }

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

uploadHighlights(String fileName, Uint8List file, User? userCreds, Map<String, dynamic>? userData) async {
  FirebaseStorage storage = FirebaseStorage.instance;
  Reference ref = storage.ref().child(fileName);
  UploadTask uploadTask = ref.putData(file);
  TaskSnapshot snapshot = await uploadTask;
  String location = await snapshot.ref.getDownloadURL();

  if (userCreds != null) {
    List<String>? existingHighlights;
    if (userData?['highlights'] != null) {
      existingHighlights = List<String>.from(userData?['highlights']);
    } else {
      existingHighlights = [];
    }

    existingHighlights.add(location);

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(userCreds.email)
        .update({
      'highlights': existingHighlights,
    });
  }
}

delHighlights(String filename, User? userCreds, Map<String, dynamic>? userData) async{

}


}