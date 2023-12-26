import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
          'email': userCreds.user!.email,
          "uid": userCreds.user!.uid
        },
         SetOptions(merge: true),
        );
      }
    }

    Future<int> signUserIn(String email,String password) async{
      int flag=1;
      try{
      UserCredential? userCreds = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
      if(userCreds.user != null){
        await FirebaseFirestore.instance
        .collection("Users").doc(userCreds.user!.email)
        .set({
          'email': userCreds.user!.email,
          "uid": userCreds.user!.uid
        },
         SetOptions(merge: true),
        );}
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
          'email': userCreds.user!.email,
          'uid': userCreds.user!.uid
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

}