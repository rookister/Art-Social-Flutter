import 'package:flutter/material.dart';
import 'package:project/login.dart';
import 'package:project/route_anim.dart';
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
    return  Scaffold(
      appBar: AppBar(backgroundColor: Colors.black, 
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
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 50,bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Card(
            color: const Color.fromARGB(255, 0, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                Image.asset( 'assets/idleTail2.gif',width: 200,height: 200, fit: BoxFit.cover),
                const SizedBox(height: 30),
          
                const Text('Enter your Email to get a Reset Link!', 
                textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w200)),
                
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
                const SizedBox(height: 60)
          
        ])),
      ),
    );
  }
}