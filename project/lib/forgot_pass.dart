import 'package:flutter/material.dart';
import 'package:project/login.dart';
import 'package:project/route_anim.dart';
import 'package:project/shared_prefs.dart';
import 'package:project/themes.dart';
import 'package:project/verification.dart';

class Forgor extends StatefulWidget{
  const Forgor({super.key});

  @override
  Forgot createState()=> Forgot();
}

class Forgot extends State<Forgor> {
  final emailCont = TextEditingController();
  int? status;
  Color color=Colors.white;

  void submission() async{
    showDialog(
    context: context, 
    builder: (context) {
      return Themes().loadingDialog();
    });

    status= await Verification().passwordReset(emailCont.text.trim());
    
    await Future.delayed(const Duration(milliseconds: 500),() {   
          Navigator.pop(context);});

    setState(() {
      if(status==1){
        Navigator.pushReplacement(context,
        Slide(child: const Login(), direction: AxisDirection.left));
    } else{
        color=color= const Color.fromARGB(255, 219, 34, 34);
    }
    });

  }

  @override
  Widget build(BuildContext context){
    return  FutureBuilder(
      future: setTheme(),
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done || isThemeSet) {
        return Scaffold(
          appBar: AppBar(backgroundColor: appBarColor, 
          leading: InkWell(
              onTap: () {
                Navigator.pushReplacement(context,
                Slide(child: const Login(), direction: AxisDirection.left));
              },
              child: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
            ),),
          backgroundColor: Colors.transparent,
          body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height-80,
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [mainColor2, mainColor], 
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                
                children: [
                  Image.asset( 'assets/idleTail2.gif',width: 200,height: 200, fit: BoxFit.cover),
                  const SizedBox(height: 30),
            
                  const Text('Enter your Email to get a Reset Link!', 
                  textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w300)),
                  
                  const SizedBox(height: 10),
                  Padding( 
                    padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 50), 
                    child: TextFormField(
                      scrollPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).viewInsets.bottom),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: Themes().text(),
                      decoration: Themes().textFieldDecor(
                        'Enter your Email','Email',color: color),
                        controller: emailCont,
                    )),
                  const SizedBox(height: 20),
            
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    child: ElevatedButton(
                      onPressed: submission,
                      style: Themes().elevB(),
                      child: Text('Submit', style: Themes().text()),
                  )),
                  const SizedBox(height: 150)

          ])),
        );
      }
    else{
      return Themes().loadingDialog();
    }
  }  
    );
  }

Color mainColor = Colors.black;
Color mainColor2 = Colors.black;
Color appBarColor =Colors.black;
bool theme = true;
bool isThemeSet = false;

defaultTheme(){
  mainColor = Colors.black;
  mainColor2 = Colors.black;
  appBarColor =Colors.black;
}

secondTheme(){
  mainColor = const Color.fromARGB(255, 111, 76, 157);
  mainColor2 = const Color.fromARGB(255, 185, 108, 188);
  appBarColor = const Color.fromARGB(255, 117, 74, 174);
}

setTheme() async{
  theme = await Preferences().getTheme();
      if(theme){defaultTheme();}
      else{secondTheme();}
      isThemeSet = true;
}

}