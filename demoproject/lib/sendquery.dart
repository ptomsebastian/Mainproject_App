import 'package:demoproject/bottom.dart';
import 'package:demoproject/drawer.dart';
import 'package:demoproject/getnews.dart';
import 'package:demoproject/homeelements.dart';
import 'package:demoproject/ip.dart';
import 'package:demoproject/updateprofile.dart';
import 'package:demoproject/userdash.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;


class SendQuery extends StatefulWidget {
  const SendQuery({Key? key}) : super(key: key);

  @override
  State<SendQuery> createState() => _SendQueryState();
}

class _SendQueryState extends State<SendQuery> {
  final storage = FlutterSecureStorage();
  final _subject = TextEditingController();
  final _message = TextEditingController();

  void sendquery() async {
    final token = await storage.read(key: 'token');
    print(token);

    if (_subject.text.toString().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your subject')),
      );
    } else if (_message.text.toString().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your message')),
      );
    } else {
      var request =
          http.MultipartRequest('POST', Uri.parse(ip+'/api/getquery/'));
          // http.MultipartRequest('POST', Uri.parse('http://192.168.43.34:8000/api/getquery/'));
      // var request =
      //     http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:8000/api/getquery/'));
      final Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'Authorization': '$token',
      };
      request.headers.addAll(headers);
      request.fields['subject'] = _subject.text.toString();
      request.fields['message'] = _message.text.toString();

      var response = await request.send();
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your query successfully send')),
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => UserHome()),
            (Route<dynamic> route) => false);
      } else if (response.statusCode == 409) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Your previous request is already pending')),
        );
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => UserHome()),
            (Route<dynamic> route) => false);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An internal error occurred')),
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
    body: Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: const Padding(
                padding: EdgeInsets.only(top: 6, bottom: 15),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    side: BorderSide(color: Color.fromARGB(255, 35, 117, 224), width: 4),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                    child: Text(
                      'Enquiry / Feedback',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 14),
            Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Subject',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: _subject,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.label_important_rounded),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueGrey[800]!,
                          ),
                        ),
                        hintText: 'Enter subject',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Message',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Colors.blueGrey[800],
                      ),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      controller: _message,
                      maxLines: null,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.message),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.blueGrey[800]!,
                            
                          ),
                        ),
                        hintText: 'Enter message',
                        hintStyle: TextStyle(
                          color: Colors.grey[500],
                        ),
                      ),
                    ),
                    SizedBox(height: 24.0),
                    SizedBox(
                      width: double.infinity,
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: sendquery,
                        child: Text(
                          'Send',
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}



}
