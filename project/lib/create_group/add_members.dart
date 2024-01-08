// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/create_group/create_group.dart';
import 'package:project/route_anim.dart';
import 'package:project/shared_prefs.dart';
import 'package:project/themes.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({super.key});

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> membersList = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;
  bool found = false;
  bool first = false;
  bool init = false;
  bool noUN = false;

  @override
  void initState() {
    getCurrentUserDetails();
    super.initState();
  }

 getCurrentUserDetails() async {
  await _firestore
      .collection('Users')
      .doc(_auth.currentUser!.email)
      .get()
      .then((map) {
    var data = map.data();
    if (data != null) {
      setState(() {
        String? pfp;
        String un ='';
      if (data.containsKey('username')){un = data['username'];} else{noUN=true;}
      if (data.containsKey('pfp')){pfp = data['pfp'];}
        membersList.add({
          "pfp": pfp,
          "username": un,
          "email": data['email'],
          "uid": data['uid'],
          "isAdmin": true,
        });
      });
    }
  });
      init = true;
}


onSearch() async {
  FocusScope.of(context).unfocus();
  setState(() {
    first = true;
    found = false;
    isLoading = true;
  });

  await _firestore
      .collection('Users')
      .where("username", isEqualTo: _search.text.trim())
      .get()
      .then((value) {
    if (value.docs.isNotEmpty) {
      setState(() {
        userMap = value.docs[0].data();
        found = true;
      });
    } else {
      setState(() {
        found = false;
      });
    }
  }).whenComplete(() {
    setState(() {
      isLoading = false;
    });
  });
}


onResultTap() {
    bool isAlreadyExist = false;

    for (int i = 0; i < membersList.length; i++) {
      if (membersList[i]['uid'] == userMap!['uid']) {
        isAlreadyExist = true;
      }
    }

    if (!isAlreadyExist) {
      setState(() {
        membersList.add({
          "pfp": userMap!['pfp'],
          "username": userMap!['username'],
          "email": userMap!['email'],
          "uid": userMap!['uid'],
          "isAdmin": false,
        });

        userMap = null;
      });
    }
    else{

    }
  }

  void onRemoveMembers(int index) {
    if (membersList[index]['uid'] != _auth.currentUser!.uid) {
      setState(() {
        membersList.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: setTheme(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done || (isThemeSet && init)) {
        return 
        SafeArea(
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: appBarColor,
              title: const Text("A D D  M E M B E R S", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w300)),
              centerTitle: true
            ),
            body:  SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height-80,
                decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [mainColor, mainColor2], 
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter)),
                child: Column(
                  children: [
                    Flexible(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height/6,
                        child: ListView.builder(
                          itemCount: membersList.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return noUN?  Themes().resultDialog3(context, 'Please set a Username first!') : ListTile(
                              onTap: () => onRemoveMembers(index),
                              leading: CircleAvatar(
                                backgroundColor: Colors.white,
                                radius: 20,
                                child: CircleAvatar(
                                  backgroundColor: mainColor2,
                                  radius: 19,
                                  backgroundImage: membersList[index]['pfp']==null ? 
                                  const AssetImage('assets/noPFP.jpg' ) as ImageProvider : NetworkImage(membersList[index]['pfp']), 
                                ),
                              ),
                              title: Text(membersList[index]['username'],style: const TextStyle(color: Colors.white)),
                              subtitle: Text(membersList[index]['email'],style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w300)),
                              trailing: index==0? const Icon(Icons.star, color: Colors.white) : const Icon(Icons.close, color: Colors.white),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height / 20,
                    ),
                    Padding( 
                  padding: const EdgeInsets.symmetric(horizontal: 50), 
                  child: TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    style: Themes().text(),
                    decoration: Themes().textFieldDecor(
                      'Who are you looking for?','Username',color: Colors.white),
                      controller: _search,
                  )),
                    SizedBox(
                      height: size.height / 50,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 140),
                      child: ElevatedButton(
                        onPressed: () => onSearch(),
                        style: Themes().elevB(),
                        child: Text('Search', style: Themes().text()),
                    )),
                    SizedBox(
                      height: size.height / 20,
                    ),
                     isLoading
                        ? Themes().loadingDialog() : 
                    !found 
                   ? Container(
                    padding: const EdgeInsets.only(bottom: 0, top: 10),
                     child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                       children: [
                        Image.asset('assets/idleTail2.gif',height: 150),
                       Text( first ? "No Record Found!" : '',
                       style: const TextStyle(fontSize: 20, color: Colors.white, 
                       fontWeight: FontWeight.w300),textAlign: TextAlign.center)]),
                   )
                  : userMap != null ? 
                  ListTile(
                          onTap: onResultTap,
                          leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 20,
                              child: CircleAvatar(
                                backgroundColor: mainColor2,
                                radius: 19,
                                backgroundImage: userMap!['pfp']==null ? 
                                const AssetImage('assets/noPFP.jpg' ) as ImageProvider : NetworkImage(userMap!['pfp']), 
                              ),
                            ),
                          title: Text(userMap!['username'],style: const TextStyle(color: Colors.white)),
                          subtitle: Text(userMap!['email'],style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w300)),
                          trailing: const Icon(Icons.add, color: Colors.white),
                        ) : const SizedBox()
                  ],
                ),
              ),
            ),
            floatingActionButton: (membersList.length >= 2 && !noUN)
                ? Container(
                  decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white, 
                          width: 1.5),
                  borderRadius: BorderRadius.circular(50.0)),
                  child: FloatingActionButton(
                      heroTag: 'AddMemsTag',
                      backgroundColor: mainColor,
                      child: const Icon(Icons.forward, color: Colors.white),
                      onPressed: () => Navigator.of(context).push(
                        Fade(
                          child: CreateGroup(
                            membersList: membersList,
                          ),
                        ),
                      ),
                    ),
                )
                : const SizedBox(),
          ),
        );
      }
      else{
        return Themes().loadingDialog();
      }}
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
