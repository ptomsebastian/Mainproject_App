import 'dart:convert';
import 'package:demoproject/bottom.dart';
import 'package:demoproject/homeelements.dart';
import 'package:demoproject/ip.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

 class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
  length: 2,
  child: Scaffold(
    appBar: AppBar(
      title: Text('TabBar Demo'),
    ),
    body: Column(
      children: [
        Container(
          child: Text("haiii"),
        ),
        Container(
          margin: EdgeInsets.only(top: 300.0),
          child: TabBar(
            tabs: [
              Tab(
                child: Text(
                  "Tab 1",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Tab(
                child: Text(
                  "Tab 2",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [
              Container(
                color: Colors.blue,
                child: Center(
                  child: Text('Tab 1 Content'),
                ),
              ),
              Container(
                color: Colors.red,
                child: Center(
                  child: Text('Tab 2 Content'),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);


  }
}