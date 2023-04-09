import 'package:demoproject/userdash.dart';
import 'package:demoproject/viewbookingsapp.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'dart:convert';
import 'package:book_my_seat/book_my_seat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:demoproject/bottom.dart';
import 'package:demoproject/drawer.dart';
import 'package:demoproject/homeelements.dart';
import 'package:demoproject/ip.dart';
import 'package:demoproject/showtab.dart';
import 'package:demoproject/viewselectedmoviedetails.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';

class viewseats extends StatefulWidget {
  String? movieid;
  String? showid;
  String? bdate;
  String? movietype;
  viewseats(
      {required this.movieid, required this.showid, required this.bdate,required this.movietype});
  // const viewseats({super.key});

  @override
  State<viewseats> createState() => _viewseatsState();
}

class ScreenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color.fromARGB(255, 219, 214, 214)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final double borderRadius = 6;
    final double sideLength = size.height - 45;
    final double slantFactor = 0.8; // adjust to control slant factor

    final topPath = Path()
      ..moveTo(borderRadius, 0)
      ..lineTo(size.width - borderRadius, 0)
      ..lineTo(
          size.width - borderRadius - (slantFactor * sideLength), sideLength)
      ..lineTo(borderRadius + (slantFactor * sideLength), sideLength)
      ..close();

    final sidePath = Path()
      ..moveTo(size.width - borderRadius, 0)
      ..lineTo(
          size.width - borderRadius - (slantFactor * sideLength), sideLength)
      ..lineTo(size.width - borderRadius - (slantFactor * sideLength),
          sideLength - borderRadius)
      ..lineTo(size.width, borderRadius)
      ..lineTo(size.width, 0)
      ..close();

    // canvas.drawPath(topPath, paint);
    canvas.drawPath(topPath, paint..style = PaintingStyle.fill);
    // canvas.drawPath(sidePath, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _viewseatsState extends State<viewseats> {
  Set<SeatNumber> selectedSeats = Set();
  final storage = FlutterSecureStorage();
  String? name;
    String? phone;
    String? usermail; 


  // late List<List<SeatState>> seatStateData=[[]];
  // late List<List<SeatState>> seatStateData=[]
  final List<List<SeatState>> seatStateData = [];
  List<String>? bookedSeats;
  bool isCompleted = false;
  Razorpay? _razorpay;

  Future<void> loadBookings() async {
    await getbookings();
    initializeSeatStates();
  }

  void initializeSeatStates() {
    //LOOP FOR ADDING PATH BETWEEN SEATS

    for (int i = 0; i < 10; i++) {
      // print(bookedSeats);
      List<SeatState> row = [];
      for (int j = 0; j < 10; j++) {
        String seatNumber = (i * 10 + j).toString().padLeft(2, '0');
        // print(seatNumber);
        if(j==5 && i !=9)
        {
           row.add(SeatState.empty);
        }
       else if (bookedSeats != null &&
            bookedSeats!.contains(seatNumber.toString())) {
          row.add(SeatState.sold);
        } else {
          row.add(SeatState.unselected);
        }
      }
      seatStateData.add(row);
    }
    setState(() {
      isCompleted = true;
    });
  }

  Future<void> getbookings() async {
    // your code to fetch the bookings
    final token = await storage.read(key: 'token');
    print(token);

    var request =
        http.MultipartRequest('POST', Uri.parse(ip + '/api/getbookings/'));
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': '$token',
    };
    request.headers.addAll(headers);
   request.fields['movie'] = widget.movieid.toString();
      request.fields['show'] = widget.showid.toString();
      request.fields['date'] = widget.bdate.toString();


    var response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      final data = json.decode(body);
      // print(data);
      // Map<String, dynamic> data2 = {'booked': [90, 91, 53, 94, 93, 92, 91, 29, 11]};

      bookedSeats = List<String>.from(data['booked']);
    }
  }

  void openCheckout() async {
    int rate;
    if(widget.movietype=="3D"){
      rate=140;
    }
    else{
      rate=110;
      }
    var options = {
      'key': 'rzp_test_NNbwJ9tmM0fbxj',
      'amount': rate*100,
      'name': name,
      'description': 'Payment',
      'prefill': {'contact': phone, 'email': usermail},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay!.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    gotobooking();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
        "SUCCESS: " + response.paymentId.toString(),
      )),
    );
    // Fluttertoast.showToast(
    //     msg: "SUCCESS: " + response.paymentId.toString(),);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
        "ERROR: " +
            response.code.toString() +
            " - " +
            response.message.toString(),
      )),
    );
    // Fluttertoast.showToast(
    //     msg: "ERROR: " + response.code.toString() + " - " + response.message.toString(),
    //     );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(
        "EXTERNAL_WALLET: " + response.walletName.toString(),
      )),
    );
    // Fluttertoast.showToast(
    //     msg: "EXTERNAL_WALLET: " + response.walletName.toString(),);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay!.clear();
  }

  @override
  void initState() {
//     List<List<SeatState>> seatStateData = List.generate(
//   10,
//   (i) => List.generate(
//     10,
//     (j) => SeatState.unselected,
//   ),
// );

    loadBookings();

    super.initState();
    _razorpay = Razorpay();
    _razorpay!.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay!.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay!.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    getdetails();
  }

  getdetails() async{
      name = await storage.read(key: 'name');
     phone = await storage.read(key: 'phone');
     usermail = await storage.read(key: 'usermail'); 
}

  gotobooking() async {
    final token = await storage.read(key: 'token');
    print(token);

    var request =
        http.MultipartRequest('POST', Uri.parse(ip + '/api/gotobooking/'));
    final Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
      'Authorization': '$token',
    };
    request.headers.addAll(headers);
    request.fields['seats'] = selectedSeats.toString();
       request.fields['movie'] = widget.movieid.toString();
      request.fields['show'] = widget.showid.toString();
      request.fields['date'] = widget.bdate.toString();
    // request.fields['message'] = _message.text.toString();

    var response = await request.send();
    if (response.statusCode == 200) {
       Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (ctx) => ViewBookingsApp()),
            (Route<dynamic> route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 16,
            ),
            Text(
              "Screen this side",
              style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic),
            ),
            // const SizedBox(
            //   height: 5,
            // ),
            CustomPaint(
              size: Size(double.infinity, 100),
              painter: ScreenPainter(),
            ),

            Flexible(
              child: SizedBox(
                width: double.maxFinite,
                height: 500,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
// (bookedSeats == null || bookedSeats!.isEmpty) ? SizedBox() :

                      isCompleted != true
                          ? SizedBox()
                          : SeatLayoutWidget(
                              onSeatStateChanged: (rowI, colI, seatState) {
                                ScaffoldMessenger.of(context)
                                    .hideCurrentSnackBar();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: seatState == SeatState.selected
                                        ? Text("Selected Seat[$rowI][$colI]")
                                        : Text(
                                            "De-selected Seat[$rowI][$colI]"),
                                  ),
                                );
                                if (seatState == SeatState.selected) {
                                  selectedSeats
                                      .add(SeatNumber(rowI: rowI, colI: colI));
                                } else {
                                  selectedSeats.remove(
                                      SeatNumber(rowI: rowI, colI: colI));
                                }
                              },
                              stateModel: SeatLayoutStateModel(
                                pathDisabledSeat:
                                    'assets/svg_disabled_bus_seat.svg',
                                pathSelectedSeat:
                                    'assets/svg_selected_bus_seats.svg',
                                pathSoldSeat: 'assets/svg_sold_bus_seat.svg',
                                pathUnSelectedSeat:
                                    'assets/svg_unselected_bus_seat.svg',
                                rows: 10,
                                cols: 10,
                                seatSvgSize: 40,
                                currentSeatsState: seatStateData,
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg_disabled_bus_seat.svg',
                        width: 15,
                        height: 15,
                      ),
                      const Text('Disabled')
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg_sold_bus_seat.svg',
                        width: 15,
                        height: 15,
                      ),
                      const Text('Sold')
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg_unselected_bus_seat.svg',
                        width: 15,
                        height: 15,
                      ),
                      const Text('Available')
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SvgPicture.asset(
                        'assets/svg_selected_bus_seats.svg',
                        width: 15,
                        height: 15,
                      ),
                      const Text('Selected by you')
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                if (selectedSeats.isEmpty ) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select your seat')),
                  );
                } else {
                  // print(selectedSeats);
                  openCheckout();
                  // gotobooking();
                  setState(() {});
                }
              },
              child: const Text('BOOK'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.resolveWith(
                    (states) => const Color(0xFFfc4c4e)),
              ),
            ),
            const SizedBox(height: 12),
            Text(selectedSeats.join(" , "))
          ],
        ),
      ),
    );
  }
}

class SeatNumber {
  final int rowI;
  final int colI;

  const SeatNumber({required this.rowI, required this.colI});

  @override
  bool operator ==(Object other) {
    return rowI == (other as SeatNumber).rowI &&
        colI == (other as SeatNumber).colI;
  }

  @override
  int get hashCode => rowI.hashCode;

  @override
  String toString() {
    return '[$rowI][$colI]';
  }
}
