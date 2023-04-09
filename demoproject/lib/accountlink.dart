
import 'package:demoproject/drawer.dart';
import 'package:demoproject/homeelements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Accountlink extends StatefulWidget {
  const Accountlink({super.key});

  @override
  State<Accountlink> createState() => _AccountlinkState();
}

class _AccountlinkState extends State<Accountlink> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: Homeelements(),
      drawer:  Mydrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           SizedBox(
            width: 300,
             child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      child: TextFormField(
                        
                        
                        decoration: InputDecoration(
                          
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15)
                        ),
                        labelText: 'Account Number',
                        prefixIcon: Icon(Icons.pin),
                        
                      ),),
                    ),
           ),

           SizedBox(
            width: 290,
             child: ElevatedButton.icon(onPressed: (() {
                           
                         }), icon: Icon(Icons.add), label: Text('Add Existing account'),),
           ),
                       SizedBox(height: 20,),
                        SizedBox(
                          width: 290,
                          child: ElevatedButton.icon(onPressed: (() {
                           
                                               }),icon: Icon(Icons.money_rounded), label: Text('Request New Account'),
                                               style: ElevatedButton.styleFrom(
                primary: Colors.amber,
            ),),
                        )
          ],
        ),
      ),
    );
  }
}