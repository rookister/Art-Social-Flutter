// ignore_for_file: use_build_context_synchronously

import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'profile_helpers.dart';
import 'shared_prefs.dart';
import 'themes.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileData createState() => ProfileData();
}

class ProfileData extends State<Profile> {

  bool userNameUL = true;
  bool userNameTakenError=false;
  bool userNameSize=false;
  bool aboutMe=true;
  bool addHL=true;
  TextEditingController userName = TextEditingController();
  TextEditingController aboutMeSection = TextEditingController();
  Map<String,dynamic>? userData; 
  User? currentUser;
  final FocusNode _userNameFocusNode = FocusNode();

  

  @override
  void initState(){
    super.initState();
    initWithPrefsOrFirebase();
  }

  initWithPrefsOrFirebase() async{
    userData = await Preferences().getUserData();
    await Future.delayed(Duration.zero);
    if(userData==null || userData?['email']==null || userData?['username']==null){
      currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await getUserDetails();
      }
    }
    else{
      setState(() {
        userData = userData;
      });
    }
  }

  getUserDetails() async{
    showDialog( context: context, builder: (context) { return Themes().loadingDialog();});
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
        setState(() {
          userData = documentSnapshot.data() as Map<String, dynamic>?;
        });
      await Future.delayed( Duration.zero,() {Navigator.pop(context);});
      if(userNameSize || userNameTakenError){
        userNameDialog();
        }
    }

    Future<void> refreshProfile() async{
        setState(() async {
          await getUserDetails();
        });
        await Preferences().saveUserData(userData);
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: refreshProfile,
      color: const Color.fromARGB(95, 42, 42, 42),
      height: 100,
      animSpeedFactor: 2.5,
      showChildOpacityTransition: true,
      child: ListView(
            children:[
              Container(
                color: Colors.transparent,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,          
                    children: [
                      Stack(
                      children:[ 
                        Themes().background(context, userData?['bg']),
                        Themes().bgEdit(() async {
                           await selectImage('bg');
                          }),
                        Themes().pfp(userData?['pfp'], () async {
                            await selectImage('pfp');                  
                        })
                        ]),
      
                      Row(
                        children: [
                        Themes().profileFields(context, _userNameFocusNode,
                          controller: userName, isUnderlined: userNameUL, text: userData?['username']),
                        const SizedBox(width: 5),
                        Themes().editButton(() async{
                          showDialog( context: context, builder: (context) { return Themes().loadingDialog();});
                          if(userNameUL == false){
                            if(userName.text.length<10){
                              userNameSize=false;
                              userNameTakenError=false;
                              userNameTakenError = await  ProfileFunctions().setUserName(currentUser, userName.text.trim());}
                            else{
                              userNameSize=true;
                              }
                            refreshProfile();
                          }
                          setState((){
                            userNameUL = !userNameUL;
                          });
                          await Future.delayed( Duration.zero,() {
                            Navigator.pop(context);
                          });
                            if (userNameUL) {
                              FocusScope.of(context).requestFocus(_userNameFocusNode);
                              }
                          } , 35, 17, userNameUL)
                        ]),
    
                        Row(
                          children: [
                            const SizedBox(width: 15),
                            Themes().aboutSection(context, controller: aboutMeSection, isUnderlined: aboutMe, text: userData?['about']),
                            const SizedBox(width: 20),
                            Themes().editButton(() async{
                              if(aboutMe == false){
                              await  ProfileFunctions().setAboutMe(currentUser, aboutMeSection.text.trim());
                                refreshProfile();
                              }
                              setState((){
                                aboutMe =!aboutMe;
                              });
                            } , 35, 18, aboutMe)
                          ]),

                        const SizedBox(height: 12),
                        const Divider(
                            color: Colors.white,
                            thickness: 0.5),
    
                        const Text('H I G H L I G H T S',
                          style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w300)),
                        const Divider(
                            color: Colors.white,
                            thickness: 0.5),
                        const SizedBox(height: 5),

                        Themes().addButton(() async { await addHighlights(); }, 40, 25, addHL),
                        const SizedBox(height: 20),

                        (userData?['highlights']!= null) ?
                        GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                          physics: const NeverScrollableScrollPhysics(),
                          children: List.generate(
                            userData?['highlights'].length,
                            (index) => InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Dialog(
                                      backgroundColor: Colors.transparent,
                                      child: Image.network(
                                        userData?['highlights'][index],
                                        width: 400,
                                        height: 350,
                                        fit: BoxFit.contain));});},
                              child: Stack(
                                children: [
                                  Opacity( 
                                    opacity: 0.8,
                                    child: Image.network( userData?['highlights'][index], width: 200, height: 200, fit: BoxFit.cover,
                                    loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? lp) {
                                      if (lp == null) { return child; } 
                                      else {
                                        return Center(
                                          child: CircularProgressIndicator(
                                            value: lp.expectedTotalBytes != null ? lp.cumulativeBytesLoaded / (lp.expectedTotalBytes ?? 1) : null,
                                            color: Colors.white,
                                          ));}}      
                                    )),
                                  Themes().deleteButton(() { 
                                         showDialog(
                                          context: context, 
                                          builder: (context) {
                                          return Themes().confirmDialog(context, () async{
                                            Navigator.of(context).pop();
                                            await deleteHighlight(index);
                                          }, 'Are you sure?'
                                          );});
                                  })
                              ])))) : const Text(''),
                        const SizedBox(height: 30)                        
                  ]
              )
            ),
            const SizedBox(height: 10),
          ] 
        ));
      }

  userNameDialog(){
      userNameTakenError? 
  showDialog( context: context, builder: (context) { return Themes().resultDialog2(context, 'This Username is Already Taken!');})
  : userNameSize ? 
  showDialog( context: context, builder: (context) { return Themes().resultDialog2(context, 'Use Less Than 10 Characters!'); })
  : const SizedBox();
  userNameTakenError = false;
  userNameSize=false;

  }

  selectImage(String imageType) async{
    showDialog(
        context: context, 
        builder: (context) {
        return Themes().loadingDialog();});
    final ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      Uint8List? img = await image.readAsBytes();
      await  ProfileFunctions().uploadProfileImages('$imageType-${userData?['email']}',img,currentUser,imageType);
      refreshProfile();  
    }
    await Future.delayed(const Duration(milliseconds: 10),() {Navigator.pop(context);});
  } 

    addHighlights() async{
    showDialog(
        context: context, 
        builder: (context) {
        return Themes().loadingDialog();});
    final ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      Uint8List? img = await image.readAsBytes();
      await  ProfileFunctions().uploadHighlights(img,currentUser,userData);
      refreshProfile();  
    }
    await Future.delayed(const Duration(milliseconds: 10),() {Navigator.pop(context);});
  }

  deleteHighlight(int index) async{
    showDialog(
        context: context, 
        builder: (context) {
        return Themes().loadingDialog();});
    await  ProfileFunctions().delHighlights(currentUser, userData, index);
    
    refreshProfile();
    await Future.delayed(const Duration(milliseconds: 10),() {Navigator.pop(context);});
  }
 
}