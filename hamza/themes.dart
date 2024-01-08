import 'package:flutter/material.dart';

class Themes{

Padding pfp(String? image, VoidCallback pressed){
 return Padding(
  padding: const EdgeInsets.only(right: 20,top : 90),
  child: CircleAvatar(
  radius: 72,
  backgroundColor: Colors.white,
  child: CircleAvatar(
    radius: 71,
    backgroundImage: (image==null) ? const AssetImage('assets/noPFP.jpg') as ImageProvider : NetworkImage(image),
    child: Padding(
      padding: const EdgeInsets.only(top: 90),
      child: Opacity(
        opacity: (image==null) ? 1 : 0.8,
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(194, 51, 51, 51)),
          child: IconButton(
            onPressed: pressed, 
            icon: const Icon(Icons.add_a_photo, size: 20))
        ),
      )))));
}

Container background(BuildContext context, String? image){
  return Container(
    width:  MediaQuery.of(context).size.width, height: 200,
    decoration: const BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Color.fromARGB(255, 0, 0, 0), 
          width: 2.0, 
      ))),
    child: (image==null) ? Image.asset('assets/noBG.jpg',fit: BoxFit.cover ) : Image.network(image,fit: BoxFit.cover ));
}

Padding bgEdit(VoidCallback pressed){
  return Padding(
    padding: const EdgeInsets.only(left: 360,top: 10),
    child: Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(194, 51, 51, 51),),
      child: IconButton(
        onPressed: pressed, 
        icon: const Icon(Icons.upload,color: Colors.white))),
    );
}

Container aboutSection( BuildContext context,
  {required TextEditingController controller, required bool isUnderlined, required String? text}) {
    text ??= 'Write Something About Yourself!';
    return Container(
        decoration: BoxDecoration(
          border: isUnderlined ? Border.all(color: Colors.transparent) : Border.all(color: Colors.white, width: 0.5),
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
            style: const TextStyle( fontSize: 14, color: Colors.white, fontWeight: FontWeight.w100),
            decoration: const InputDecoration(
              border: InputBorder.none
              )
          ),
        )
    );
  }

Padding profileFields(
  {required TextEditingController controller, required bool isUnderlined, required String? text}) {
    text ??= 'Set a Username';
    TextPainter textPainter = TextPainter(text: TextSpan(text: text, style: const TextStyle( fontSize: 17, fontWeight: FontWeight.w400)), textDirection: TextDirection.ltr); textPainter.layout();
    double padding=30;
    if(text.length<6){padding =41;} else if(text.length>9){padding = 20;}
    return Padding(
    padding: EdgeInsets.only(left: padding,top: 5),
    child: Row(
      children: [
        const Text('@',style: TextStyle(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w400)),
        SizedBox(
        width: textPainter.width+2,
        child: TextFormField(
          controller: controller..text = text,
          enabled: !isUnderlined,
          style: TextStyle(decoration: isUnderlined? TextDecoration.none : TextDecoration.underline,
            fontSize: 17, color: Colors.white, fontWeight: FontWeight.w400),
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
     decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(194, 51, 51, 51),),
     child: IconButton(
     onPressed: onPressed, 
     icon: Icon(icon ? Icons.edit : Icons.done_rounded,
      color: Colors.white, size: iconSize)));
  }

Padding addButton(VoidCallback onPressed, double size, double iconSize, bool icon){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 40),
    child: Container(
       width: size,
       height: size,
       decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(194, 51, 51, 51),),
       child: IconButton(
       onPressed: onPressed, 
       icon: Icon(icon ? Icons.add : Icons.done_rounded,
        color: Colors.white, size: iconSize))),
  );
  }

Padding deleteButton(VoidCallback onPressed){
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    child: Container(
       width: 40,
       height: 40,
       decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(194, 30, 30, 30),),
       child: IconButton(
       onPressed: onPressed, 
       icon: const Icon(Icons.delete,
        color: Colors.white, size: 20))),
  );
  }

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
      backgroundColor: Colors.transparent,
    );
  }

AlertDialog confirmDialog(BuildContext context, VoidCallback delete){
    return AlertDialog(
      content: SizedBox(
        width: 150,
        height: 200,
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/idleTail2.gif',height: 120, width: 120, fit: BoxFit.cover),
          const SizedBox(height: 40),
          const Text('Are you sure?', style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.w300))
        ])),
      backgroundColor: Colors.transparent,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: delete,
          child: const Text('Yes', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500))),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();},
          child: const Text('No', style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w500)))
      ]   
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
