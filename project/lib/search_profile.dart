import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project/shared_prefs.dart';
import 'themes.dart';

class SearchProfile extends StatefulWidget {
  const SearchProfile({super.key});

  @override
  ProfileData createState() => ProfileData();
}

class ProfileData extends State<SearchProfile> {

  TextEditingController userName = TextEditingController();
  TextEditingController aboutMeSection = TextEditingController();
  TextEditingController searchCont = TextEditingController();
  Map<String,dynamic>? userData;
  bool searched = false;
  bool exists = false;
  final FocusNode _userNameFocusNode = FocusNode();
 
  
  search(String userName) async{
      FocusScope.of(context).unfocus();
    showDialog( context: context, builder: (context) { return Themes().loadingDialog();});
    CollectionReference collection = FirebaseFirestore.instance.collection("Users");
    QuerySnapshot querySnapshot = await collection.where('username', isEqualTo: userName).get();
    setState(() {
      if (querySnapshot.docs.isNotEmpty) {
        userData = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        searched = true; exists = true;
      } else {
        userData = null; searched = true; exists = false;
      }});
      await Future.delayed(const Duration(milliseconds: 10),() {Navigator.pop(context);});
    }
  
  bool isThemeSet = false;
  bool theme = true;
  Color mainColor = const Color.fromARGB(255, 247, 62, 62);

setTheme() async{
  theme = await Preferences().getTheme();
  if(theme){mainColor = const Color.fromARGB(255, 247, 62, 62);}
  else{mainColor = Colors.white;}
  isThemeSet = true;
}

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: setTheme(),
      builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done || isThemeSet) {
        return ListView(
              children:[
                Visibility(
                visible: !exists,
                child: Column (
                  children: [
                    Padding( 
                padding: const EdgeInsets.symmetric(horizontal: 50), 
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  style: Themes().text(),
                  decoration: Themes().textFieldDecor(
                    'Who are you looking for?','Username',color: Colors.white),
                    controller: searchCont,
                )),
                const SizedBox(height: 25),
                Padding(
                padding: const EdgeInsets.symmetric(horizontal: 140),
                child: ElevatedButton(
                  onPressed: () => search(searchCont.text.trim()),
                  style: Themes().elevB(),
                  child: Text('Search', style: Themes().text()),
              )),
              const SizedBox(height: 25)])),
              
              if (searched && !exists)
              Padding(
                padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*0.03),
                child: Column(
                  children: [
                    Image.asset('assets/idleTail2.gif'),
                    Text("No Record Found!",
                  style: TextStyle(fontSize: 20, color: mainColor, 
                  fontWeight: FontWeight.w300),textAlign: TextAlign.center),
              ]),
              )
              
              else Visibility(
                visible: searched && exists,
                child: Column(
                  children: [
                    Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(194, 30, 30, 30),),
                      child: IconButton(
                      onPressed: (){
                        setState(() {
                          searched = false; exists = false;
                        });}, 
                      icon: const Icon(Icons.arrow_back,
                        color: Colors.white, size: 20))),
                  ),
                const SizedBox(height: 30),
              
                  Container(
                    color: Colors.transparent,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,          
                        children: [
                          Stack(
                          children:[ 
                            Themes().background(context, userData?['bg']),
                            Themes().pfp(userData?['pfp'], (){})]),
                    
                          Row(
                            children: [
                            Themes().profileFields(context, _userNameFocusNode,
                              controller: userName, isUnderlined: true, text: userData?['username']),
                            const SizedBox(width: 35)]),
                  
                            Row(
                              children: [
                                const SizedBox(width: 15),
                                Themes().aboutSection(context, controller: aboutMeSection, isUnderlined: true, text: userData?['about']),
                                const SizedBox(width: 20)]),
              
                            const SizedBox(height: 12),
                            const Divider(
                                color: Colors.white,
                                thickness: 0.5),
                  
                            const Text('H I G H L I G H T S',
                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w200)),
                            const Divider(
                                color: Colors.white,
                                thickness: 0.5),
                            const SizedBox(height: 25),
              
                            (userData?['highlights']!= null) ?
                            GridView.count(
                              shrinkWrap: true,
                              crossAxisCount: 3,
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              physics: const NeverScrollableScrollPhysics(),
                              children: List.generate(
                                userData?['highlights'].length,
                                (index) => InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          backgroundColor: Colors.transparent,
                                          child: Image.network(
                                            userData?['highlights'][index],
                                            width: 400,
                                            height: 350,
                                            fit: BoxFit.contain));});},
                                  child: Stack(
                                    children: [
                                      Opacity( 
                                        opacity: 0.8,
                                        child: Image.network( userData?['highlights'][index], width: 200, height: 200, fit: BoxFit.cover,
                                        loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? lp) {
                                          if (lp == null) { return child; } 
                                          else {
                                            return Center(
                                              child: CircularProgressIndicator(
                                                value: lp.expectedTotalBytes != null ? lp.cumulativeBytesLoaded / (lp.expectedTotalBytes ?? 1) : null,
                                                color: Colors.white,
                                              ));}})),
                                  ])))) : const Text(''),
                            const SizedBox(height: 30)                        
                            ]))]),
              ),
              const SizedBox(height: 10),
            ]);
      }
      else{
        return Themes().loadingDialog();
      }
      }
    );
  }
}