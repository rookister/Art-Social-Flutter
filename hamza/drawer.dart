import 'package:flutter/material.dart';
import 'package:flutter_application_32/grup_chat_home.dart';
import 'login.dart';
import 'route_anim.dart';
import 'themes.dart';
import 'verification.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: const BoxConstraints.expand(),
        color: Colors.black,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
                radius: 72,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage: AssetImage('assets/tempLogo.png'),
                )),
            const SizedBox(height: 50),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Themes().iconTextButtons(
                  text: 'Create a Group',
                  iconData: Icons.group_add,
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => GroupChatHomeScreen(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Themes().iconTextButtons(
                    text: 'Join a Group',
                    iconData: Icons.groups,
                    onPressed: () {}),
                const SizedBox(height: 250),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 62),
              child: Themes().iconTextButtons(
                  text: 'Settings', iconData: Icons.settings, onPressed: () {}),
            ),
            const SizedBox(height: 50),
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: ElevatedButton(
                  onPressed: () {
                    Verification().signUserOut();
                    Navigator.pushReplacement(
                        context,
                        Slide(
                            child: const Login(), direction: AxisDirection.up));
                  },
                  style: Themes().elevB(),
                  child: Text('L O G O U T', style: Themes().text()),
                ))
          ],
        ));
  }
}
