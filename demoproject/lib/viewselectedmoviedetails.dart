import 'dart:convert';
import 'package:demoproject/bottom.dart';
import 'package:demoproject/homeelements.dart';
import 'package:demoproject/ip.dart';
import 'package:demoproject/seats.dart';
import 'package:demoproject/seats2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class MovieDetails extends StatefulWidget {
  String? movieid;

  MovieDetails({required this.movieid});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> with TickerProviderStateMixin {
  final storage = FlutterSecureStorage();
  Map<String, dynamic> movieData = {};
  Map<dynamic, dynamic> newshowlist = {};
  // late TabController _tabController;
  String? bdate;
  String? movietype;
    List<dynamic>? dateList;
    List<dynamic>? showlist;
    int? tabLength;
    bool _isLiked = false;
  bool _isDisliked = false;
  @override
  void initState() {
    super.initState();
     dateList=[];
    showlist=[];
    getselectedmovie();
    getrating();
    getshowapp();
   
      // _tabController = TabController(length: 3, vsync: this);
  }

  void getselectedmovie() async {
    final token = await storage.read(key: 'token');
    String? mid = widget.movieid.toString();
    var url = Uri.parse(ip + '/api/getselectedmovie/$mid/');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      // final body = await response.stream.bytesToString();
      //  final data = json.decode(body);
      //  print(data);
      setState(() {
        

        movieData = json.decode(response.body);
        dateList=movieData['dates'];
        movietype=movieData['dimension'];
        // showlist=movieData['show'];
         tabLength = dateList!.length > 3 ? 3 : dateList!.length;
        // tabLength = (dateList?.length ?? 0) > 3 ? 3 : (dateList?.length ?? 0);


        print(movieData['dates']);
        print("*****");
        print(dateList![0]);
        print(movieData['show']);
      });
    }
  }

    void getshowapp() async {
    final token = await storage.read(key: 'token');
    String? mid = widget.movieid.toString();
    var url = Uri.parse(ip + '/api/getshowapp/$mid/');

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',
      },
    );

    if (response.statusCode == 200) {
      print("Success*****");
      // final body = await response.stream.bytesToString();
       final data = json.decode(response.body);
       print(data);
       setState(() {
         newshowlist=data;
          bdate = newshowlist.keys.toList()[0];
       });
      // setState(() {
        

      //   movieData = json.decode(response.body);
      //   dateList=movieData['dates'];
      //   // showlist=movieData['show'];
      //    tabLength = dateList!.length > 3 ? 3 : dateList!.length;
      //   // tabLength = (dateList?.length ?? 0) > 3 ? 3 : (dateList?.length ?? 0);


      //   print(movieData['dates']);
      //   print("*****");
      //   print(dateList![0]);
      //   print(movieData['show']);
      // });
    }
  }

void saverating() async {
  final token = await storage.read(key: 'token');
  String? mid = widget.movieid.toString();
  var url = Uri.parse(ip + '/api/saverating/$mid/');

  var ratingValue;
  if (_isLiked) {
    ratingValue = 1;
  } else if (_isDisliked) {
    ratingValue = 0;
  } else {
    ratingValue = -1;
  }

  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    },
    body: json.encode({
      'rating': ratingValue,
    }),
  );

  if (response.statusCode == 200) {
    // Do something with the response data here
  }
}

