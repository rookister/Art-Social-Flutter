import 'package:flutter/material.dart';
import 'package:project/shared_prefs.dart';
import 'forgot_pass.dart';
import 'verification.dart';
import 'animations.dart';
import 'main_page.dart';
import 'route_anim.dart';
import 'themes.dart'; 
import 'register.dart';

class Login extends StatefulWidget{
  const Login({super.key});

  @override
  LoginPage createState() => LoginPage();
}

class LoginPage extends State<Login> with TickerProviderStateMixin{
List<AnimationController>? cont;
List<Animation<double>>? rotAnim;
List<Animation<double>>? radAnim;
List<Animation<double>>? traY;
List<Animation<double>>? opac;
final emailCont = TextEditingController();
final passCont = TextEditingController(); 
bool visible=false;
int? status;
Color color=Colors.white;

@override
void initState(){
  super.initState();
  cont = Animations().conter(cont, this);
  rotAnim = Animations().rotAnim(cont);
  radAnim = Animations().radAnim(cont);
  traY = Animations().traY(cont);
  opac = Animations().opac(cont);
  Animations().setup(() { setState(() {});}, cont);
}

@override
void dispose(){
  Animations().dispose(cont);
  super.dispose();
}

Color mainColor = Colors.black;
Color mainColor2 = Colors.black;
bool theme = true;
bool isThemeSet = false;

defaultTheme(){
  mainColor = Colors.black;
  mainColor2 = Colors.black;
}

secondTheme(){
  mainColor = const Color.fromARGB(255, 111, 76, 157);
  mainColor2 = const Color.fromARGB(255, 185, 108, 188);
}

setTheme() async{
  theme = await Preferences().getTheme();
      if(theme){defaultTheme();}
      else{secondTheme();}
      isThemeSet = true;
}

  @override
  Widget build(BuildContext context){
  return FutureBuilder(
    future: setTheme(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done || isThemeSet) {
      return Stack(
      alignment: Alignment.center,
      children:[
      Card(
          child: Container(
          decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [mainColor2, mainColor], 
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            
            children: [
              Image.asset( 'assets/groom2.gif',width: 200,height: 200, fit: BoxFit.cover),
              const SizedBox(height: 50),
              
              Padding( 
                padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 50), 
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: Themes().text(),
                  decoration: Themes().textFieldDecor(
                    'Enter your Email','Email',color: color),
                    controller: emailCont,
                )),
              const SizedBox(height: 20),
      
              Padding( 
                padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 50), 
                child: TextFormField(
                  obscureText: !visible,
                  style: Themes().text(),
                  decoration: Themes().passFieldDecor(
                    'Enter your Password','Password',visible,
                      (){ setState ( () {visible=!visible;} );},color: color),
                  controller: passCont,
                )),
      
              Padding(
                padding: const EdgeInsets.only(left: 210),
                child: TextButton(
                  style: Themes().textB(), 
                  child: Text('Forgot Password?', style: Themes().text()),
                  onPressed: (){
                    Navigator.pushReplacement(context,
                      Slide(child: const Forgor(),direction: AxisDirection.right));
                  },
                )),
              const SizedBox(height: 20),
              
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: ElevatedButton(
                  onPressed: signIn,
                  style: Themes().elevB(),
                  child: Text('Sign In', style: Themes().text()),
              )),
              const SizedBox(height: 60),
      
              Text('Or continue with',style: Themes().text()),
              const SizedBox(height: 5),
              
              IconButton(
                onPressed: googlesignIn, 
                icon: Image.asset('assets/googleLogo.png',height: 100, fit: BoxFit.cover),
                iconSize: 55,
                ),
              const SizedBox(height: 60),
      
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: TextButton(
                  style: Themes().textB(), 
                  child: Text('New Here?', style: Themes().text()),
                  onPressed: () {
                Navigator.push(context,
                    Fade(child: const Register()));
                    },
                  
                )),
            ],
         ), 
        )),
        Animations().buildBackground(rotAnim!, radAnim!, traY!, opac!),   
      ]);
    }
    else{
      return Themes().loadingDialog();
    }  
  }
  );
  }

void googlesignIn() async {
    showDialog(
    context: context, 
    builder: (context) {
      return Themes().loadingDialog();
    });

  await Verification().signInWithGoogle();
  
  await Future.delayed(const Duration(milliseconds: 500),() {   
          Navigator.pop(context);});

  setState(() {
    Navigator.pushReplacement(context,
        Slide(child: const MainPage(),direction: AxisDirection.down));
  });

}

void signIn() async {
  showDialog(
    context: context, 
    builder: (context) {
      return Themes().loadingDialog();
    }
    );
  status = await Verification().signUserIn(emailCont.text.trim(),passCont.text.trim());

  await Future.delayed(const Duration(milliseconds: 500),() {   
          Navigator.pop(context);});

    setState(() {
      if(status==1){                    
        Navigator.pushReplacement(context,
        Slide(child: const MainPage(),direction: AxisDirection.down));}
      else{ 
          color= const Color.fromARGB(255, 219, 34, 34);
        }
      });
  }
}





