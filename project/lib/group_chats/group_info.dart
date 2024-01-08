import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/group_chats/add_members.dart';
import 'package:project/shared_prefs.dart';
import 'package:project/themes.dart';

class GroupInfo extends StatefulWidget {
  final String groupId, groupName;
  const GroupInfo({required this.groupId, required this.groupName, super.key});

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  List membersList = [];
  bool isLoading = true;
  String pic = '';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    getGroupDetails();
  }

  Future getGroupDetails() async {
    await _firestore
        .collection('groups')
        .doc(widget.groupId)
        .get()
        .then((chatMap) {
      membersList = chatMap['members'];
      if(chatMap['pic']!=null){
        pic = chatMap['pic'];}
      isLoading = false;
      setState(() {});
    });
  }

  bool checkAdmin() {
    bool isAdmin = false;

    for (var element in membersList) {
      if (element['uid'] == _auth.currentUser!.uid) {
        isAdmin = element['isAdmin'];
      }
    }
    return isAdmin;
  }

  Future removeMembers(int index) async {
    String email = membersList[index]['email'];
    String name = membersList[index]['username'];

    setState(() {
      isLoading = true;
      membersList.removeAt(index);
    });

    await _firestore.collection('groups').doc(widget.groupId).collection('chats').add({
      "message": "$name was removed.",
      "type": "notify",
      "time": FieldValue.serverTimestamp(),
    });

    await _firestore.collection('groups').doc(widget.groupId).update({
      "members": membersList,
    }).then((value) async {
      await _firestore
          .collection('users')
          .doc(email)
          .collection('groups')
          .doc(widget.groupId)
          .delete();

      if(membersList.isEmpty){
            await deleteDocumentAndSubcollections('groups', widget.groupId);
          }

      setState(() {
        isLoading = false;
      });
    });
        
  }

  void showDialogBox(int index) {
    if (checkAdmin()) {
      if (_auth.currentUser!.uid != membersList[index]['uid']) {
        showDialog(
            context: context,
            builder: (context) {
              return Themes().confirmDialog(context, () async { 
          await Future.delayed(const Duration(milliseconds: 10),() {Navigator.pop(context);});
          removeMembers(index);
        }, 'Remove This Member?');
      });
      }
    }
  }

 Future<void> deleteDocumentAndSubcollections(String collectionPath, String documentId) async {
  final DocumentReference documentReference =
      FirebaseFirestore.instance.collection(collectionPath).doc(documentId);

  final QuerySnapshot subcollectionsSnapshot = await documentReference.collection(documentId).get();

  for (QueryDocumentSnapshot subcollection in subcollectionsSnapshot.docs) {
    await deleteDocumentAndSubcollections(documentReference.path, subcollection.id);
  }
  await documentReference.delete();
}

  Future onLeaveGroup() async {
    showDialog(
      context: context,
      builder: (context) {
        return Themes().confirmDialog(context, () async { 
          await Future.delayed(const Duration(milliseconds: 10),() {Navigator.pop(context);});
            setState(() {
            isLoading = true;
          });

          for (int i = 0; i < membersList.length; i++) {
            if (membersList[i]['uid'] == _auth.currentUser!.uid) {
              membersList.removeAt(i);
            }
          }

          await _firestore.collection('groups').doc(widget.groupId).update({
            "members": membersList,
          });

          await _firestore
              .collection('Users')
              .doc(_auth.currentUser!.email)
              .collection('groups')
              .doc(widget.groupId)
              .delete();

          if(membersList.isEmpty){
            await deleteDocumentAndSubcollections('groups', widget.groupId);
          }
          
          else{
          await _firestore.collection('groups').doc(widget.groupId).collection('chats').add({
          "message": "${_auth.currentUser!.displayName} Left This Group.",
          "type": "notify",
          "time": FieldValue.serverTimestamp()
        });}
        getout();  
        }, 'Are you sure?');
      });
  }
      getout(){
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: setTheme(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done || (isThemeSet)) {
        return SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height-80,
                  decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [mainColor, mainColor2], 
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: isLoading
                  ? Themes().loadingDialog()
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: BackButton( color: Colors.white),
                          ),
                          SizedBox(
                            height: size.height / 8,
                            width: size.width / 1.1,
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  radius: 37,
                                  child: CircleAvatar(
                                    backgroundColor: mainColor,
                                    radius: 34,
                                    backgroundImage: (pic != '')
                                      ? NetworkImage(pic)
                                      : const AssetImage('assets/normalGroups.jpg') as ImageProvider,
                                  ),
                                ),
                                SizedBox(
                                  width: size.width / 15,
                                ),
                                Expanded(
                                  child: Text(
                                    widget.groupName,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: size.width / 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height / 20,
                          ),
          
                          SizedBox(
                            width: size.width / 1.1,
                            child: Text(
                              "${membersList.length} Members",
                              style: TextStyle(
                                fontSize: size.width / 25,
                                color: Colors.white,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                         SizedBox(
                            height: size.height / 40,
                          ),
                          const Divider(
                            thickness: 0.5, color: Colors.white, 
                          ),
          
                          SizedBox(
                            height: size.height / 40,
                          ),
          
                          checkAdmin()
                              ? ListTile(
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => AddMembersINGroup(
                                        groupChatId: widget.groupId,
                                        name: widget.groupName,
                                        membersList: membersList,
                                      ),
                                    ),
                                  ),
                                  leading: const Icon(
                                    Icons.add, color: Colors.white,
                                  ),
                                  title: Text(
                                    "Add Members",
                                    style: TextStyle(
                                      fontSize: size.width / 30,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w300,
                                    ),
                                  ),
                                )
                              : const SizedBox(),

                          const SizedBox(height: 10),
                          Flexible(
                            child: ListView.builder(
                              itemCount: membersList.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () => showDialogBox(index),
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
                            trailing:  membersList[index]['isAdmin']!=null ? 
                            membersList[index]['isAdmin'] ? const Icon(Icons.star, color: Colors.white) : null
                            : null
                                );
                              },
                            ),
                          ), 
                          
                          SizedBox(
                            height: size.height / 40,
                          ),
                          const Divider(
                            thickness: 0.5, color: Colors.white, 
                          ),
                          SizedBox(
                            height: size.height / 40,
                          ),
                          
                          ListTile(
                            onTap: onLeaveGroup,
                            leading: const Icon(
                              Icons.logout,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Leave Group",
                              style: TextStyle(
                                fontSize: size.width / 28,
                                fontWeight: FontWeight.w300,
                                color: Colors.white,
                                letterSpacing: 2
                              ),
                            ),
                          ),
                        ],
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
