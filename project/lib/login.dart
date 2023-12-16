import 'package:flutter/material.dart';
import 'themes.dart';
import 'register.dart';

class Login extends StatefulWidget{
  const Login({super.key});

  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<Login> {
bool visible=false;

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
              style: Themes().text(),
              decoration: Themes().textFieldDecor(
                'Enter your Username','Username'),
            )),
          const SizedBox(height: 20),

          Padding( 
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 100), 
            child: TextFormField(
              obscureText: !visible,
              style: Themes().text(),
              decoration: Themes().passFieldDecor(
                'Enter your Password','Password',visible,
                  (){ setState ( () {visible=!visible;} );})
            )),

          Padding(
            padding: const EdgeInsets.only(left: 290),
            child: TextButton(
              style: Themes().textB(), 
              child: Text('Forgot Password?', style: Themes().text()),
              onPressed: (){},
            )),
          const SizedBox(height: 20),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: ElevatedButton(
              onPressed: (){},
              style: Themes().elevB(),
              child: Text('Sign In', style: Themes().text()),
          )),
          const SizedBox(height: 100),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: TextButton(
              style: Themes().textB(), 
              child: Text('New Here?', style: Themes().text()),
              onPressed: (){
                Navigator.push(context
                , MaterialPageRoute(builder:(context) => const Register()));
              },
            )),
        ],
     ), 
    )
    );
  }
}


