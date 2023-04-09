import 'dart:convert';

import 'package:demoproject/bottom.dart';
import 'package:demoproject/drawer.dart';
import 'package:demoproject/homeelements.dart';
import 'package:demoproject/ip.dart';
import 'package:demoproject/showtab.dart';
import 'package:demoproject/viewselectedmoviedetails.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;

class UserHome extends StatefulWidget {
  const UserHome({Key? key});

  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  List<dynamic>? myList;

  @override
  void initState() {
    // myList=[];
    super.initState();
    getMovies();
  }

  Future<void> getMovies() async {
    var request =
        http.MultipartRequest('POST', Uri.parse(ip + '/api/getmovieapp/'));
    // var request = http.MultipartRequest('POST', Uri.parse('http://192.168.43.34:8000/api/getmovieapp/'));
    //  var request = http.MultipartRequest('POST', Uri.parse('http://10.0.2.2:8000/api/getmovieapp/'));
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };
    request.headers.addAll(headers);

    var response = await request.send();
    if (response.statusCode == 200) {
      print('success');
      final body = await response.stream.bytesToString();
      final data = json.decode(body);
      print(data);

      setState(() {
        myList = data;
      });
    } else if (response.statusCode == 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Internal error occured')),
      );
    }
  }
//   void showMovieDetails(Map<String, dynamic> movieDetails) {
//   Navigator.push(
//     context,
//     MaterialPageRoute(
//       builder: (context) => MovieDetails(),
//     ),
//   );
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Homeelements(),
      drawer: Mydrawer(),
      // bottomNavigationBar: Screen1(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.lightBlue,
              Colors.black,
              Color.fromARGB(255, 236, 86, 75),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20, bottom: 15),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  side: BorderSide(
                      color: Color.fromARGB(255, 35, 117, 224), width: 4),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                  child: Text(
                    'Now Showing',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ),
            ),
            // myList == null
            //     ? const Center(child: CircularProgressIndicator())
            myList == null || myList!.isEmpty
                ? Center(
                    child: Text(
                      'No movies found',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                : CarouselSlider.builder(
                    itemCount: myList!.length,
                    itemBuilder:
                        (BuildContext context, int index, int realIndex) {
                      final item = myList![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MovieDetails(
                                movieid: item['id']?.toString(),
                              ),

                              // builder: (context) => MyWidget(),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                Image.network(
                                  ip + '/media/${item['image']}',
                                  // 'http://192.168.43.34:8000/media/${item['image']}',
                                  // 'http://10.0.2.2:8000/media/${item['image']}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                                Positioned(
                                  left: 8,
                                  top: 8,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        color: Colors.red,
                                        size: 24,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '${item['percentage'].toString()}%',
                                        // '80%',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  color: Colors.black.withOpacity(0.4),
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    item['name'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                    options: CarouselOptions(
                      height: MediaQuery.of(context).size.height * 0.6,
                      viewportFraction: 0.8,
                      enlargeCenterPage: true,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 5),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
