// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:project/themes.dart';

class ImageTab extends StatefulWidget {
  final String groupChatId, groupName;
  const ImageTab({required this.groupName, required this.groupChatId, super.key});

  @override
  State<ImageTab> createState() => _ImageTabState();
}

class _ImageTabState extends State<ImageTab> {
  List<Map<String, dynamic>>? imageData;
  User? userCreds;

  @override
  void initState(){
    userCreds = FirebaseAuth.instance.currentUser;
    getImages();
    super.initState();
  }

addHighlights() async{
  showDialog(
      context: context, 
      builder: (context) {
      return Themes().loadingDialog();});
  final ImagePicker imagePicker = ImagePicker();
  XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
  if(image!=null){
    Uint8List? img = await image.readAsBytes();
    await uploadImages(img, userCreds);
    refreshProfile();  
  }
  await Future.delayed(const Duration(milliseconds: 10),() {Navigator.pop(context);});
}

getImages() async {
    await Future.delayed(Duration.zero);
    showDialog(context: context, builder: (context) {
      return Themes().loadingDialog(); });
    CollectionReference imagesCollection = FirebaseFirestore.instance
        .collection("groups")
        .doc(widget.groupChatId) 
        .collection("images");

    QuerySnapshot imagesSnapshot = await imagesCollection.get();
    List<Map<String, dynamic>> imagesList = [];
    for (var document in imagesSnapshot.docs) {
      Map<String, dynamic> imageData = {
        "imageURL": document["imageURL"],
        "displayName": document["displayName"],
        "dateTime": (document["dateTime"] as Timestamp).toDate(),
        "pfp": document["pfp"]
      };
      imagesList.add(imageData);
    }
    setState(() { imageData = imagesList;});
    await Future.delayed(Duration.zero, () {
      Navigator.pop(context);
    });
  }

  Future<void> refreshProfile() async{
        setState(() async {
          await getImages();
        });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return LiquidPullToRefresh(
        onRefresh: refreshProfile,
        color: const Color.fromARGB(95, 42, 42, 42),
        height: 100,
        animSpeedFactor: 2.5,
        showChildOpacityTransition: true,
        child: ListView(
          children: [    
            Column(
            mainAxisAlignment: MainAxisAlignment.start, 
            children: [
              const SizedBox(height: 20),
              Themes().addButton(() async { await addHighlights(); }, 40, 25, true),
              const SizedBox(height: 20),
              SizedBox(
                height: size.height *0.7,
                width: size.width*0.95,
                child: (imageData!= null && imageData!.isNotEmpty) ?
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                              imageData!.length,
                              (index) => InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Image.network(
                                          imageData?[index]['imageURL'],
                                          width: 400,
                                          height: 350,
                                          fit: BoxFit.contain));});},
                                child: Stack(
                                  children: [
                                    Opacity( 
                                      opacity: 0.8,
                                      child: Image.network( imageData?[index]['imageURL'], width: 200, height: 200, fit: BoxFit.cover,
                                      loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? lp) {
                                        if (lp == null) { return child; } 
                                        else {
                                          return Center(
                                            child: CircularProgressIndicator(
                                              value: lp.expectedTotalBytes != null ? lp.cumulativeBytesLoaded / (lp.expectedTotalBytes ?? 1) : null,
                                              color: Colors.white,
                                            ));}}      
                                      )),
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      radius: 20,
                                      child: CircleAvatar(
                                        backgroundColor: Colors.grey,
                                        radius: 19,
                                        backgroundImage: imageData?[index]['pfp']==null ? 
                                        const AssetImage('assets/noPFP.jpg' ) as ImageProvider : NetworkImage(imageData?[index]['pfp']), 
                                      ),
                                    ),
                                    
                                ])))) :  Themes().resultDialog(context, 'Nothing Here!')
              ),
            ],
          ),
   ]),
    );
  }

uploadImages(Uint8List file, User? userCreds) async {
  FirebaseStorage storage = FirebaseStorage.instance;

  if (userCreds != null && imageData != null) {
    Reference userFolderRef = storage.ref().child(widget.groupChatId);
    String randomFileName = generateRandomFileName();
    Reference fileRef = userFolderRef.child(randomFileName);
    UploadTask uploadTask = fileRef.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String location = await snapshot.ref.getDownloadURL();

        
    DocumentSnapshot user = await FirebaseFirestore.instance
    .collection("Users")
    .doc(userCreds.email)
    .get();

    String? pfp;
    var userData = user.data() as Map<String, dynamic>?;
    if (userData != null && userData['pfp'] != null && userData['pfp'] is String) {
      pfp = userData['pfp'] as String;
    }


    await FirebaseFirestore.instance
        .collection("groups")
        .doc(widget.groupChatId) 
        .collection("images")
        .doc(randomFileName)
        .set({
          'imageURL': location,
          'displayName': userCreds.displayName,
          'dateTime': FieldValue.serverTimestamp(),
          'pfp': pfp
        });
  }
}

String generateRandomFileName() {
  final Random random = Random();
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(10, (index) => chars[random.nextInt(chars.length)]).join();
}

}