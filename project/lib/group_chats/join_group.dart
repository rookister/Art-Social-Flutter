import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:project/create_group/add_members.dart';
import 'package:project/group_chats/group_chat_room.dart';
import 'package:project/route_anim.dart';
import 'package:project/shared_prefs.dart';
import 'package:project/themes.dart';

class JoinGroup extends StatefulWidget {
  const JoinGroup({super.key});

  @override
  JoinGroupScreenState createState() => JoinGroupScreenState();
}

class JoinGroupScreenState extends State<JoinGroup>{
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getAvailableGroups();
  }

List groupList = [];

Future<void> getAvailableGroups() async {
  await _firestore
      .collection('Users')
      .doc(_auth.currentUser!.email)
      .collection('groups')
      .get()
      .then((value) {
    setState(() {
      groupList = value.docs.map((doc) {
            Map<String, dynamic>? data = doc.data();
            String? pic = data['pic'];
            String picUrl = (pic != null && pic.isNotEmpty) ? pic : '';
            return {
              'name': data['name'],
              'id': data['id'],
              'pic': picUrl,
            };
          })
          .toList();
          isLoading = false;
    });
  });
}


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: switchTheme(),
        builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.done || isThemeSet) {
     return Scaffold(
      backgroundColor: Colors.transparent,
           body: isLoading ?
           Themes().loadingDialog() 
           :
           LiquidPullToRefresh(
             color: const Color.fromARGB(95, 42, 42, 42),
              height: 100,
              animSpeedFactor: 2.5,
              showChildOpacityTransition: true,
            onRefresh: getAvailableGroups,
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              children: List.generate(
              groupList.length, ((index) => 
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    Fade(
                      child: GroupChatRoom(
                        groupName: groupList[index]['name'],
                        groupChatId: groupList[index]['id'],
                      ),
                    ),
                  ),
                  child: SizedBox(
                    height: 100,
                    width: 100,
                    child: Column(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 35,
                          child: CircleAvatar(
                            backgroundColor: mainColor,
                            radius: 34,
                            backgroundImage: (groupList[index]['pic'] != '')
                              ? NetworkImage(groupList[index]['pic'])
                              : const AssetImage('assets/normalGroups.jpg') as ImageProvider,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(groupList[index]['name'], style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w300),),
                      ],
                    ),
                  ),
                )
              )
            )
            ),
          ),
          floatingActionButton: Container(
                decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white, 
                        width: 1.5),
                borderRadius: BorderRadius.circular(50.0)),
                child: FloatingActionButton(
                    elevation: 0,
                    heroTag: 'AddGroupsTag',
                    backgroundColor: Colors.transparent,
                    child: const Icon(Icons.add, color: Colors.white),
                    onPressed: () => Navigator.of(context).push(
                      Fade(
                        child: const AddMembersInGroup()
                      ),
                    ),
                  ),
              ),
          );
        }else{
        return Themes().loadingDialog();
      }}
      );
  }

Color? mainColor;
bool theme = true;
bool isThemeSet = false;

  switchTheme() async{
      theme = await Preferences().getTheme();
      if(theme){mainColor = Colors.black; }
      else{mainColor = const Color.fromARGB(255, 111, 76, 157);}
      isThemeSet = true;
}
}
