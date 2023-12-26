import 'package:flutter/material.dart';
import 'package:project/animations.dart';
import 'package:project/main_page.dart';
import 'package:project/route_anim.dart';
import 'package:project/shared_prefs.dart';
import 'package:project/verification.dart';
import 'themes.dart';

class Register extends StatefulWidget{
  const Register({super.key});

  @override
  RegPage createState() => RegPage();
}

class RegPage extends State<Register> with TickerProviderStateMixin{
List<AnimationController>? cont;
List<Animation<double>>? rotAnim;
List<Animation<double>>? radAnim;
List<Animation<double>>? traY;
List<Animation<double>>? opac; 
final emailCont = TextEditingController();
final passCont = TextEditingController(); 
final confPassCont = TextEditingController(); 
bool visible=false;
bool visibleC=false;
int? status;
Color color=Colors.white;
Color colorC=Colors.white;
Color colorP=Colors.white;

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
      return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Stack(
        alignment: Alignment.center,
        children:[
        Card(
          child: Container(
          constraints: BoxConstraints.expand(
            height: MediaQuery.of(context).size.height+10
          ), 
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [mainColor2, mainColor], 
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                Image.asset( 'assets/idleTail.gif',width: 200,height: 200, fit: BoxFit.cover),
                const SizedBox(height: 50),
                
                Padding( 
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 50), 
                  child: TextFormField(
                    style: Themes().text(),
                    controller: emailCont,
                    decoration: Themes().textFieldDecor(
                      'Enter your Email','Email',color: color),
                  )),
                const SizedBox(height: 2),
      
                Padding( 
                  padding: const EdgeInsets.symmetric(vertical: 0,horizontal: 50), 
                  child: TextFormField(
                    obscureText: !visible,
                    controller: passCont,
                    style: Themes().text(),
                    decoration: Themes().passFieldDecor(
                      'Create a Password','Password',visible,
                        (){ setState ( () {visible=!visible;} );},color: colorP)
                  )),
                const SizedBox(height: 2),
  
                Padding( 
                  padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 50), 
                  child: TextFormField(
                    obscureText: !visibleC,
                    controller: confPassCont,
                    style: Themes().text(),
                    decoration: Themes().passFieldDecor(
                      'Confirm Password','Confirmation',visibleC,
                        (){ setState ( () {visibleC=!visibleC;} );},color: colorC)
                  )),
                const SizedBox(height: 30),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: ElevatedButton(
                    onPressed: register,
                    style: Themes().elevB(),
                    child: Text('Register', style: Themes().text()),
                )),
                const SizedBox(height: 60),
                
                Text('Or continue with',style: Themes().text()),
                const SizedBox(height: 5),
                
                IconButton(
                  onPressed: googlesignIn, 
                  icon: Image.asset('assets/googleLogo.png',height: 100, fit: BoxFit.cover),
                  iconSize: 55,
                  ),
                const SizedBox(height: 50),
      
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 0),
                  child: TextButton(
                    style: Themes().textB(), 
                    child: Text('Already a User?', style: Themes().text()),
                    onPressed: (){ 
                      Navigator.pop(context);},
                  )),
              ],
           ), 
          )
          ),
          Animations().buildBackground(rotAnim!, radAnim!, traY!, opac!),  
        ]
        ),
      );
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

void register() async{
  showDialog(
    context: context, 
    builder: (context) {
      return Themes().loadingDialog();
    });
          
  if(confPassCont.text.trim()==passCont.text.trim()){
    status= await Verification().createUser(emailCont.text.trim(),passCont.text.trim());

    setState(() { 
      if(status==1){                     
        Navigator.pop(context);}
      else{
          color= const Color.fromARGB(255, 219, 34, 34);
          colorP= const Color.fromARGB(255, 219, 34, 34);
        }
      });}
    else{
      setState(() {
        colorC= const Color.fromARGB(255, 219, 34, 34);
        colorP= const Color.fromARGB(255, 219, 34, 34);        
      });}
      
  await Future.delayed(const Duration(milliseconds: 500),() {   
          Navigator.pop(context);});
}

}