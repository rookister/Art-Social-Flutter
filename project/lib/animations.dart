import 'dart:math';

import 'package:flutter/material.dart';


class Animations{

List<AnimationController> setup(VoidCallback set, List<AnimationController>? cont){
    for(int i=0;i<10;i++){
      cont![i].addListener(set);
      cont[i].addStatusListener((status) {
        if(status== AnimationStatus.completed){
          cont[i].repeat();
          }
        else if(status== AnimationStatus.dismissed){
          cont[i].forward();}
      });
      cont[i].forward();
}
        return cont!;
}

List<AnimationController> conter(List<AnimationController>? cont, TickerProviderStateMixin vsync){
  return List.generate(10, (index) => AnimationController(vsync: vsync, duration: Duration(seconds: Random().nextInt(6) + 1 + 3))..forward());
}

List<Animation<double>>? rotAnim(List<AnimationController>? cont){
  return List.generate(10, (index) => Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: cont![index], curve: Curves.easeInOut)));
}
List<Animation<double>>? radAnim(List<AnimationController>? cont){
  return List.generate(10, (index) => Tween(begin: 1.0, end: 60.0).animate(CurvedAnimation(parent: cont![index], curve: Curves.easeInOut)));
}
List<Animation<double>>? traY(List<AnimationController>? cont){
  return List.generate(10, (index) => Tween(begin: 550.0, end: -500.0).animate(CurvedAnimation(parent: cont![index], curve: Curves.easeInOut)));
}
List<Animation<double>>? opac(List<AnimationController>? cont){
  return List.generate(10, (index) => Tween(begin: 0.5, end: 0.0).animate(CurvedAnimation(parent: cont![index], curve: Curves.easeInOut)));
}

  Transform box(double X,double yAdd, double size,
  Animation<double> rotAnim,Animation<double> traY,Animation<double> radAnim,Animation<double> opac){
    return Transform.translate(
      offset: Offset(X, traY.value+yAdd),
      child: Transform.rotate(
        angle: rotAnim.value, 
        child: Container(
          width: size,
          height: size,
          decoration:BoxDecoration(
            color:  const Color.fromARGB(80, 50, 50, 50).withOpacity(opac.value),
            borderRadius: BorderRadius.circular(radAnim.value),
            border: Border.all(
                color: const Color.fromARGB(52, 255, 255, 255).withOpacity(opac.value),
                width: 2.0)
          ))));
  }

  Column buildBackground( List<Animation<double>> rotAnim, List<Animation<double>> radAnim,List<Animation<double>> traY,List<Animation<double>> opac
  ){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          Row(
          children: [for (int i = 0; i < 5; i++) box(i * 18, i * 28, i * 30, rotAnim[i],traY[i],radAnim[i],opac[i])]),
        Row(
          children: [for (int i = 5; i < 10; i++) box(i * 10, i * -10, i * 10,rotAnim[i],traY[i],radAnim[i],opac[i])]
          ),
      ],
    );}

  void dispose(List<AnimationController>? cont){
    for (int i = 0; i < 10; i++) {
       cont![i].dispose();}
}

}