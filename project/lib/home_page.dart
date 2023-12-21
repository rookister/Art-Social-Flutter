import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  Ranks createState() => Ranks();
}

  Future<void> handleRefresh() async {
    return await Future.delayed(const Duration(seconds: 2));
  }

class Ranks extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Card(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                Text('Home Page', 
                textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w200)),
              ]
            )
    );
  }
}