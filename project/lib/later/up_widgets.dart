import 'package:flutter/material.dart';

class TF extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;

  const TF({
    Key? key,
    required this.controller,
    required this.labelText,
    required this.hintText,
  }) : super(key: key);

  @override
  State<TF> createState() => _TFState();
}

class _TFState extends State<TF> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: TextFormField(
          style: const TextStyle(color: Colors.white, fontSize: 11),
          decoration: textFieldDecor(),
          controller: widget.controller,
      )
    );
  }

  InputDecoration textFieldDecor() {
    return InputDecoration(
      labelText: widget.labelText,
      hintText: widget.hintText,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color.fromARGB(255, 219, 34, 34), width: 2),
      ),
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

class ETF extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final bool visible;

  const ETF({
    Key? key,
    required this.visible,
    required this.controller,
    required this.labelText,
    required this.hintText,
  }) : super(key: key);

  @override
  State<ETF> createState() => _ETFState();
}

class _ETFState extends State<ETF> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
      child: TextFormField(
          obscureText: !widget.visible,
          style: const TextStyle(color: Colors.white, fontSize: 11),
          decoration: eTextFieldDecor(),
          controller: widget.controller,
      )
    );
  }

  InputDecoration eTextFieldDecor() {
    return InputDecoration(
      labelText: widget.labelText,
      hintText: widget.hintText,
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color.fromARGB(255, 219, 34, 34), width: 2),
      ),
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

