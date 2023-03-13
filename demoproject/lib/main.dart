// import 'package:bankapp/sigin.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:demoproject/Login_Screen.dart';
import 'package:demoproject/home.dart';
import 'package:demoproject/homepage.dart';
import 'package:demoproject/signin.dart';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  // runApp(MaterialApp(home: LoginScreen(),));
  runApp(MaterialApp(debugShowCheckedModeBanner: false,
  home: AnimatedSplashScreen(
            
             
            duration: 2000,
            splash: Image.asset('assets/images/start.png',                              
                              width: 200,
                              height: 200),
                              
            // nextScreen: LoginScreen(),
            nextScreen: HomePage(),
            splashTransition: SplashTransition.fadeTransition,
           
            backgroundColor: Colors.white),
      
            ));

  
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
    final _formKey = GlobalKey<FormState>();
    final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
    final _phoneController = TextEditingController();
        final _cpasswordController = TextEditingController();
 String _errorMessage = '';

void _submitForm() async {
  print(_emailController.text.toString());
  print('entered submit form');
    // final url = Uri.parse('http://192.168.177.227:8000/api/Customerregister/');
    final url = Uri.parse('http://10.0.2.2:8000/api/Customerregister/'); // replace with your own API endpoint
    final body = jsonEncode({
      'email': _emailController.text.toString(),
      'phone':_phoneController.text.toString(),
      'password': _passwordController.text.toString(),
    });
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, body: body, headers: headers);
        // final response = await http.post(url, body: body,);


    if (response.statusCode == 201) {
      // Login successful, navigate to the next screen
      // Navigator.pushNamed(context, '/home');
      // print('success');
       Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Home()),
                );

    } else {
      // Login failed, display error message
      // setState(() {
      //   _errorMessage = 'Invalid username or password';
      // });
            print('failure');

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Container(
              
              margin: EdgeInsets.only(top: 25),
              child: Form(
                key:_formKey ,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: TextFormField(
                        controller: _emailController,
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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: TextFormField(
                        controller: _phoneController,
                        validator: (value) {
                           if(value ==null || value.isEmpty || value.length !=10 ){
                              // EmailValidator.validate(value!);
                              return 'Please enter valid phone';
                              
                            }
                        },
                        decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15)
                                      ),
                            
                        labelText: 'Phone',
                        prefixIcon: Icon(Icons.phone_android_rounded)
                      ),),
                    ),
                                SizedBox(height: 10,),
                      
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      child: TextFormField(
                        controller:_passwordController ,
                        validator: (value) {
                          if(value ==null || value.isEmpty ){
                              // EmailValidator.validate(value!);
                              return 'Please enter some text';
                              
                            }
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
                      
                    Card(
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        
                      child: TextFormField(
                        controller: _cpasswordController,
                        validator: (value) {
                          if(value ==null || value.isEmpty ){
                              // EmailValidator.validate(value!);
                              return 'Please enter some text';
                              
                            }
                        },
                        
                        decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(15)
                                        ),
                            
                        labelText: 'Confirm Password',
                        prefixIcon: Icon(Icons.key)
                      ),
                      ),
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
                 _submitForm();
              }
          
                      }, child: Text('Signup'))),
                    TextButton(onPressed: (){
                       Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Signin()),
                );

               




                    }, child: Text('Already a user?'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}