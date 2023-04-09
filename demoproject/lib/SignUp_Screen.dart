import 'dart:async';

import 'package:demoproject/home.dart';
import 'package:demoproject/ip.dart';
import 'package:flutter/material.dart';
import 'Fade_Animation.dart';
import 'Hex_Color.dart';
import 'Login_Screen.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

enum FormData { Name, Phone, Address, Email, Gender, password, ConfirmPassword }

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;

  FormData? selected;
 
final _formKey = GlobalKey<FormState>();
 int? _gender = 0;
  TextEditingController nameController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();

  void _submitForm() async {
  print(emailController.text.toString());
  print('entered submit form');
    final url = Uri.parse(ip+'/api/Customerregister/');
    // final url = Uri.parse('http://192.168.43.34:8000/api/Customerregister/');
    // final url = Uri.parse('http://10.0.2.2:8000/api/Customerregister/');  // replace with your own API endpoint
    final body = jsonEncode({
      'name': nameController.text.toString(),
      'address': addressController.text.toString(),
      'gender': _gender.toString(),
      'email': emailController.text.toString(),
      'phone':phoneController.text.toString(),
      'password': passwordController.text.toString(),
    });
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, body: body, headers: headers);
    
        // final response = await http.post(url, body: body,);


    if (response.statusCode == 201) {
      // Login successful, navigate to the next screen
      // Navigator.pushNamed(context, '/home');
      print('success');
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Successfully registered')),
    );
