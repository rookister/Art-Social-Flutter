
import 'package:flutter/material.dart';

class Themes{
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
