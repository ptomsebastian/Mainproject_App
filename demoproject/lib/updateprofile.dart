import 'dart:convert';

import 'package:demoproject/bottom.dart';
import 'package:demoproject/drawer.dart';
import 'package:demoproject/getnews.dart';
import 'package:demoproject/homeelements.dart';
import 'package:demoproject/userdash.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({Key? key}) : super(key: key);

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final storage = FlutterSecureStorage();
  String? name;
  String? email;
  String? phone;
  String? address;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    _getProfile();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _getProfile() async {
    final token = await storage.read(key: 'token');
    var request =
        http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:8000/api/updateprofile/'));
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': '$token',
    };
    request.headers.addAll(headers);
    // print(token);
    var response = await request.send();
    if (response.statusCode == 200) {
      print('success');
      final body = await response.stream.bytesToString();
      final data = json.decode(body);
      print(data);

      setState(() {
        nameController.text = data['name'].toString();
        emailController.text = data['email'].toString();
        phoneController.text = data['phone'].toString();
        addressController.text = data['address'].toString();
      });
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid....')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Internal error occurred')),
      );
    }
  }

  void _editprofile() async {
    final bool isValid = EmailValidator.validate(emailController.text);

    // if(nameController.text.toString() == null || nameController.text.toString().isEmpty){
    //        ScaffoldMessenger.of(context).showSnackBar(
    //               const SnackBar(content: Text('Enter your name')),
                
    //             );
    // }
    
    if (nameController.text.trim().isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Please enter your name')),
  );
} else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(nameController.text.trim())) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Please enter a valid name')),
  );
}
                                     
         else if(emailController.text.toString() == null || emailController.text.toString().isEmpty || isValid==false){
           ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter a valid email')),
                
                );
     }
     else if (phoneController.text.trim().isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Please enter your phone number')),
  );
} else if (!RegExp(r'^[0-9]{10}$').hasMatch(phoneController.text.trim())) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Please enter a valid phone number')),
  );
}
    //  else if(phoneController.text.toString() == null || phoneController.text.toString().isEmpty || phoneController.text.toString().length !=10 ){
    //        ScaffoldMessenger.of(context).showSnackBar(
    //               const SnackBar(content: Text('Enter a valid phone number')),
                
    //             );
    //  }
    
     else if(addressController.text.toString() == null || addressController.text.toString().isEmpty){
           ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Enter your address')),
                
                );
     }
     else{
    final token = await storage.read(key: 'token');
    var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:8000/api/editprofile/'));
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': '$token',
    };
    request.headers.addAll(headers);

    request.fields['name'] = nameController.text.toString();
    request.fields['email'] = emailController.text.toString();
    request.fields['address'] = addressController.text.toString();
    request.fields['phone'] = phoneController.text.toString();

    var response = await request.send();

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (ctx) => UserHome()),
          (Route<dynamic> route) => false);
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid....')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Internal error occurred')),
      );
    }
  }
}


@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: Homeelements(),
    drawer: Mydrawer(),
    bottomNavigationBar: Screen1(),
    body: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
  'Update Profile',
  style: TextStyle(
    fontSize: 22.0,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
    letterSpacing: 1.5,
    shadows: [
      Shadow(
        offset: Offset(2.0, 2.0),
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 2.0,
      ),
    ],
  ),
),

                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Enter your name',
                        border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                      ),
                      controller: nameController,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                      controller: emailController,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Enter your phone number',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone),
                      ),
                      controller: phoneController,
                    ),
                    SizedBox(height: 16.0),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Address',
                        hintText: 'Enter your address',
                        border: OutlineInputBorder(),
                         prefixIcon: Icon(Icons.location_on),
                      ),
                      controller: addressController,
                    ),
                     SizedBox(height: 25.0),
          Padding(
            padding: EdgeInsets.symmetric(),
            child: SizedBox(
              width: double.infinity,
              height: 50.0,
              child: ElevatedButton(
                onPressed: _editprofile,
                child: Text(
                  'Update',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
                  ],
                ),
              ),
            ),
          ),
         
        ],
      ),
    ),
  );
}

}