//     Timer(Duration(seconds: 5), () {
//   // code to execute after 5 seconds
// });
Future.delayed(Duration(seconds: 5), () {
  // code to execute after 5 seconds
});
       Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );

    } 
    else if(response.statusCode == 403){
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Email already exists')),
    );

    }
    
    
    
    else {
     ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Internal error occured!!')),
    );

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.4, 0.7, 0.9],
            colors: [
              HexColor("#4b4293").withOpacity(0.8),
              HexColor("#4b4293"),
              HexColor("#08418e"),
              HexColor("#08418e")
            ],
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                HexColor("#fff").withOpacity(0.2), BlendMode.dstATop),
            image: const AssetImage('assets/images/image.jpg'),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key:_formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Card(
                    elevation: 5,
                    color:
                        const Color.fromARGB(255, 171, 211, 250).withOpacity(0.4),
                    child: Container(
                      width: 400,
                      padding: const EdgeInsets.all(40.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeAnimation(
                            delay: 0.8,
                            child: Image.asset(
                              "assets/images/image2.png",
                              width: 110,
                              height: 110,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FadeAnimation(
                            delay: 1,
                            child: Container(
                              child: Text(
                                "Create your account",
                                style: TextStyle(
                                    color: Colors.white.withOpacity(0.9),
                                    letterSpacing: 0.5),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          
                          FadeAnimation(
                            delay: 1,
                            child: Container(
                              width: 300,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: selected == FormData.Email
                                    ? enabled
                                    : backgroundColor,
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: TextField(
                                controller: nameController,
                                onTap: () {
                                  setState(() {
                                    selected = FormData.Name;
                                  });
                                },
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.title,
                                    color: selected == FormData.Name
                                        ? enabledtxt
                                        : deaible,
                                    size: 20,
                                  ),
                                  hintText: 'Full Name',
                                  hintStyle: TextStyle(
                                      color: selected == FormData.Name
                                          ? enabledtxt
                                          : deaible,
                                      fontSize: 12),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.Name
                                        ? enabledtxt
                                        : deaible,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            delay: 1,
                            child: Container(
                              width: 300,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: selected == FormData.Phone
                                    ? enabled
                                    : backgroundColor,
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                               
                                controller: phoneController,
                                
                                onTap: () {
                                  setState(() {
                                    selected = FormData.Phone;
                                  });
                                },
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.phone_android_rounded,
                                    color: selected == FormData.Phone
                                        ? enabledtxt
                                        : deaible,
                                    size: 20,
                                  ),
                                  hintText: 'Phone Number',
                                  hintStyle: TextStyle(
                                      color: selected == FormData.Phone
                                          ? enabledtxt
                                          : deaible,
                                      fontSize: 12),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.Phone
                                        ? enabledtxt
                                        : deaible,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),

              
              FadeAnimation(
                delay: 1,
                child: Container(
                              width: 300,
                                height: 38,
                              // decoration: BoxDecoration(
                              //   borderRadius: BorderRadius.circular(12.0),
                              //   color: selected == FormData.Gender
                              //       ? enabled
                              //       : backgroundColor,
                              // ),
                              

                  child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Gender: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 214, 205, 205),                    fontSize: 15,
                      ),
                      ),
                      Radio(
                    value: 0,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  Text('Male',
                  style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 202, 194, 194),                   
                         fontSize: 14,
                      ),
                      ),
                  Radio(
                    value: 1,
                    groupValue: _gender,
                    onChanged: (value) {
                      setState(() {
                        _gender = value;
                      });
                    },
                  ),
                  Text('Female',
                   style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 202, 194, 194),                   
                         fontSize: 14,
                      ),               
                  ),
                      ],
                  ),
                          ),
                ),
              ) ,
                            
                          
                          const SizedBox(
                            height: 20,
                          ),     







                          FadeAnimation(
                            delay: 1,
                            child: Container(
                              width: 300,
                              height: 55,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: selected == FormData.Address
                                    ? enabled
                                    : backgroundColor,
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                maxLines: 2,
                                controller: addressController,
                               
                                onTap: () {
                                  setState(() {
                                    selected = FormData.Address;
                                  });
                                },
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.home_outlined,
                                    color: selected == FormData.Address
                                        ? enabledtxt
                                        : deaible,
                                    size: 20,
                                  ),
                                  hintText: 'Address',
                                  hintStyle: TextStyle(
                                      color: selected == FormData.Address
                                          ? enabledtxt
                                          : deaible,
                                      fontSize: 12),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.Address
                                        ? enabledtxt
                                        : deaible,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),                          



                          FadeAnimation(
                            delay: 1,
                            child: Container(
                              width: 300,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                color: selected == FormData.Email
                                    ? enabled
                                    : backgroundColor,
                              ),
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                controller: emailController,
                               
                                onTap: () {
                                  setState(() {
                                    selected = FormData.Email;
                                  });
                                },
                                decoration: InputDecoration(
                                  enabledBorder: InputBorder.none,
                                  border: InputBorder.none,
                                  prefixIcon: Icon(
                                    Icons.email_outlined,
                                    color: selected == FormData.Email
                                        ? enabledtxt
                                        : deaible,
                                    size: 20,
                                  ),
                                  hintText: 'Email',
                                  hintStyle: TextStyle(
                                      color: selected == FormData.Email
                                          ? enabledtxt
                                          : deaible,
                                      fontSize: 12),
                                ),
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.Email
                                        ? enabledtxt
                                        : deaible,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            delay: 1,
                            child: Container(
                              width: 300,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: selected == FormData.password
                                      ? enabled
                                      : backgroundColor),
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                               
                                controller: passwordController,
                                onTap: () {
                                  setState(() {
                                    selected = FormData.password;
                                  });
                                },
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.lock_open_outlined,
                                      color: selected == FormData.password
                                          ? enabledtxt
                                          : deaible,
                                      size: 20,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: ispasswordev
                                          ? Icon(
                                              Icons.visibility_off,
                                              color: selected == FormData.password
                                                  ? enabledtxt
                                                  : deaible,
                                              size: 20,
                                            )
                                          : Icon(
                                              Icons.visibility,
                                              color: selected == FormData.password
                                                  ? enabledtxt
                                                  : deaible,
                                              size: 20,
                                            ),
                                      onPressed: () => setState(
                                          () => ispasswordev = !ispasswordev),
                                    ),
                                    hintText: 'Password',
                                    hintStyle: TextStyle(
                                        color: selected == FormData.password
                                            ? enabledtxt
                                            : deaible,
                                        fontSize: 12)),
                                obscureText: ispasswordev,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.password
                                        ? enabledtxt
                                        : deaible,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FadeAnimation(
                            delay: 1,
                            child: Container(
                              width: 300,
                              height: 40,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: selected == FormData.ConfirmPassword
                                      ? enabled
                                      : backgroundColor),
                              padding: const EdgeInsets.all(5.0),
                              child: TextFormField(
                                 
                                controller: confirmPasswordController,
                                onTap: () {
                                  setState(() {
                                    selected = FormData.ConfirmPassword;
                                  });
                                },
                                decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    border: InputBorder.none,
                                    prefixIcon: Icon(
                                      Icons.lock_open_outlined,
                                      color: selected == FormData.ConfirmPassword
                                          ? enabledtxt
                                          : deaible,
                                      size: 20,
                                    ),
                                    suffixIcon: IconButton(
                                      icon: ispasswordev
                                          ? Icon(
                                              Icons.visibility_off,
                                              color: selected ==
                                                      FormData.ConfirmPassword
                                                  ? enabledtxt
                                                  : deaible,
                                              size: 20,
                                            )
                                          : Icon(
                                              Icons.visibility,
                                              color: selected ==
                                                      FormData.ConfirmPassword
                                                  ? enabledtxt
                                                  : deaible,
                                              size: 20,
                                            ),
                                      onPressed: () => setState(
                                          () => ispasswordev = !ispasswordev),
                                    ),
                                    hintText: 'Confirm Password',
                                    hintStyle: TextStyle(
                                        color:
                                            selected == FormData.ConfirmPassword
                                                ? enabledtxt
                                                : deaible,
                                        fontSize: 12)),
                                obscureText: ispasswordev,
                                textAlignVertical: TextAlignVertical.center,
                                style: TextStyle(
                                    color: selected == FormData.ConfirmPassword
                                        ? enabledtxt
                                        : deaible,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 25,
                          ),
                          FadeAnimation(
                            delay: 1,
                            child: TextButton(
                                onPressed: () {
                                  final fullname=nameController.text.toString();
                                    final gender=_gender;
                                  final addr=addressController.text.toString();
                                
                                  final signupemail=emailController.text.toString();
                                   final signupphone=phoneController.text.toString();
                                    final passwd=passwordController.text.toString();
                                     final cpasswd=confirmPasswordController.text.toString();                       
                                    final bool isValid = EmailValidator.validate(signupemail);


    //  if(fullname ==null || fullname.isEmpty){
                              
    //                            ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Please enter your name')),
    // );
    //                           return ;
                              
    //                         }


  if (fullname.trim().isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Please enter your name')),
  );
  return ;
} else if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(fullname.trim())) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Please enter a valid name')),
  );
  return ;
}


    //               if(signupphone ==null || signupphone.isEmpty || signupphone.length !=10 ){
                              
    //                            ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(content: Text('Please enter a valid phone number')),
    // );
    //                           return ;
                              
    //                         }


    else if (signupphone.trim().isEmpty) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Please enter your phone number')),
  );
  return ;
} else if (!RegExp(r'^[0-9]{10}$').hasMatch(signupphone.trim())) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Please enter a valid phone number')),
  );
  return ;
}



     if(gender !=0 && gender !=1){
                              
                               ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select your gender')),
    );
                              return ;
                              
                            }



                    if(addr ==null || addr.isEmpty){
                              
                               ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter your address')),
    );
                              return ;
                              
                            }  

  
  


                            if(signupemail ==null || signupemail.isEmpty || isValid==false){
                              ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please enter a valid email')),
    );
                              return ;
                               }

           
         

             if(passwd==null || passwd.isEmpty || passwd.length < 5 ){
                              
                              ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password too weak or empty')),
    );
                              return ;
                              
                            }

       if(passwd != cpasswd){
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("The passwords don't match")),
    );
                              return ;

       }

         _submitForm();
                                },
                                child: Text(
                                  "Sign Up",
                                  style: TextStyle(
                                    color: Colors.white,
                                    letterSpacing: 0.5,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xFF2697FF),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 14.0, horizontal: 80),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0)))),
                          ),
                        ],
                      ),
                    ),
                  ),
            
                  //End of Center Card
                  //Start of outer card
                  const SizedBox(
                    height: 10,
                  ),
            
                  FadeAnimation(
                    delay: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Exisiting account? ",
                            style: TextStyle(
                              color: Colors.grey,
                              letterSpacing: 0.5,
                            )),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) {
                              return LoginScreen();
                            }));
                          },
                          child: Text("Sign in",
                              style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                  fontSize: 14)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
