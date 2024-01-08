import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project/shared_prefs.dart';
import 'package:project/themes.dart';
import 'package:uuid/uuid.dart';

class CreateGroup extends StatefulWidget {
  final List<Map<String, dynamic>> membersList;

  const CreateGroup({required this.membersList, super.key});

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final TextEditingController _groupName = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  String groupId = const Uuid().v1();
  String? gImage;
  bool type = true;

  void createGroup() async {
      showDialog(
        context: context, 
        builder: (context) {
        return Themes().loadingDialog();});

    setState(() {
      isLoading = true;
    });


    await _firestore.collection('groups').doc(groupId).set({
      "pic": gImage,
      "members": widget.membersList,
      "id": groupId,
      "public":type
    });

    for (int i = 0; i < widget.membersList.length; i++) {
      String email = widget.membersList[i]['email'];

      await _firestore
          .collection('Users')
          .doc(email)
          .collection('groups')
          .doc(groupId)
          .set({
        "name": _groupName.text,
        "id": groupId,
        "pic": gImage
      });
    }

    await _firestore.collection('groups').doc(groupId).collection('chats').add({
      "message": "${_auth.currentUser!.displayName} Created This Group.",
      "type": "notify",
      "time": FieldValue.serverTimestamp(),
    });
    await Future.delayed(const Duration(milliseconds: 10),() {Navigator.pop(context);});
    goBack();

  }

  selectImage() async{
    showDialog( context: context, builder: (context) { return Themes().loadingDialog();});
    String? location = gImage;
    final ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if(image!=null){
      Uint8List? img = await image.readAsBytes();
      location = await uploadGroupPic(img);    
    }
    setState(() {
      gImage = location;
    });
    await Future.delayed(const Duration(milliseconds: 10),() {Navigator.pop(context);});
  } 

  Future<String> uploadGroupPic(Uint8List file) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref().child(groupId);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String location = await snapshot.ref.getDownloadURL();
    return location;   
}

  goBack(){
    Navigator.of(context).pop();
    Navigator.of(context).pop();  
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return FutureBuilder(
      future: setTheme(),
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: appBarColor,
            title: const Text("G R O U P  N A M E", style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w300)),
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
              child: isLoading
                  ? const SizedBox()
                  : Column(
                      children: [
                        SizedBox( height: size.height * 0.03),
                        Themes().gfp(
                          gImage, () async {
                           await selectImage();}
                        ),
                        SizedBox( height: size.height * 0.05),
                        Padding( 
                        padding: const EdgeInsets.symmetric(horizontal: 50), 
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          style: Themes().text(),
                          decoration: Themes().textFieldDecor(
                            'Choose a Group Name','Group Name',color: Colors.white),
                            controller: _groupName,
                    )),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                            const Text( 'P U B L I C ?', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.w300)),
                            SizedBox(
                          height: size.height * 0.025,
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width/3),
                              child: RadioListTile<bool>(
                                title: const Text('Yes', style: TextStyle(color: Colors.white,fontSize: 13.0, fontWeight: FontWeight.w300)),
                                value: true,
                                fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                                groupValue: type,
                                onChanged: (bool? value) {
                                  setState(() {
                                    type = value ?? false;
                                  });
                                },
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: size.width/3),
                              child: RadioListTile<bool>(
                                title: const Text('No', style: TextStyle(color: Colors.white,fontSize: 13.0, fontWeight: FontWeight.w300)),
                                value: false,
                                groupValue: type,
                                fillColor: MaterialStateColor.resolveWith((states) => Colors.white),
                                onChanged: (bool? value) {
                                  setState(() {
                                    type = value ?? false;
                                  });
                                },
                              ),
                            ),
                        Padding(
                        padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 140),
                        child: ElevatedButton(
                          onPressed: () => createGroup(),
                          style: Themes().elevB(),
                          child: Text('Create Group', style: Themes().text()),
                      )),
                      ],
                    ),
            ),
          ),
        );
      }
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
