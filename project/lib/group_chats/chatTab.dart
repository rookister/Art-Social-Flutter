import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:project/themes.dart';

class ChatTab extends StatefulWidget {
  final String groupChatId, groupName;
  const ChatTab({required this.groupName, required this.groupChatId, super.key});

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  final TextEditingController _message = TextEditingController();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void onSendMessage() async {
  if (_message.text.isNotEmpty) {
    FocusScope.of(context).unfocus();
    Map<String, dynamic> chatData = {
      "sendBy": _auth.currentUser!.displayName,
      "message": _message.text,
      "type": "text",
      "time": FieldValue.serverTimestamp(),
    };

    _message.clear();

    await _firestore
        .collection('groups')
        .doc(widget.groupChatId)
        .collection('chats')
        .add(chatData);
  }
}

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start, 
          children: [
            SizedBox(
              height: size.height *0.7,
              width: size.width*0.95,
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('groups')
                    .doc(widget.groupChatId)
                    .collection('chats')
                    .orderBy('time')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Map<String, dynamic> chatMap =
                            snapshot.data!.docs[index].data()
                                as Map<String, dynamic>;
                        return messageTile(size, chatMap);
                      },
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                top: 10, bottom: MediaQuery.of(context).viewInsets.bottom + 10,
                left: 10,right: 10),
              height: size.height *0.1,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height / 17,
                      width: size.width / 1.3,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: Themes().text(),
                        decoration: Themes().textFieldDecor(
                          '','Enter a Message',color: Colors.white),
                          controller: _message,
                      )),
                    Padding(
                      padding:  EdgeInsets.only(left: size.width*0.01),
                      child: IconButton(
                          icon: const Icon(Icons.send, color: Colors.white,), onPressed: onSendMessage),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget messageTile(Size size, Map<String, dynamic> chatMap) {
    return Builder(builder: (_) {
      if (chatMap['type'] == "text") {
        return Container(
          width: size.width,
          alignment: chatMap['sendBy'] == _auth.currentUser!.displayName
              ? Alignment.centerRight
              : Alignment.centerLeft,
          child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: const Color.fromARGB(140, 54, 54, 54),
              ),
              child: Column(
                children: [
                  Text(
                    chatMap['sendBy'],
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: size.height / 200,
                  ),
                  Text(
                    chatMap['message'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ],
              )),
        );
      } else if (chatMap['type'] == "notify") {
        return Container(
          width: size.width,
          alignment: Alignment.center,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: const Color.fromARGB(158, 31, 31, 31),
            ),
            child: Text(
              chatMap['message'],
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}