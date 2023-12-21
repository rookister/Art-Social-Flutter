import 'package:flutter/material.dart';
import 'package:project/login.dart';
import 'package:project/route_anim.dart';
import 'package:project/themes.dart';
import 'package:project/verification.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  SettingsMenu createState() => SettingsMenu();
}

class SettingsMenu extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Card(
            color: const Color.fromARGB(255, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Settings', 
                textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w200)),
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
                    ))
              ]
            )
    );
  }
}