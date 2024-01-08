// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/shared_prefs.dart';
import 'package:project/themes.dart';

class AddMembersINGroup extends StatefulWidget {
  final String groupChatId, name;
  final List membersList;
  const AddMembersINGroup(
      {required this.name,
      required this.membersList,
      required this.groupChatId,
      super.key});

  @override
  AddMembersINGroupState createState() => AddMembersINGroupState();
}

class AddMembersINGroupState extends State<AddMembersINGroup> {
  final TextEditingController _search = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;
  bool isLoading2 = false;
  Map<String, dynamic>? userMap;
  bool found = false;
  bool first = false;
  bool init = false;
  bool isAlreadyExist = false;

  @override
  void initState() {
    super.initState();
  }

  void onSearch() async {
    FocusScope.of(context).unfocus();
    setState(() {
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

  onResultTap() async {
    isAlreadyExist = false;
    for (int i = 0; i < widget.membersList.length; i++) {
      if (widget.membersList[i]['uid'] == userMap!['uid']) {
        setState(() {
                  isAlreadyExist = true;
        });
      }
    }
    if (!isAlreadyExist) {
      widget.membersList.add(userMap);
      await _firestore.collection('groups').doc(widget.groupChatId).update({
      "members": widget.membersList});
      await _firestore
        .collection('Users')
        .doc(userMap!['email'])
        .collection('groups')
        .doc(widget.groupChatId)
        .set({"name": widget.name, "id": widget.groupChatId});
        setState(() {
                userMap = null;
        });
      showDialog(
      context: context,
      builder: (context) {
        return Themes().resultDialog(context,'Successfully Added');});
    }
   
  }


  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: setTheme(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done || isThemeSet ) {
        return isLoading2 ?
        Themes().loadingDialog() 
        :
        Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: const Text("A D D  M E M B E R S", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w300)),
            centerTitle: true
          ),
          body: SingleChildScrollView(
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
                     const Text("No Record Found!",
                     style: TextStyle(fontSize: 20, color: Colors.white, 
                     fontWeight: FontWeight.w300),textAlign: TextAlign.center)]),
                 )
                : isAlreadyExist ? 
                  Container(
                  padding: const EdgeInsets.only(bottom: 0, top: 10),
                   child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                     children: [
                      Image.asset('assets/idleTail2.gif',height: 150),
                     const Text( "User Already Exists!",
                     style: TextStyle(fontSize: 20, color: Colors.white, 
                     fontWeight: FontWeight.w300),textAlign: TextAlign.center)]),
                 )
                : 
                userMap != null ? 
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
