import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:project/drawer.dart';
import 'package:project/shared_prefs.dart';
import 'package:project/themes.dart';
import 'search_profile.dart';
import 'animations.dart';
import 'group_chats.dart';
import 'profile.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  MainPageBuild createState() => MainPageBuild();

  static void updateTheme() async {}
}

class MainPageBuild extends State<MainPage> with TickerProviderStateMixin{
  List<AnimationController>? cont;
  List<Animation<double>>? rotAnim;
  List<Animation<double>>? radAnim;
  List<Animation<double>>? traY;
  List<Animation<double>>? opac;
  int currentPage=1;
  PageController pageCont = PageController(initialPage: 1);
  String currentName='G R O U P S';
  final List<Widget> pages= [const PageNoDie(child: Profile()),
  const PageNoDie(child: Groups()),const PageNoDie(child: SearchProfile())];
  bool theme=true;
  bool isThemeSet = false;

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

  setTheme() async{
  theme = await Preferences().getTheme();
      if(theme){defaultTheme();}
      else{secondTheme();}
      isThemeSet = true;
  }
  

  navigatingScreens(int index){
    setState(() {
      currentPage = index;
      pageCont.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
      if(index==0){currentName='P R O F I L E';}
      if(index==1){currentName='G R O U P S';}
      if(index==2){currentName='S E A R C H';}
    });
  }

  navigatingScreenPages(int index){
      if(index==0){currentName='P R O F I L E';}
      if(index==1){currentName='G R O U P S';}
      if(index==2){currentName='S E A R C H';}
      currentPage = index;
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
    future: setTheme(),
    builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done || isThemeSet) {
      isThemeSet= true;
      return Scaffold(
        body: SliderDrawer(
          slider: const CustomDrawer(),
          appBar: SliderAppBar(
            drawerIconSize: 24,
            drawerIconColor: Colors.white,
            appBarColor: appBarColor!,
            title: Text(currentName, style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w300)),
            isTitleCenter: true,
          ),
          child: Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              index: currentPage,
              backgroundColor: mainColor2!,
              color: subColor!,
              buttonBackgroundColor: sideColor,
              animationDuration: const Duration(milliseconds: 300),
              height: 60,
              onTap: navigatingScreens,
              items: [
                Icon(Icons.person_2_rounded, color: iconColor!),
                Icon(Icons.chat_rounded, color: iconColor!),
                Icon(Icons.search, color: iconColor!),
              ],
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [mainColor!, mainColor2!],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Animations().buildBackground(rotAnim!, radAnim!, traY!, opac!),
                ),
                PageView(
                  controller: pageCont,
                  onPageChanged: navigatingScreenPages,
                  children: pages,
                ),
                Positioned(
                  left: 0, right: 0, top: (MediaQuery.of(context).size.height * 0.825) + 6, height: 14,
                  child: Container(
                    color: mainColor2!,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      return Themes().loadingDialog();
    }
  },
);

  }


  Color? mainColor;
  Color? mainColor2;
  Color? sideColor;
  Color? subColor;
  Color? iconColor;
  Color? appBarColor;

  defaultTheme(){
  mainColor = Colors.black;
  mainColor2 = Colors.black;
  appBarColor = Colors.black;
  sideColor = Colors.white;
  subColor = const Color.fromARGB(255, 204, 204, 204);
  iconColor = Colors.black;
  }

  secondTheme(){
  mainColor = const Color.fromARGB(255, 111, 76, 157);
  mainColor2 = const Color.fromARGB(255, 185, 108, 188);
  appBarColor = const Color.fromARGB(255, 117, 74, 174);
  subColor = const Color.fromARGB(255, 95, 60, 140);
  sideColor = const Color.fromARGB(255, 117, 74, 174);
  iconColor = Colors.white;
  }

}

class PageNoDie extends StatefulWidget {
  const PageNoDie({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  PageNoDieState createState() => PageNoDieState();
}

class PageNoDieState extends State<PageNoDie>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}