
import 'package:flutter/material.dart';

class Slide extends PageRouteBuilder {
  final Widget child;
  final AxisDirection direction;

    Slide({required this.child,required this.direction}) :
    super(
      transitionDuration: const Duration(milliseconds: 450),
      reverseTransitionDuration: const Duration(milliseconds: 450),
      pageBuilder: (context,animation,secondaryAnimation) => child
    );

    @override
    Widget buildTransitions(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child){
      var begin = getBeginOffset();
      const end = Offset.zero;
      const curve= Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

    return SlideTransition(
      position: animation.drive(tween), 
      child: child);
    }

      Offset getBeginOffset() {
        switch(direction) {
            case AxisDirection.up:    return const Offset(0, 1);
            case AxisDirection.down:  return const Offset(0, -1);
            case AxisDirection.left:  return const Offset(-1, 0);
            case AxisDirection.right: return const Offset(1, 0);
        }
      }
}

class Fade extends PageRouteBuilder {
  final Widget child;

    Fade({required this.child}) :
    super(
      transitionDuration: const Duration(milliseconds: 400),
      reverseTransitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (context,animation,secondaryAnimation) => child
    );

    @override
    Widget buildTransitions(BuildContext context, Animation<double> animation,
    Animation<double> secondaryAnimation, Widget child) => 
    FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1).animate(animation), 
      child: child);
}