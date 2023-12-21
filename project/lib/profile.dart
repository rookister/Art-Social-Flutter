import 'package:flutter/material.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  ProfileData createState() => ProfileData();
}

Future<void> refreshProfile() async{
  return await Future.delayed(const Duration(milliseconds: 500));
}

class ProfileData extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return LiquidPullToRefresh(
      onRefresh: refreshProfile,
      color: const Color.fromARGB(95, 42, 42, 42),
      height: 100,
      animSpeedFactor: 3,
      showChildOpacityTransition: false,
      child: ListView(
        children:[
          Container(
            color: Colors.transparent,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,          
                children: [
                  Stack(
                  children:[ 
                    Container(
                      width:  MediaQuery.of(context).size.width, height: 200,
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 255, 255, 255), // Border color
                            width: 2.0, // Border width
                        ))),
                      child: Image.asset('assets/tempLogo.png',fit: BoxFit.cover )),

                    Padding(
                      padding: const EdgeInsets.only(left: 365,top: 10),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(194, 51, 51, 51),),
                        child: IconButton(
                           onPressed: (){}, 
                           icon: const Icon(Icons.edit,color: Colors.white))),
                    ),

                    Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 90),
                            child: CircleAvatar(
                            radius: 72,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 71,
                              backgroundImage: const AssetImage('assets/tempLogo.png'),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 90),
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color.fromARGB(194, 51, 51, 51),),
                                  child: IconButton(
                                    onPressed: (){}, 
                                    icon: const Icon(Icons.upload))
                                )))))]),

                  const SizedBox(height: 30),
                  const Text('Profile', 
                    textAlign: TextAlign.center, style: TextStyle(fontSize: 15, color: Colors.white, fontWeight: FontWeight.w200)),
                ]
            )
          )
        ] 
      )
    );
  }
}