import 'package:flutter/material.dart';
import 'themes.dart';

class Login extends StatefulWidget{
  const Login({super.key});

  @override
  LoginPage createState() => LoginPage();
}

switcher(BuildContext context){
     //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  MyApp()));
  }

class LoginPage extends State<Login> {
  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    return Card(
    child: Container(
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
        children: [
          Image.asset( 'assets/logo.gif',width: 150,height: 150, fit: BoxFit.cover),
          const SizedBox(height: 50),
          
          Padding( 
            padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 100), 
            child: TextFormField(
              style: const TextStyle(
                color: Colors.white),
              decoration: Themes().textFieldDecor('Enter your Username','Username'),
            )),
          const SizedBox(height: 20),

          Padding( 
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 100), 
            child: TextFormField(
              style: const TextStyle(
                color: Colors.white),
              decoration: Themes().textFieldDecor('Enter your Password','Password'),
            )),

          const SizedBox(height: 20),

        ],
     ), 
    )
    );
  }
}
