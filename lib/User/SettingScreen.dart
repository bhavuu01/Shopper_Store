import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopperstoreuser/User/NeedHelp.dart';
import 'package:shopperstoreuser/User/PrivacyPolicy.dart';
import 'package:shopperstoreuser/User/ReturnPolicy.dart';
import 'package:shopperstoreuser/User/TermsCondition.dart';

import '../Provider.dart';

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              height: 80,
              child: Card(
                child: Row(
                  children: [
                    const Text(" Change Your Theme color"),
                    Padding(
                      padding: const EdgeInsets.only(left: 100),
                      child: IconButton(
                        onPressed: () {
                          Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                        },
                        icon: const Icon(Icons.brightness_4_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "Account Settings",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            // buildSettingsItem("Edit Profile", Icons.edit),
            buildSettingsItem(context, "Manage Notifications", Icons.notifications, () {
              // Action for Manage Notifications
            }),
            buildSettingsItem(context, "Saved Addresses", Icons.location_on, () {
              // Action for Saved Addresses
            }),
            SizedBox(height: 20),
            Text(
              "Feedback & Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            buildSettingsItem(context, "Terms of Use", Icons.description, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TermsAndConditionsPage()));
            }),
            buildSettingsItem(context, "Privacy Policy", Icons.privacy_tip, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacyPolicyPage()));
            }),
            buildSettingsItem(context, "Return Policy", Icons.keyboard_return, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReturnPolicyScreen()));
            }),
            buildSettingsItem(context, "Help Center", Icons.help, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => NeedHelpScreen()));
            }),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsItem(BuildContext context, String title, IconData icon, Function() onTap) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