void getrating() async {
  final token = await storage.read(key: 'token');
  String? mid = widget.movieid.toString();
  var url = Uri.parse(ip + '/api/getrating/$mid/');

  var response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
      'Authorization': '$token',
    },
  );

  if (response.statusCode == 200) {
    var rating = json.decode(response.body)['rating'];

    setState(() {
      _isLiked = rating == 1;
      _isDisliked = rating == 0;
    });
  }
}



 @override
  Widget build(BuildContext context) {
    return DefaultTabController(
  length:newshowlist.keys.length,
  child: Scaffold(
    appBar: AppBar(
      title: Text('Movie Details'),
    ),
    bottomNavigationBar: Screen1(),
    body: Column(
      children: [
        Container(
          child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
          image: DecorationImage(
            image: MemoryImage(
              base64.decode(movieData['image'] ?? ''),
            ),
            fit: BoxFit.cover,
          ),
        ),
      ),
       Positioned(
                          top: 10,
                          right: 10,
                          child: Row(
                            children: [
                              IconButton(
                              onPressed: () {
                                setState(() {
                                  _isLiked = !_isLiked;
                                  if (_isLiked) {
                                    _isDisliked = false;
                                  }
                                });
                                saverating();
                              },
                              icon: Icon(
                                Icons.thumb_up,
                                color: _isLiked ? Colors.blue : Colors.white,
                              ),
                            ),
                            const SizedBox(width: 10),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _isDisliked = !_isDisliked;
                                  if (_isDisliked) {
                                    _isLiked = false;
                                  }
                                });
                                saverating();
                              },
                              icon: Icon(
                                Icons.thumb_down,
                                color:
                                    _isDisliked ? Colors.red : Colors.white,
                              ),
                            ),

                            ],
                          ),
                        ),




    //    Positioned(
    //   top: 10,
    //   right: 10,
    //   child: Row(
    //     children: [
    //       IconButton(
    //         onPressed: () {
    //           // Handle like button press
    //         },
    //         icon: Icon(
    //           Icons.thumb_up,
    //           color: Colors.white,
    //           size: 24,
    //         ),
    //       ),
    //       IconButton(
    //         onPressed: () {
    //           // Handle dislike button press
    //         },
    //         icon: Icon(
    //           Icons.thumb_down,
    //           color: Colors.white,
    //           size: 24,
    //         ),
    //       ),
    //     ],
    //   ),
    // ),
    // Positioned(
    //   top: 10,
    //   right: 10,
    //   child: Row(
    //     children: [
    //       IconButton(
    //         onPressed: () {
    //           setState(() {
    //             _isLiked = !_isLiked;
    //             if (_isLiked) {
    //               _isDisliked = false;
    //             }
    //           });
    //         },
    //         icon: Icon(
    //           Icons.thumb_up,
    //           color: _isLiked ? Colors.blue : Colors.white,
    //           size: 24,
    //         ),
    //       ),
    //       IconButton(
    //         onPressed: () {
    //           setState(() {
    //             _isDisliked = !_isDisliked;
    //             if (_isDisliked) {
    //               _isLiked = false;
    //             }
    //           });
    //         },
    //         icon: Icon(
    //           Icons.thumb_down,
    //           color: _isDisliked ? Colors.red : Colors.white,
    //           size: 24,
    //         ),
    //       ),
    //     ],
    //   ),
    // ),

      
                  Positioned(
                    bottom: 9,
                    left: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movieData['name'] ?? '',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                         SizedBox(height: 3),
                     Container(
                       padding: EdgeInsets.all(7),
                       decoration: BoxDecoration(
                         color: Colors.black.withOpacity(0.5),
                         borderRadius: BorderRadius.circular(12),
                       ),
                       child: Row(
                         crossAxisAlignment: CrossAxisAlignment.end,
                         children: [
                           Card(
                             color: Colors.white.withOpacity(0.7),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(8),
                             ),
                             child: Padding(
                               padding: EdgeInsets.all(8),
                               child: Text(
                                 '${movieData['dimension'] ?? ''}',
                                 style: TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black,
                                 ),
                               ),
                             ),
                           ),
                           SizedBox(height: 8),
                           Card(
                             color: Colors.white.withOpacity(0.7),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(8),
                             ),
                             child: Padding(
                               padding: EdgeInsets.all(8),
                               child: Text(
                                 '${movieData['certification'] ?? ''}',
                                 style: TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black,
                                 ),
                               ),
                             ),
                           ),
                           SizedBox(height: 8),
                           Card(
                             color: Colors.white.withOpacity(0.7),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(8),
                             ),
                             child: Padding(
                               padding: EdgeInsets.all(8),
                               child: Text(
                                //  '${movieData['duration'] ?? ''}',
                                '${movieData['duration'] != null ? '${movieData['duration'] ~/ 60} hr ${movieData['duration'] % 60} min' : ''}',
                                 
                                 style: TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black,
                                 ),
                               ),
                             ),
                           ),
                           SizedBox(height: 8),
                           Card(
                             color: Colors.white.withOpacity(0.7),
                             shape: RoundedRectangleBorder(
                               borderRadius: BorderRadius.circular(8),
                             ),
                             child: Padding(
                               padding: EdgeInsets.all(8),
                               child: Text(
                                 '${movieData['category'] ?? ''}',
                                 style: TextStyle(
                                   fontSize: 16,
                                   fontWeight: FontWeight.bold,
                                   color: Colors.black,
                                 ),
                               ),
                             ),
                           ),
                         ],
                       ),
                     ),
                     ],
                      
                    ),
                  ),
  
                ],
              ),
              SizedBox(height: 8),
              Row(
    children: [
      Card(
        color: Colors.white.withOpacity(0.9),
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Icon(Icons.calendar_month),
              SizedBox(width: 4.0),
              Text(
                '${movieData['year'] ?? ''}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
      SizedBox(width: 16.0),
      Card(
        color: Colors.white.withOpacity(0.9),
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Icon(Icons.translate),
              SizedBox(width: 4.0),
              Text(
                '${movieData['language'] ?? ''}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
          SizedBox(width: 16.0),
      Card(
        color: Colors.white.withOpacity(0.9),
        elevation: 3.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            width: 1.0,
            color: Colors.grey.withOpacity(0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Row(
            children: [
              Icon(Icons.theater_comedy),
              SizedBox(width: 4.0),
              Text(
                '${movieData['description'] ?? ''}',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
  
 
  
  
  
  ],
  ),
  ),
        ),
       SingleChildScrollView(
  child: Container(
    child: TabBar(
      onTap: ((value) {
    setState(() {
                  bdate = newshowlist.keys.toList()[value];
                                    print("%%%%");

                  print(bdate);
                });
      }),
      labelColor: Colors.blue,
      unselectedLabelColor: Colors.grey,
      indicatorColor: Colors.blue,
      indicatorWeight: 4,
      tabs: newshowlist.keys.map((date) {
        return Tab(
          child: Text(
            '${date}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Montserrat',
            ),
          ),
        );
      }).toList(),
    ),
  ),
),

    // ],
          // ),
        // ),
SizedBox(height: 7),
Expanded(
  child: TabBarView(
    children: newshowlist.values.map((times) {
      return ListView.builder(
        itemCount: times.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              print("KKKKKK");
              print(bdate);
              
               if (movieData['screen'] == "Screen 2 2K Dolby 7.1") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => viewseats(
                          movieid: widget.movieid,
                          showid: times[index],
                          bdate: bdate,
                          movietype: movietype,
                        ),
                      ),
                    );
                    } 
                    else if (movieData['screen'] == "Screen 1 4K Dolby Atmos") {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => viewseats2(
                          movieid: widget.movieid,
                          showid: times[index],
                          bdate: bdate,
                          movietype: movietype,
                        ),
                      ),
                    );
                  }



              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => viewseats( movieid:widget.movieid, showid:times[index],bdate: bdate,),
              //   ),
              // );
            },
            child: Card(
              elevation: 10,
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.lightGreen,
                      Colors.green,
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.access_time),
                          Text(
                            times[index],
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(Icons.chair),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${movieData['screen'] ?? ''}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontStyle: FontStyle.italic,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              color: Colors.white,
            ),
          );
        },
      );
    }).toList(),
  ),
),




    ]
    ),
  ),
);
  

}

}

  





