import 'dart:math';
import 'package:flutter/material.dart';

class Background extends StatefulWidget{
  const Background({super.key});

  @override
  BG createState() => BG();
}

class BG extends State<Background> with TickerProviderStateMixin{
  late List<AnimationController> cont;
  late List<Animation<double>> rotAnim;
  late List<Animation<double>> radAnim;
  late List<Animation<double>> traY;
  late List<Animation<double>> opac;

  @override
  void initState(){
    super.initState();
  }

    init(){
    cont = List.generate(10, (index) => AnimationController(vsync: this, duration: Duration(seconds: Random().nextInt(6) + 1 + 3))..forward());
    rotAnim = List.generate(10, (index) => Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: cont[index], curve: Curves.easeInOut)));
    radAnim = List.generate(10, (index) => Tween(begin: 1.0, end: 60.0).animate(CurvedAnimation(parent: cont[index], curve: Curves.easeInOut)));
    traY = List.generate(10, (index) => Tween(begin: 550.0, end: -500.0).animate(CurvedAnimation(parent: cont[index], curve: Curves.easeInOut)));
    opac = List.generate(10, (index) => Tween(begin: 0.5, end: 0.0).animate(CurvedAnimation(parent: cont[index], curve: Curves.easeInOut)));

    for(int i=0;i<10;i++){
      cont[i].addListener(() { setState(() {});});
      cont[i].addStatusListener((status) {
        if(status== AnimationStatus.completed){
          cont[i].repeat();
          cont[i].duration=Duration(seconds: Random().nextInt(6) + 1 + 3);
          }
        else if(status== AnimationStatus.dismissed){
          cont[i].forward();}
      });
      cont[i].forward();
    }
  }

  Transform box(double X,double yAdd, double size, int cont){
    return Transform.translate(
      offset: Offset(X, traY[cont].value+yAdd),
      child: Transform.rotate(
        angle: rotAnim[cont].value, 
        child: Container(
          width: size,
          height: size,
          decoration:BoxDecoration(
            color:  const Color.fromARGB(80, 50, 50, 50).withOpacity(opac[cont].value),
            borderRadius: BorderRadius.circular(radAnim[cont].value),
            border: Border.all(
                color: const Color.fromARGB(52, 255, 255, 255).withOpacity(opac[cont].value),
                width: 2.0)
          ))));
  }
  @override
  void dispose(){
    for (int i = 0; i < 10; i++) {
       cont[i].dispose();}
    super.dispose();
}

  @override
  Widget build(BuildContext context){
    return  buildBackground();
  }

  Column buildBackground(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Row(
          children: [for (int i = 0; i < 5; i++) box(i * 18, i * 28, i * 30, i)]),
        Row(
          children: [for (int i = 0; i < 5; i++) box(i * 10, i * -10, 125 - (i * 25), i)]
          ),
      ],
    );}


}

