import 'package:demoproject/accountlink.dart';
import 'package:demoproject/getnews.dart';
import 'package:demoproject/sendquery.dart';
import 'package:demoproject/updateprofile.dart';
import 'package:demoproject/viewbookingsapp.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Mydrawer extends StatelessWidget implements PreferredSizeWidget {
  
   Mydrawer({super.key});
//  final storage = const FlutterSecureStorage();
//   String myValue = '';






  
@override
Widget build(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        UserAccountsDrawerHeader(
          accountName: Text(""), //name
          accountEmail: Text(""), //mail
          // currentAccountPicture: CircleAvatar(
          //   // backgroundImage: NetworkImage(
          //   //     "https://www.pexels.com/photo/india-rupee-banknote-904735/"),
          //   backgroundImage: AssetImage('assets/images/image.jpg'),
          // ),
          decoration: BoxDecoration(
            image: DecorationImage(
              // image: AssetImage('assets/images/popcorn.jpg'),
              image: AssetImage('assets/images/popcorn2.png'),
              fit: BoxFit.fill,
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.person_rounded, color: Colors.blue),
          title: Text("Profile",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: () {
            final storage = FlutterSecureStorage();

    // final data = jsonDecode(response.body);
    // final token = data['token'];
    // final mailfromdjango = data['token'];   
    //  storage.write(key: 'token', value: token);
    //  storage.write(key: 'usermail', value: mailfromdjango);
    // print(token);
            
       
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => UpdateProfile()),
    );
          },
        ),

        
        ListTile(
          leading: Icon(Icons.history_edu, color: Colors.green),
          title: Text("View Bookings",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: () {
             Navigator.push(context,
                MaterialPageRoute(builder: (context) => ViewBookingsApp()));
          },
        ),
        ListTile(
          leading: Icon(Icons.newspaper, color: Colors.red),
          title: Text("News",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => GetNews()));
          },
        ),
        ListTile(
          leading: Icon(Icons.question_answer, color: Colors.orange),
          title: Text("Query",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => SendQuery()));
          },
        ),
        ListTile(
          leading: Icon(Icons.recommend_outlined, color: Colors.purple),
          title: Text("Recommendations",style: TextStyle(fontStyle: FontStyle.italic)),
          onTap: () {},
        )
      ],
    ),
  );
}


   
 @override
  Size get preferredSize => Size.fromHeight(56.0);
}