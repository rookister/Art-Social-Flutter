
import 'package:flutter/material.dart';

class Themes{

  TextStyle text(){
    return const TextStyle(
      color: Colors.white
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
    String labelText, String hintText,bool visible,VoidCallback toggle){
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
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.white, width: 2),
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
  InputDecoration textFieldDecor(String labelText, String hintText){
          return InputDecoration(
            labelText: labelText,
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.white, width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.white, width: 2),
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

