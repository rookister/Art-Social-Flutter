import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:project/drawer.dart';
import 'animations.dart';
import 'group_chats.dart';
import 'home_page.dart';
import 'profile.dart';

class MainPage extends StatefulWidget{
  const MainPage({super.key});

  @override
  MainPageBuild createState() => MainPageBuild();
}

class MainPageBuild extends State<MainPage> with TickerProviderStateMixin{
  List<AnimationController>? cont;
  List<Animation<double>>? rotAnim;
  List<Animation<double>>? radAnim;
  List<Animation<double>>? traY;
  List<Animation<double>>? opac;
  int currentPage=1;
  PageController pageCont = PageController(initialPage: 1);
  String currentName='P R O F I L E';
  final List<Widget> pages= [const Profile(), const HomePage(), const Groups()];

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

  navigatingScreens(int index){
    setState(() {
      currentPage = index;
      pageCont.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.decelerate);
      if(index==0){currentName='P R O F I L E';}
      if(index==1){currentName='H O M E';}
      if(index==2){currentName='G R O U P S';}
    });
  }

  navigatingScreenPages(int index){
      if(index==0){currentName='P R O F I L E';}
      if(index==1){currentName='H O M E';}
      if(index==2){currentName='G R O U P S';}
      currentPage = index;
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SliderDrawer(
        slider: const CustomDrawer(),
          appBar: SliderAppBar(
            drawerIconSize: 24,
            drawerIconColor: Colors.white,
            appBarColor: Colors.black,
            title: Text(currentName, style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w300)),
            isTitleCenter: true,
          ),
          child: Scaffold(
            bottomNavigationBar: CurvedNavigationBar(
              index: currentPage,
              backgroundColor: Colors.black,
              color: const Color.fromARGB(255, 168, 168, 168),
              buttonBackgroundColor: Colors.white,
              animationDuration: const Duration(milliseconds: 300),
              height: 60,
              onTap: navigatingScreens,
              items: const [
                Icon(Icons.person_2_rounded),
                Icon(Icons.home_filled),
                Icon(Icons.chat_rounded)
              ],
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.black,
                  child: Animations().buildBackground(rotAnim!, radAnim!, traY!, opac!),
                ),
                PageView(
                  controller: pageCont,
                  onPageChanged: navigatingScreenPages,
                  children: pages,
                )
              ],
            ),
          ) 
      ),
    );
  }
}