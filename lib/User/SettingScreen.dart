import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
            buildSettingsItem("Edit Profile", Icons.edit),
            buildSettingsItem("Manage Notifications", Icons.notifications),
            buildSettingsItem("Saved Addresses", Icons.location_on),
            SizedBox(height: 20),
            Text(
              "Feedback & Information",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(),
            buildSettingsItem("Terms of Use", Icons.description),
            buildSettingsItem("Privacy Policy", Icons.privacy_tip),
            buildSettingsItem("Return Policy", Icons.keyboard_return),
            buildSettingsItem("Help Center", Icons.help),
          ],
        ),
      ),
    );
  }

  Widget buildSettingsItem(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: Icon(Icons.arrow_forward_ios),
      onTap: () {
        // Handle onTap action
      },
    );
  }
}