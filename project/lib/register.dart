import 'package:flutter/material.dart';
import 'themes.dart';

class Register extends StatefulWidget{
  const Register({super.key});

  @override
  RegPage createState() => RegPage();
}

class RegPage extends State<Register> {
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
                'Create a Username','Username'),
            )),
          const SizedBox(height: 20),

          Padding( 
            padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 100), 
            child: TextFormField(
              obscureText: !visible,
              style: Themes().text(),
              decoration: Themes().passFieldDecor(
                'Create a Password','Password',visible,
                  (){ setState ( () {visible=!visible;} );})
            )),
          const SizedBox(height: 70),
          
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: ElevatedButton(
              onPressed: (){},
              style: Themes().elevB(),
              child: Text('Register', style: Themes().text()),
          )),
          const SizedBox(height: 100),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0),
            child: TextButton(
              style: Themes().textB(), 
              child: Text('Already a User?', style: Themes().text()),
              onPressed: (){ Navigator.pop(context);},
            )),
        ],
     ), 
    )
    );
  }
}