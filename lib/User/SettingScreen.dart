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
          ],
        ),
      ),
    );
  }
}