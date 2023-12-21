
import 'package:flutter/material.dart';

class Themes{

SizedBox iconTextButtons({ required String text, IconData? iconData, required VoidCallback onPressed}) {
  return SizedBox(
    width: 200,
    height: 50,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black, 
        foregroundColor: Colors.white, 
      ),
      child: Row(
        children: [
          Icon(iconData, color: Colors.white),
          const SizedBox(width: 20), 
          Text(
            text,
            style: const TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w200)
          ),
        ])),
  );
}

  AlertDialog loadingDialog(){
    return AlertDialog(
      content: SizedBox(
        width: 150,
        height: 170,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/stretching.gif',height: 100, width: 100, fit: BoxFit.cover,),
          const SizedBox(height: 30),
          const CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(Colors.white))
        ],
      )), 
      backgroundColor: const Color.fromARGB(95, 0, 0, 0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(1000),
      ),
    );
  }

  TextStyle text(){
    return const TextStyle(
      color: Colors.white,
      fontSize: 11
    );
  }

  ButtonStyle textB(){
    return ButtonStyle(
      overlayColor: MaterialStateColor.resolveWith((Set<MaterialState> states) 
      =>Colors.white.withOpacity(0.2))
    );
  }

  ButtonStyle elevB(){
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(30)),
      foregroundColor: MaterialStateColor.resolveWith((Set<MaterialState> states) 
      =>Colors.white.withOpacity(0.2)),
      minimumSize: const Size(200, 55),
      side: const BorderSide(
        color: Colors.white,
        width: 2
      )
    );
  }

  InputDecoration passFieldDecor(
    String labelText, String hintText,bool visible,VoidCallback toggle,{Color color= Colors.white}){
      return InputDecoration(
            suffixIcon: Padding(padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
                color: Colors.white,
                onPressed: toggle,
            )),
            labelText: labelText,
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:  BorderSide(color: color, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide:  BorderSide(color: color, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            labelStyle: const TextStyle(color: Color.fromARGB(255, 212, 212, 212)),
            hintStyle: const TextStyle(color: Color.fromARGB(255, 105, 105, 105)),
            filled: true,
            fillColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
              if (states.contains(MaterialState.focused)) {
                return const Color.fromARGB(255, 30, 30, 30);
              }
              return const Color.fromARGB(255, 0, 0, 0);
            }),
          );
    }
    
  InputDecoration textFieldDecor(String labelText, String hintText,{Color color= Colors.white}){
          return InputDecoration(
            labelText: labelText,
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:  BorderSide(color: color, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(color: color, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
            labelStyle: const TextStyle(color: Color.fromARGB(255, 212, 212, 212)),
            hintStyle: const TextStyle(color: Color.fromARGB(255, 105, 105, 105)),
            filled: true,
            fillColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
              if (states.contains(MaterialState.focused)) {
                return const Color.fromARGB(255, 30, 30, 30);
              }
              return const Color.fromARGB(255, 0, 0, 0);
            }),
          );
        } 
  }
