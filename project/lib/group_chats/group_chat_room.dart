import 'package:flutter/material.dart';
import 'package:project/animations.dart';
import 'package:project/group_chats/chatTab.dart';
import 'package:project/group_chats/group_info.dart';
import 'package:project/group_chats/imageTab.dart';
import 'package:project/route_anim.dart';
import 'package:project/shared_prefs.dart';
import 'package:project/themes.dart';

class GroupChatRoom extends StatefulWidget {
  final String groupChatId, groupName;
  const GroupChatRoom({required this.groupName, required this.groupChatId, super.key});
  @override
  State<GroupChatRoom> createState() => _GroupChatRoomState();
}

class _GroupChatRoomState extends State<GroupChatRoom>  with TickerProviderStateMixin{
  List<AnimationController>? cont;
  List<Animation<double>>? rotAnim;
  List<Animation<double>>? radAnim;
  List<Animation<double>>? traY;
  List<Animation<double>>? opac;
  late TabController tabCont;

  @override
  void initState() {
    super.initState();
    tabCont = TabController(length: 2, vsync: this);
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
  tabCont.dispose();
  super.dispose();
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setTheme(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done || isThemeSet) {
        return Stack(
            alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
              gradient: LinearGradient(
              colors: [mainColor2, mainColor], 
              begin: Alignment.topLeft,
              end: Alignment.bottomRight)),
              child: Opacity( opacity: opacity, child: Animations().buildBackground(rotAnim!, radAnim!, traY!, opac!))),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                backgroundColor: appBarColor,
                title: Text(widget.groupName, style: const TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w300)),
                centerTitle: true,
                actions: [
                  IconButton(
                      onPressed: () => Navigator.of(context).push(
                            Fade(
                              child: GroupInfo(
                                groupName: widget.groupName,
                                groupId: widget.groupChatId,
                              ),
                            ),
                          ),
                      icon: const Icon(Icons.more_vert)),
                ],
              ),
              body: Column(
                children: [
                  Container(
                    decoration: BoxDecoration( color: mainColor, border: const Border(bottom: BorderSide(color: Colors.white))),
                    child: TabBar(
                      indicator: BoxDecoration( color: selColor),
                      controller: tabCont,
                      tabs: const [
                        Tab(
                          icon: Icon( Icons.image, color: Colors.white)),
                        Tab(
                          icon: Icon( Icons.chat, color: Colors.white))]
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: tabCont,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0),
                          child: PageNoDie(child: ImageTab(groupName: widget.groupName, groupChatId: widget.groupChatId))),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          child: PageNoDie(child: ChatTab(groupName: widget.groupName, groupChatId: widget.groupChatId))),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      } else{ return Themes().loadingDialog();}
      }
    );
  }

  Color  mainColor = Colors.black;
  Color  mainColor2 = Colors.black;
  Color  appBarColor = Colors.black;
  Color selColor = const Color.fromARGB(184, 39, 39, 39);
  double opacity = 1;

  defaultTheme(){
  mainColor = Colors.black;
  mainColor2 = Colors.black;
  appBarColor = Colors.black;
  selColor = const Color.fromARGB(184, 39, 39, 39);
  opacity = 1;
  }

  secondTheme(){
  mainColor = const Color.fromARGB(255, 111, 76, 157);
  mainColor2 = const Color.fromARGB(255, 185, 108, 188);
  appBarColor = const Color.fromARGB(255, 120, 66, 190);
  selColor = const Color.fromARGB(40, 0, 0, 0);
  opacity = 0.5;
  }

bool theme = true;
bool isThemeSet = false;

setTheme() async{
  theme = await Preferences().getTheme();
      if(theme){defaultTheme();}
      else{secondTheme();}
      isThemeSet = true;
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
