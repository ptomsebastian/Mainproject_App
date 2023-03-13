import 'dart:convert';

// import 'package:demoproject/editprofile.dart';
import 'package:demoproject/updateprofile.dart';
import 'package:demoproject/userdash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
 int _selectedIndex = 0;
   final storage = FlutterSecureStorage();

  static const List<Widget> _widgetOptions = <Widget>[
    Text('Home'),
    Text('Search'),
    Text('Profile'),
  ];
  //  void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }
 bottomnavigationfunctions() async{
      if(_selectedIndex == 0){
          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) =>
    UserHome()), (Route<dynamic> route) => false);
      
      }
      if(_selectedIndex == 2){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>
    UpdateProfile()));
      
      }
 
 
 
 }


 
 @override
Widget build(BuildContext context) {
  return BottomNavigationBar(
    selectedItemColor: Colors.blue,
    unselectedItemColor: Colors.grey,
    currentIndex: _selectedIndex,
    onTap: (value) {
      setState(() {
        _selectedIndex = value;
        print(value);
      });
      bottomnavigationfunctions();
    },
    items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ],
    backgroundColor: Colors.white,
    elevation: 0.0,
    type: BottomNavigationBarType.fixed,
    selectedFontSize: 14,
    unselectedFontSize: 12,
    showSelectedLabels: true,
    showUnselectedLabels: true,
  );
}

}