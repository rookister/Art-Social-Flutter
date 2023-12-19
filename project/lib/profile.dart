import 'package:flutter/material.dart';
import 'package:project/login.dart';
import 'package:project/route_anim.dart';
import 'package:project/verification.dart';
import 'themes.dart';

class Profile extends StatefulWidget{
  const Profile({super.key});

  @override
  ProfilePage createState() => ProfilePage();
}

class ProfilePage extends State<Profile>{
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Container(
    color:Colors.black,
    alignment: Alignment.center,
    child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: ElevatedButton(
              onPressed: (){
                Verification().signUserOut();
                Navigator.pushReplacement(context,
                Slide(child: const Login(), direction: AxisDirection.up));
              },
              style: Themes().elevB(),
              child: Text('Sign out', style: Themes().text()),
          ))])
    );
  }
}