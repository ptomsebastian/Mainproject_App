import 'dart:convert';
import 'package:demoproject/bottom.dart';
import 'package:demoproject/ip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ViewBookingsApp extends StatefulWidget {
  @override
  _ViewBookingsAppState createState() => _ViewBookingsAppState();
}

class _ViewBookingsAppState extends State<ViewBookingsApp> {
  final storage = FlutterSecureStorage();
  List<Map<String, dynamic>> _bookings = [];

  Future<void> _fetchBookingDetails() async {
    final token = await storage.read(key: 'token');
    var url = Uri.parse(ip + '/api/viewbookingsapp/');
    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );
    if (response.statusCode == 200) {
      setState(() {
        _bookings = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      // Handle error
      print('Error fetching booking details');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchBookingDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 4,
        title: Row(
          children: [
            Icon(Icons.local_movies, color: Colors.black),
            SizedBox(width: 10),
            Text(
              'Movie Tickets',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Screen1(),
      body: _bookings.isEmpty
        ? Center(child: Text('No bookings found'))
        :ListView.builder(
        itemCount: _bookings.length,
        itemBuilder: (BuildContext context, int index) {
          Map<String, dynamic> booking = _bookings[index];
          return Card(
            color: Colors.grey[800],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(color: Colors.white),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.red, Colors.orange],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.movie, color: Colors.white, size: 30),
                      Text(
                        '${booking['moviename'] ?? ''}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 19,
                        ),
                      ),
                      Icon(Icons.local_movies, color: Colors.white, size: 30),
                    ],
                  ),
                ),
                Divider(color: Colors.white),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 300, // Set a fixed width for the container
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.confirmation_number,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  'Booking ID:',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  '${booking['id'] ?? ''}',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.laptop,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  'Screen Name:',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    '${booking['screenname'] ?? ''}',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.event_seat,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  'Seat Number:',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    '${booking['seatnumber'] ?? ''}',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.access_time,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  'Show Time:',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    '${booking['bookingshow'] ?? ''}',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5),
                            Row(
                              children: [
                                Icon(Icons.date_range,
                                    color: Colors.white, size: 20),
                                SizedBox(width: 10),
                                Text(
                                  'Show Date:',
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    '${booking['bookingdate'] ?? ''}',
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.end,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    'Valid only for the show and date mentioned above.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.yellow,
                                      fontStyle: FontStyle.italic,
                                      fontSize: 14.0,
                                      // fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
