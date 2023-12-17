import 'package:flutter/material.dart';
import 'package:project/login.dart';
import 'themes.dart';

class Profile extends StatefulWidget{
  const Profile({super.key});

  @override
  ProfilePage createState() => ProfilePage();
}

class ProfilePage extends State<Profile>{

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: 
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: ElevatedButton(
              onPressed: (){
                Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const Login()));
              },
              style: Themes().elevB(),
              child: Text('Sign In', style: Themes().text()),
          )),
    );
  }
}