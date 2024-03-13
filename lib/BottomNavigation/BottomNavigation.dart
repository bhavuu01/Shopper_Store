import 'package:flutter/material.dart';
import 'package:shopperstoreuser/BottomNavigation/AccountPage.dart';
import 'package:shopperstoreuser/HomePage/HomeScreen.dart';

import '../Cart/CartScreen.dart';
import 'CartPage.dart';
import 'FavPage.dart';


class BottomNavigationHome extends StatefulWidget {
  int? selectedIndex;

  BottomNavigationHome({Key? key, this.selectedIndex = 0}) : super(key: key);

  @override
  State<BottomNavigationHome> createState() => _BottomNavigationHomeState();
}

class _BottomNavigationHomeState extends State<BottomNavigationHome> {
  List<Widget> widgetsPage = [
    const HomeScreen(),
    const FavPage(),
    const CartPage(),
    const AccountPage(),
  ];

  Future<bool> _onWillPop() async {
    if (widget.selectedIndex == 0) {
      return true; // Allow back button to pop the current screen
    } else {
      setState(() {
        widget.selectedIndex = 0; // Set selected index to 0 (Home) when pressing back button
      });
      return false; // Do not allow back button to pop the current screen
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Register the callback for back button press
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.red[500], // Set selected item color to red
          unselectedItemColor: Colors.white,
          currentIndex: widget.selectedIndex!.toInt(),
          onTap: (value) {
            setState(() {
              widget.selectedIndex = value;
            });
          },
          items: const [
            BottomNavigationBarItem(
              backgroundColor: Colors.lightBlue,
              label: "Home",
              icon: Icon(
                Icons.home,
              ),
            ),
            BottomNavigationBarItem(
              // backgroundColor: Colors.white70,
              backgroundColor: Colors.lightBlue,
              label: "Favorite",
              icon: Icon(
                Icons.favorite,
              ),
            ),
            BottomNavigationBarItem(
              // backgroundColor: Colors.white70,
              backgroundColor: Colors.lightBlue,
              label: "Cart",
              icon: Icon(Icons.shopping_cart),
            ),
            BottomNavigationBarItem(
              label: "User",
              // backgroundColor: Colors.white70,
              backgroundColor: Colors.lightBlue,
              icon: Icon(
                Icons.person_outline_outlined,
              ),
            ),
          ],
        ),
        body: widgetsPage.elementAt(widget.selectedIndex!.toInt()),
      ),
    );
  }
}
