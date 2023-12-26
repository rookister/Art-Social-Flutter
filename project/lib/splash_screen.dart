import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/login.dart';
import 'package:project/main_page.dart';
import 'package:project/route_anim.dart';


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
    _delay(context);
  }
  
bool isUserSignedIn() {
  User? user = FirebaseAuth.instance.currentUser;
  return user != null;
}
  _delay(BuildContext context) async{
     await Future.delayed(const Duration(seconds: 3),() {   
      if(isUserSignedIn()==true){
      Navigator.pushReplacement(
      context, 
      Slide(child: const MainPage(),direction: AxisDirection.up));
      }
      else{
      Navigator.pushReplacement(
      context, 
      Slide(child: const Login(),direction: AxisDirection.up));}
      });
  }

  @override
  Widget build(BuildContext context){
    return  Container(
      color: Colors.black,
     child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/running.gif',
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



