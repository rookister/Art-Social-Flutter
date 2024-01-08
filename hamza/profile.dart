import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'themes.dart';
import 'verification.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileData createState() => ProfileData();
}

class ProfileData extends State<Profile> {
  bool userNameUL = true;
  bool userNameTakenError = false;
  bool userNameSize = false;
  bool aboutMe = true;
  bool addHL = true;
  TextEditingController userName = TextEditingController();
  TextEditingController aboutMeSection = TextEditingController();
  Map<String, dynamic>? user;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    initializeCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
        onRefresh: refreshProfile,
        color: const Color.fromARGB(95, 42, 42, 42),
        height: 100,
        animSpeedFactor: 2.5,
        showChildOpacityTransition: true,
        child: ListView(children: [
          Container(
              color: Colors.transparent,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(children: [
                      Themes().background(context, user?['bg']),
                      Themes().bgEdit(() async {
                        await selectImage('bg');
                      }),
                      Themes().pfp(user?['pfp'], () async {
                        await selectImage('pfp');
                      })
                    ]),
                    Row(children: [
                      Themes().profileFields(
                          controller: userName,
                          isUnderlined: userNameUL,
                          text: user?['username']),
                      const SizedBox(width: 5),
                      Themes().editButton(() async {
                        if (userNameUL == false) {
                          if (userName.text.length < 10) {
                            userNameSize = false;
                            userNameTakenError = false;
                            userNameTakenError = await Verification()
                                .setUserName(currentUser, userName.text.trim());
                            refreshProfile();
                          } else {
                            userNameSize = true;
                          }
                        }
                        setState(() {
                          userNameUL = !userNameUL;
                        });
                      }, 35, 17, userNameUL),
                      const SizedBox(width: 30),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Visibility(
                            visible: userNameTakenError || userNameSize,
                            child: Text(
                                userNameSize
                                    ? 'Use Less Than 10 Characters!'
                                    : 'This Username Already Exists!',
                                style: const TextStyle(
                                    fontSize: 14,
                                    color: Color.fromARGB(255, 255, 0, 0),
                                    fontWeight: FontWeight.w300))),
                      ),
                    ]),
                    Row(children: [
                      const SizedBox(width: 15),
                      Themes().aboutSection(context,
                          controller: aboutMeSection,
                          isUnderlined: aboutMe,
                          text: user?['about']),
                      const SizedBox(width: 20),
                      Themes().editButton(() async {
                        if (aboutMe == false) {
                          await Verification().setAboutMe(
                              currentUser, aboutMeSection.text.trim());
                          refreshProfile();
                        }
                        setState(() {
                          aboutMe = !aboutMe;
                        });
                      }, 35, 18, aboutMe)
                    ]),
                    const SizedBox(height: 12),
                    const Divider(color: Colors.white, thickness: 0.5),
                    const Text('H I G H L I G H T S',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w200)),
                    const Divider(color: Colors.white, thickness: 0.5),
                    const SizedBox(height: 5),
                    Themes().addButton(() async {
                      await addHighlights();
                    }, 40, 25, addHL),
                    const SizedBox(height: 20),
                    (user?['highlights'] != null)
                        ? GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            physics: const NeverScrollableScrollPhysics(),
                            children: List.generate(
                                user?['highlights'].length,
                                (index) => InkWell(
                                    onTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return Dialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: Image.network(
                                                    user?['highlights'][index],
                                                    width: 400,
                                                    height: 350,
                                                    fit: BoxFit.contain));
                                          });
                                    },
                                    child: Stack(children: [
                                      Image.network(user?['highlights'][index],
                                          width: 200,
                                          height: 200,
                                          fit: BoxFit.cover),
                                      Themes().deleteButton(() {
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return Themes()
                                                  .confirmDialog(context, () {
                                                Navigator.of(context).pop();
                                                deleteHighlight(index);
                                              });
                                            });
                                      })
                                    ]))))
                        : const Text(''),
                    const SizedBox(height: 30)
                  ]))
        ]));
  }

  initializeCurrentUser() async {
    await Future.delayed(Duration.zero);
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      await getUserDetails();
    }
  }

  getUserDetails() async {
    showDialog(
        context: context,
        builder: (context) {
          return Themes().loadingDialog();
        });
    DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection("Users")
        .doc(currentUser!.email)
        .get();
    setState(() {
      user = documentSnapshot.data() as Map<String, dynamic>?;
    });
    await Future.delayed(const Duration(milliseconds: 10), () {
      Navigator.pop(context);
    });
  }

  Future<void> refreshProfile() async {
    setState(() {
      getUserDetails();
    });
  }

  selectImage(String imageType) async {
    showDialog(
        context: context,
        builder: (context) {
          return Themes().loadingDialog();
        });
    final ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List? img = await image.readAsBytes();
      await Verification().uploadProfileImages(
          '$imageType-${user?['email']}', img, currentUser, imageType);
      refreshProfile();
    }
    await Future.delayed(const Duration(milliseconds: 10), () {
      Navigator.pop(context);
    });
  }

  addHighlights() async {
    showDialog(
        context: context,
        builder: (context) {
          return Themes().loadingDialog();
        });
    final ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Uint8List? img = await image.readAsBytes();
      int no = 0;
      if (user?['highlights'] != null) {
        no = user?['highlights'].length;
      }
      await Verification().uploadHighlights(
          'highlight$no-${user?['email']}', img, currentUser, user);
      refreshProfile();
    }
    await Future.delayed(const Duration(milliseconds: 10), () {
      Navigator.pop(context);
    });
  }

  deleteHighlight(int index) async {
    showDialog(
        context: context,
        builder: (context) {
          return Themes().loadingDialog();
        });
    String fileName = 'highlight${index + 1}-${user?['email']}';
    await Verification().delHighlights(fileName, currentUser, user);

    refreshProfile();
    await Future.delayed(const Duration(milliseconds: 10), () {
      Navigator.pop(context);
    });
  }
}
