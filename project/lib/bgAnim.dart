
import 'package:flutter/material.dart';

class Background extends StatefulWidget{
  const Background({super.key});

  @override
  BG createState()=> BG();
}

class BG extends State<Background> with TickerProviderStateMixin {
  late AnimationController cont;
  late Animation<double> rotAnim;
  late Animation<double> radAnim;

  @override
  void initState() {
    super.initState();

    cont = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2))..forward();

    rotAnim = Tween(begin:0.0 , end: 1.0).animate(
      CurvedAnimation(parent: cont, curve: Curves.easeInOut));

    radAnim = Tween(begin:450.0 , end: 10.0).animate(
      CurvedAnimation(parent: cont, curve: Curves.easeInOut));

    cont.addListener(() {
      setState(() {
        
      });
    });

    cont.addStatusListener((status) {
      if(status== AnimationStatus.completed){
        cont.reverse();}
      else if(status==AnimationStatus.dismissed){
        cont.forward(); 
      }
    });


  }

  @override
  Widget build(BuildContext context){
    return Scaffold();
  }
}