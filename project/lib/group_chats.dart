import 'package:flutter/material.dart';

class Groups extends StatefulWidget {
  const Groups({super.key});

  @override
  GroupsChats createState() => GroupsChats();
}

class GroupsChats extends State<Groups> {
  @override
  Widget build(BuildContext context) {
    return const Card(
            color: Colors.transparent,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: [
                Text('Group Chats', 
                textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w200)),
              ]
            )
    );
  }
}