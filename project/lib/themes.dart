import 'package:flutter/material.dart';

class Themes{

Color sideColor = Colors.white;
Color sideColorSub = const Color.fromARGB(255, 212, 212, 212);
Color mainColor = Colors.black;
Color mainColorSub = const Color.fromARGB(194, 51, 51, 51);
Color mainColorHalf = const Color.fromARGB(255, 105, 105, 105);


Padding pfp(String? image, VoidCallback pressed){
 return Padding(
  padding: const EdgeInsets.only(right: 20,top : 90),
  child: CircleAvatar(
  radius: 72,
  backgroundColor: sideColor,
  child: CircleAvatar(
    backgroundColor: const Color.fromARGB(133, 5, 27, 67),
    radius: 71,
    backgroundImage: (image==null) ? const AssetImage('assets/noPFP.jpg') as ImageProvider : NetworkImage(image),
    child: Padding(
      padding: const EdgeInsets.only(top: 90),
      child: Opacity(
        opacity: (image==null) ? 1 : 0.8,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(shape: BoxShape.circle, color: mainColorSub),
          child: IconButton(
            onPressed: pressed, 
            icon: const Icon(Icons.add_a_photo, size: 20))
        ),
      )))));
}

Padding gfp(String? image, VoidCallback pressed){
 return Padding(
  padding: const EdgeInsets.only(right: 20,top : 90),
  child: CircleAvatar(
  radius: 72,
  backgroundColor: sideColor,
  child: CircleAvatar(
    backgroundColor: const Color.fromARGB(133, 5, 27, 67),
    radius: 71,
    backgroundImage: (image==null) ? const AssetImage('assets/normalGroups.jpg') as ImageProvider : NetworkImage(image),
    child: Padding(
      padding: const EdgeInsets.only(top: 90),
      child: Opacity(
        opacity: (image==null) ? 1 : 0.8,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(shape: BoxShape.circle, color: mainColorSub),
          child: IconButton(
            onPressed: pressed, 
            icon: const Icon(Icons.add_a_photo, size: 20))
        ),
      )))));
}

Opacity background(BuildContext context, String? image){
  return Opacity(
    opacity: 0.8,
    child: Container(
      width:  MediaQuery.of(context).size.width, height: 200,
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: sideColor, 
            width: 2.0, 
        ))),
      child: (image==null) ? Image.asset('assets/noBG.jpg',fit: BoxFit.cover ) : 
      Image.network(image,fit: BoxFit.cover, 
      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? lp) {
        if (lp == null) { return child; } 
        else {
          return Center(
            child: CircularProgressIndicator(
              value: lp.expectedTotalBytes != null ? lp.cumulativeBytesLoaded / (lp.expectedTotalBytes ?? 1) : null,
              color: sideColor,
            ));}})),
  );
}

Padding bgEdit(VoidCallback pressed){
  return Padding(
    padding: const EdgeInsets.only(left: 360,top: 10),
    child: Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(shape: BoxShape.circle, color: mainColorSub,),
      child: IconButton(
        onPressed: pressed, 
        icon: Icon(Icons.upload,color: sideColor))),
    );
}

Container aboutSection( BuildContext context,
  {required TextEditingController controller, required bool isUnderlined, required String? text}) {
    text ??= 'Write Something About Yourself!';
    return Container(
        decoration: BoxDecoration(
          border: isUnderlined ? Border.all(color: Colors.transparent) : Border.all(color: sideColor, width: 0.5),
          borderRadius: BorderRadius.circular(20)
        ),
        width: MediaQuery.of(context).size.width-100,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TextFormField(
            autocorrect: false, 
            autovalidateMode: AutovalidateMode.disabled,
            expands: false,
            keyboardType: TextInputType.multiline,
            maxLines: 3,
            minLines: 1,
            controller: controller..text = text,
            enabled: !isUnderlined,
            onChanged: (text) {
              if (text.split('\n').length > 3) {
                controller.text = controller.text.split('\n').take(3).join('\n');}},
            style: TextStyle( fontSize: 14, color: sideColor, fontWeight: FontWeight.w200),
            decoration: const InputDecoration(
              border: InputBorder.none
              )
          ),
        )
    );
  }

Padding profileFields( BuildContext context, FocusNode userNameFocusNode,
  {required TextEditingController controller, required bool isUnderlined, required String? text}) {
    text ??= 'Set a Username';
    TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle( fontSize: 17, fontWeight: FontWeight.w400)), textDirection: TextDirection.ltr); textPainter.layout();
    double padding=30;
    if(text.length<6){padding =41;} else if(text.length>9){padding = 20;}
    return Padding(
    padding: EdgeInsets.only(left: padding,top: 5),
    child: Row(
      children: [
        Text('@',style: TextStyle(fontSize: 17, color: sideColor, fontWeight: FontWeight.w400)),
        const SizedBox(width: 5),
        SizedBox(
        width: MediaQuery.of(context).size.width/3.25,
        child: TextFormField(
          focusNode: userNameFocusNode,
          controller: controller..text = text,
          enabled: !isUnderlined,
          style: TextStyle(decoration: isUnderlined? TextDecoration.none : TextDecoration.underline,
            fontSize: 17, color: sideColor, fontWeight: FontWeight.w400),
          decoration: const InputDecoration(
            border: InputBorder.none
          ),
        ),
      )]
    ));
  }

