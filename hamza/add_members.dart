//import 'package:chat_app/group_chats/create_group/create_group.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_32/create_group.dart';

class AddMembersInGroup extends StatefulWidget {
  const AddMembersInGroup({Key? key}) : super(key: key);

  @override
  State<AddMembersInGroup> createState() => _AddMembersInGroupState();
}

class _AddMembersInGroupState extends State<AddMembersInGroup> {
  final TextEditingController _search = TextEditingController();
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;
  List<Map<String, dynamic>> membersList = [];
  bool isLoading = false;
  Map<String, dynamic>? userMap;

  @override
  void initState() {
    super.initState();
    getCurrentUserDetails();
  }

  // void getCurrentUserDetails() async {
  //   await _firestore
  //       .collection('Users')
  //       .doc(_auth.currentUser!.uid)
  //       .get()
  //       .then((map) {
  //     setState(() {
  //       print("the valye is " + map['username']);

  //       membersList.add({
  //         "name": map['username'],
  //         "email": map['email'],
  //         "uid": _auth.currentUser!.uid,
  //         "isAdmin": true,
  //       });
  //     });
  //   });
  // }

  void getCurrentUserDetails() async {
    await _firestore
        .collection('Users')
        .doc(_auth.currentUser!.uid)
        .get()
        .then((map) {
      if (map.exists) {
        setState(() {
          membersList.add({
            "username": map['username'], // Update field name to 'name'
            "email": map['email'],
            //"uid": map['uid'],
            "isAdmin": true,
          });

          print("the value of map is " + map['username']);
        });
      }
    });
  }

  void onSearch() async {
    setState(() {
      isLoading = true;
    });

    await _firestore
        .collection('Users')
        .where("username", isEqualTo: _search.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
      print(userMap!["username"] + "the value of email is" + userMap!["email"]);
    });
  }

  void onResultTap() {
    bool isAlreadyExist = false;

    // for (int i = 0; i < membersList.length; i++) {
    //   if (membersList[i]['username'] == userMap!['username']) {
    //     isAlreadyExist = true;
    //   }
    // }

    if (userMap != null) {
      if (!isAlreadyExist) {
        setState(() {
          membersList.add({
            "username": userMap!['username'].toString(),
            "email": userMap!['email'].toString(),
            "isAdmin": false,
          });

          userMap = null;
        });
      }
    } else {
      print("chichi papa");
    }
  }

  // void onResultTap() {
  //   if (userMap != null) {
  //     bool isAlreadyExist = false;

  //       print("the vlaue is " + userMap!['username']);

  //     // Check if userMap['username'] is not null
  //     if (userMap!['username'] != null) {
  //       for (int i = 0; i < membersList.length; i++) {
  //         // Check if membersList[i]['username'] is not null
  //         if (membersList[i]['username'] == userMap!['username']) {
  //           isAlreadyExist = true;
  //         }
  //       }
  //       if (!isAlreadyExist) {
  //         setState(() {
  //           membersList.add({
  //             "name": userMap!['username'],
  //             "email": userMap!['email'],
  //             "isAdmin": false,
  //           });

  //           userMap = null;
  //         });
  //       }
  //     } else {
  //       print("Username is null in userMap");
  //     }
  //   } else {
  //     print("userMap is null");
  //   }
  // }

  // void onRemoveMembers(int index) {
  //   if (membersList[index]['uid'] != _auth.currentUser!.uid) {
  //     setState(() {
  //       membersList.removeAt(index);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Members"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: membersList.length,
              itemBuilder: (context, index) {
                print(membersList.length);

                return ListTile(
                  //  onTap: () => onRemoveMembers(index),
                  leading: Icon(Icons.account_circle),
                  title: Text(membersList[index]['username'].toString()),
                  subtitle: Text(membersList[index]['email'].toString()),
                  trailing: Icon(Icons.close),
                );
              },
            ),
          ),
          SizedBox(
            height: size.height / 20,
          ),
          Container(
            height: size.height / 14,
            width: size.width,
            alignment: Alignment.center,
            child: Container(
              height: size.height / 14,
              width: size.width / 1.15,
              child: TextField(
                controller: _search,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height / 50,
          ),
          isLoading
              ? Container(
                  height: size.height / 12,
                  width: size.height / 12,
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: onSearch,
                  child: Text("Search"),
                ),
          userMap != null
              ? ListTile(
                  onTap: onResultTap,
                  leading: Icon(Icons.account_box),
                  title: Text(userMap!['username']),
                  subtitle: Text(userMap!['email']),
                  trailing: Icon(Icons.add),
                )
              : SizedBox(),
        ],
      ),
      floatingActionButton: membersList.length >= 2
          ? FloatingActionButton(
              child: Icon(Icons.forward),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CreateGroup(
                    membersList: membersList,
                  ),
                ),
              ),
            )
          : SizedBox(),
    );
  }
}
