import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatefulWidget {
  CustomBottomNavigation({Key? key}) : super(key: key);

  @override
  State<CustomBottomNavigation> createState() => _CustomBottomNavigationState();
}

class _CustomBottomNavigationState extends State<CustomBottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black12,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.dashboard,
              color: Colors.black12,
            ),
            label: "Dashboard"
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Colors.black12,
            ),
            label: "Favourite"
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Colors.black12,
            ),
            label: "Profile"
          )
        ],
        selectedItemColor: Colors.blue,
      );
  }
}