Container editButton(VoidCallback onPressed, double size, double iconSize, bool icon){
  return Container(
     width: size,
     height: size,
     decoration: BoxDecoration(shape: BoxShape.circle, color: mainColorSub,),
     child: IconButton(
     onPressed: onPressed, 
     icon: Icon(icon ? Icons.edit : Icons.done_rounded,
      color: sideColor, size: iconSize)));
  }

Padding addButton(VoidCallback onPressed, double size, double iconSize, bool icon){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
    child: Container(
       width: size,
       height: size,
       decoration: BoxDecoration(shape: BoxShape.circle, color: mainColorSub,),
       child: IconButton(
       onPressed: onPressed, 
       icon: Icon(icon ? Icons.add : Icons.done_rounded,
        color: sideColor, size: iconSize))),
  );
  }

Padding deleteButton(VoidCallback onPressed){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
    child: Container(
       width: 40,
       height: 40,
       decoration: BoxDecoration(shape: BoxShape.circle, color: mainColorSub,),
       child: IconButton(
       onPressed: onPressed, 
       icon: Icon(Icons.delete,
        color: sideColor, size: 20))),
  );
  }

ElevatedButton iconTextButtons({ required String text, IconData? iconData, required VoidCallback onPressed}) {
  return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent, 
        foregroundColor: Colors.transparent, 
      ),
      child: Row(
        children: [
          Icon(iconData, color: sideColor),
          const SizedBox(width: 20), 
          Text(
            text,
            style: TextStyle(fontSize: 17, color: sideColor, fontWeight: FontWeight.w300)
          ),
        ]));
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
          CircularProgressIndicator(valueColor: AlwaysStoppedAnimation(sideColor))
        ],
      )), 
      backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
    );
  }

AlertDialog confirmDialog(BuildContext context, VoidCallback delete, String action){
    return AlertDialog(
      content: SizedBox(
        width: 150,
        height: 200,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/idleTail2.gif',height: 120, width: 120, fit: BoxFit.cover),
          const SizedBox(height: 40),
          Text(action, style: TextStyle(fontSize: 20, color: sideColor, fontWeight: FontWeight.w300))
        ])),
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      shadowColor: Colors.transparent,
      
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: delete,
          child: Text('Yes', style: TextStyle(fontSize: 18, color: sideColor, fontWeight: FontWeight.w500))),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();},
          child: Text('No', style: TextStyle(fontSize: 18, color: sideColor, fontWeight: FontWeight.w500)))
      ]   
    );
  }

  AlertDialog resultDialog(BuildContext context, String action){
    return AlertDialog(
      content: SizedBox(
        width: 150,
        height: 200,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/idleTail2.gif',height: 120, width: 120, fit: BoxFit.cover),
          const SizedBox(height: 40),
          Text(action, style: TextStyle(fontSize: 20, color: sideColor, fontWeight: FontWeight.w300))
        ])),
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      shadowColor: Colors.transparent,
      
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  AlertDialog resultDialog2(BuildContext context, String action){
    return AlertDialog(
      content: SizedBox(
        width: 300,
        height: 220,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/idleTail2.gif',height: 120, width: 120, fit: BoxFit.cover),
          const SizedBox(height: 40),
          Text(action, style: const TextStyle(backgroundColor: Color.fromARGB(36, 160, 24, 24),
          fontSize: 17, color: Colors.redAccent, fontWeight: FontWeight.w400))
        ])),
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      shadowColor: Colors.transparent,
      
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  AlertDialog resultDialog3(BuildContext context, String action){
    return AlertDialog(
      content: SizedBox(
        width: 300,
        height: MediaQuery.of(context).size.height/6,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset('assets/idleTail2.gif',height: 50 , width: 120, fit: BoxFit.cover),
          const SizedBox(height: 10),
          Text(action, style: const TextStyle(backgroundColor: Color.fromARGB(36, 160, 24, 24),
          fontSize: 17, color: Colors.redAccent, fontWeight: FontWeight.w400))
        ])),
      backgroundColor: const Color.fromARGB(0, 0, 0, 0),
      shadowColor: Colors.transparent,
      
      actionsAlignment: MainAxisAlignment.center,
    );
  }

  TextStyle text(){
    return TextStyle(
      color: sideColor,
      fontSize: 11
    );
  }

  ButtonStyle textB(){
    return ButtonStyle(
      overlayColor: MaterialStateColor.resolveWith((Set<MaterialState> states) 
      =>sideColor.withOpacity(0.2))
    );
  }

  ButtonStyle elevB(){
    return ElevatedButton.styleFrom(
      backgroundColor: Colors.transparent,
      shape: RoundedRectangleBorder( borderRadius: BorderRadius.circular(30)),
      foregroundColor: MaterialStateColor.resolveWith((Set<MaterialState> states) 
      =>sideColor.withOpacity(0.2)),
      minimumSize: const Size(200, 55),
      side: BorderSide(
        color: sideColor,
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
                color: sideColor,
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
            labelStyle: TextStyle(color: sideColorSub, fontSize: 13),
            hintStyle: TextStyle(color: mainColorHalf),
            filled: true,
            fillColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
              if (states.contains(MaterialState.focused)) {
                return mainColorSub;
              }
              return Colors.transparent;
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
            labelStyle: TextStyle(color: sideColorSub, fontSize: 13),
            hintStyle: TextStyle(color: mainColorHalf),
            filled: true,
            fillColor: MaterialStateColor.resolveWith((Set<MaterialState> states) {
              if (states.contains(MaterialState.focused)) {
                return mainColorSub;
              }
              return Colors.transparent;
            }),
          );
        } 
  }
