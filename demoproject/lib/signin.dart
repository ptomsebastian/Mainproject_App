// import 'package:DE/main.dart';
import 'package:demoproject/home.dart';
import 'package:demoproject/ip.dart';
import 'package:demoproject/main.dart';
import 'package:demoproject/userdash.dart';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';





class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final _formKey = GlobalKey<FormState>();
  final storage = new FlutterSecureStorage();

  final _email = TextEditingController();
  final _password = TextEditingController();
Future<void> _login() async {
  
  print('sigin clicked');
  final response = await http.post(

      Uri.parse(ip+'/api/userlogin/'),
    // Uri.parse('http://192.168.43.34:8000/api/userlogin/'),
    //  Uri.parse('http://10.0.2.2:8000/api/userlogin/'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': _email.text,
      'password': _password.text,
    }),
  );
    // print(response.body);

  if (response.statusCode == 201) {
     final data = jsonDecode(response.body);
    final token = data['token'];
    // final token = json.decode(response.body)['token'];
    await storage.write(key: 'token', value: token);
    print(token);
    // print(response.body);
    // print('success');
    // Navigator.push(
    //               context,
    //               MaterialPageRoute(builder: (context) => Home()),
    //             );
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (ctx) =>
    UserHome()), (Route<dynamic> route) => false);
    // Navigator.pushNamed(context, '/home');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid login credentials')),
    );
    print('failure');
  }
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 200,left: 10,right: 10),
        child: Form(
          key:_formKey ,
          child: Column(
            children: [
             Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: TextFormField(
                        controller: _email,
                        validator: (value) {
                          final bool isValid = EmailValidator.validate(value.toString());
                          if(value ==null || value.isEmpty || isValid==false){
                            return 'Please enter some valid email';
      //                       ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Processing Data')),
      // );
                          }
                        },
                        decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_rounded)
                      ),),
                    ),
        
                                SizedBox(height: 10,),
                                 Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        controller: _password,
                         validator: (value) {
                          
                          if(value ==null || value.isEmpty ){
                            // EmailValidator.validate(value!);
                            return 'Please enter some text';
                            
                          }
                           
                        
                          
      //                       ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Processing Data')),
      // );
                         
                        },
                        decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15)
                                      ),
                            
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.key)
                      ),),
                    ),
                                SizedBox(height: 10,),
                      
              SizedBox(
                width: 350,
                height: 45,
                child: ElevatedButton(onPressed: (){
                            if (_formKey.currentState!.validate()) {
      // If the form is valid, display a snackbar. In the real world,
      // you'd often call a server or save the information in a database.
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(content: Text('Processing Data')),
      // );
      _login();
    
    }
               

                }, child: Text('Signin'))),
               TextButton(onPressed: (){
                       Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
                    }, child: Text('New User?'))
            ],
          ),
        ),
      ),
    );
  }
}