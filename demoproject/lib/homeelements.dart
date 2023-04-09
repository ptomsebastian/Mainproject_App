import 'package:demoproject/homepage.dart';
import 'package:demoproject/Login_Screen.dart';
import 'package:demoproject/home.dart';
import 'package:demoproject/homepage.dart';
import 'package:demoproject/ip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Homeelements extends StatefulWidget implements PreferredSizeWidget {
   Homeelements({super.key});

  @override
  State<Homeelements> createState() => _HomeelementsState();



  @override
  Size get preferredSize => Size.fromHeight(56.0);
}

class _HomeelementsState extends State<Homeelements> {
    final storage = FlutterSecureStorage();
  void user_logout() async {
  final token = await storage.read(key: 'token');
  // print(token);
  print('logot clicked');
  var response = await http.post(
    Uri.parse(ip+'/api/userlogout/'),
    // Uri.parse('http://192.168.43.34:8000/api/userlogout/'),
    // Uri.parse('http://10.0.2.2:8000/api/userlogout/'),
    headers: {
      'Authorization': '$token',
    },
  );
  print('response');
  print(response.body);
  if (response.statusCode == 201) {
    print('logout success');
    await storage.delete(key: 'token');
    print(storage);
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) =>
    HomePage()), (Route<dynamic> route) => false);
  } else {
     print('logout failed');
    // handle error
  }
}
  @override
  Widget build(BuildContext context) {
    return  AppBar(
      
        title: Text('Pee Cee Talkies'),
       actions: [IconButton(
            icon: Icon(Icons.logout),
            onPressed:(() {
              user_logout();
            }) ,
          ),],
    // 
      
     
    );
  }
}