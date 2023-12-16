// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:project/login.dart';


class SplashContext extends StatelessWidget {
  const SplashContext({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Splash',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      );  
    }
}

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => Splash();
}

class Splash extends State<SplashScreen> {
  @override
  void initState(){
    super.initState();
    _delay();
  }
  

  _delay() async{
     await Future.delayed(const Duration(seconds: 5),() {});
     deactivate();
     Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => const Login()));
  }

  @override
  Widget build(BuildContext context){
    return  Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color.fromARGB(255, 198, 51, 76),
            Color.fromARGB(255, 93, 37, 191)])),
     child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo.gif',
          width: 150,
          height: 150, 
          fit: BoxFit.cover,
          ),
          const SizedBox(height: 50),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(Colors.white),
          )
        ],
     ), 
    );
  }
}



