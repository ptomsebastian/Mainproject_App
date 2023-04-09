import 'package:demoproject/drawer.dart';
import 'package:demoproject/homeelements.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Accountnumberotp extends StatefulWidget {
  const Accountnumberotp({super.key});

  @override
  State<Accountnumberotp> createState() => _AccountnumberotpState();
}

class _AccountnumberotpState extends State<Accountnumberotp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: Homeelements(),
      drawer:  Mydrawer(),
      body: Center(
        child: Column(
          children: [],
        ),
      ),
    );
  }
}