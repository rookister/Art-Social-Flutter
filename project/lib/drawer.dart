import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/create_group/add_members.dart';
import 'package:project/login.dart';
import 'package:project/route_anim.dart';
import 'package:project/shared_prefs.dart';
import 'package:project/themes.dart';
import 'package:project/verification.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  String? image;
  Color mainColor = Colors.black;
  Color mainColor2 = Colors.black;
  bool theme = true;
  
  @override
  void initState(){
    super.initState();
    init();
  }

  init() async{
    Future.delayed(Duration.zero);
    await setTheme();
    loadImage();
  }
  
  loadImage() async{
    Map<String,dynamic>? data = await Preferences().getUserData();
    if(data==null || data['pfp']==null){
      User? currentUser = FirebaseAuth.instance.currentUser;
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
        setState(() {
          data = documentSnapshot.data() as Map<String, dynamic>?;
        });}
    else{
      await Future.delayed(Duration.zero);
    }
    image = data?['pfp'];
  }

  setTheme() async{
    Future.delayed(Duration.zero);
    theme = await Preferences().getTheme();
    setState(() {
      if(theme){
        defaultTheme(); 
      } else{
        secondTheme();
        }
    });
  }

  defaultTheme(){
  mainColor = Colors.black;
  mainColor2 = Colors.black;
  }

  secondTheme(){
  mainColor = const Color.fromARGB(255, 111, 76, 157);
  mainColor2 = const Color.fromARGB(255, 185, 108, 188);
  }

  switchTheme() async{
    theme = !theme;
    await Preferences().saveTheme(theme);
    setState(() {
      if(theme){
      defaultTheme(); 
    } else{
      secondTheme();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
          constraints: const BoxConstraints.expand(),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [mainColor2, mainColor], 
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
                 Flexible(
                   child: CircleAvatar(
                    radius: 72,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: 70,
                      backgroundImage: (image==null) ? const AssetImage('assets/noPFP.jpg') as ImageProvider : NetworkImage(image!),
                                 )),
                 ),
                const SizedBox(height: 50),

                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Themes().iconTextButtons(text: 'Create a Group', iconData: Icons.group_add,
                      onPressed: (){
                        Navigator.push(context, Fade(child: const AddMembersInGroup()));
                      }),
                      const SizedBox(height: 25),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 55),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, 
                        width: 1.5,
                      ),
                    borderRadius: BorderRadius.circular(50.0)),
                    child: FloatingActionButton(
                      backgroundColor: mainColor2,
                      onPressed: switchTheme,
                      child: const Icon(Icons.brightness_6)
                    ),
                  ),
                  
                ),
                const SizedBox(height: 50),

                Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0),
                        child: ElevatedButton(
                        onPressed: (){
                          Preferences().removeUserData();
                          Verification().signUserOut();
                          Navigator.pushReplacement(context,
                          Slide(child: const Login(), direction: AxisDirection.up));
                        },
                        style: Themes().elevB(),
                        child: Text('L O G O U T', style: Themes().text()),
                    ))

            ],
    ));
  }
}
