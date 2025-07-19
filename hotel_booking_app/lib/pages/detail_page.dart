import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:hotel_booking_app/services/constant.dart';
import 'package:hotel_booking_app/services/database.dart';
import 'package:hotel_booking_app/services/shared_pref.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'package:http/http.dart' as http;
import '../services/widget_support.dart';

class DetailPage extends StatefulWidget {
  String name, price, wifi, hdtv, kitchen, bathroom, description, hotelid;
  DetailPage(
      {required this.bathroom,
      required this.description,
      required this.hdtv,
      required this.kitchen,
      required this.name,
      required this.price,
      required this.wifi,
      required this.hotelid});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? paymentIntent;
  TextEditingController guestscontroller = new TextEditingController();

  int? finalAmount;
  DateTime? startDate;
  DateTime? endDate;
  int daysDifference = 1;
  String? username, userid, userimage, wallet, id;

  getontheload() async {
    username = await SharedpreferenceHelper().getUserName();
    wallet = await SharedpreferenceHelper().getUserWallet();
    userid = await SharedpreferenceHelper().getUserId();
    userimage = await SharedpreferenceHelper().getUserImage();
    id = await SharedpreferenceHelper().getUserId();
    //print(username);
    //print(userid);
    //print(userimage);
    //setState(() {});
  }

  @override
  void initState() {
    super.initState();
    finalAmount = int.parse(widget.price);
    getontheload();
  }

  Future<void> _selectStartDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: startDate ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        startDate = picked;
        _calculateDifference();
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate:
            endDate ?? (startDate ?? DateTime.now()).add(const Duration(days: 1)),
        firstDate: startDate ?? DateTime.now(),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        endDate = picked;
        _calculateDifference();
      });
    }
  }

  void _calculateDifference() {
    if (startDate != null && endDate != null) {
      daysDifference = endDate!.difference(startDate!).inDays;
      finalAmount = int.parse(widget.price) * daysDifference!;
    }
  }

  String _formatDate(DateTime? date) {
    return date != null
        ? DateFormat("dd MMM yyyy").format(date)
        : "Select date";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(229, 246, 242, 242),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.5,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                    child: Image.asset(
                      "images/hotel1.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(left: 20.0, top: 30.0),
                    padding: const EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0, right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    widget.name,
                    style: AppWidget.headlinetextstyle(27.0),
                  ),
                  Text(
                    "\$" + widget.price,
                    style: AppWidget.normaltextstyle(27.0),
                  ),
                  const Divider(
                    thickness: 2.0,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "What this place offers",
                    style: AppWidget.headlinetextstyle(22.0),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  widget.wifi == "true"
                      ? Row(
                          children: [
                            const Icon(
                              Icons.wifi,
                              color: Color.fromARGB(255, 5, 112, 184),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text("WiFi",
                                style: AppWidget.normaltextstyle(23.0)),
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  widget.hdtv == "true"
                      ? Row(
                          children: [
                            const Icon(
                              Icons.tv,
                              color: Color.fromARGB(255, 5, 112, 184),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text("HDTV",
                                style: AppWidget.normaltextstyle(23.0)),
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  widget.kitchen == "true"
                      ? Row(
                          children: [
                            const Icon(
                              Icons.kitchen,
                              color: Color.fromARGB(255, 5, 112, 184),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text("Kitchen",
                                style: AppWidget.normaltextstyle(23.0)),
                          ],
                        )
                      : Container(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  widget.bathroom == "true"
                      ? Row(
                          children: [
                            const Icon(
                              Icons.bathroom,
                              color: Color.fromARGB(255, 5, 112, 184),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Text("Bathroom",
                                style: AppWidget.normaltextstyle(23.0)),
                          ],
                        )
                      : Container(),
                  const Divider(
                    thickness: 2.0,
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    "About this place",
                    style: AppWidget.headlinetextstyle(22.0),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    widget.description,
                    style: AppWidget.normaltextstyle(18.0),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Material(
                    elevation: 3.0,
                    borderRadius: BorderRadius.circular(30.0),
                    child: Container(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 20.0, right: 10.0, bottom: 20.0),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "\$" +
                                finalAmount.toString() +
                                " for " +
                                daysDifference.toString() +
                                " nights",
                            style: AppWidget.headlinetextstyle(22.0),
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          const Divider(
                            thickness: 2.0,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Check-in Date",
                              style: AppWidget.normaltextstyle(22.0),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _selectStartDate(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_month,
                                    color: Colors.white,
                                    size: 25.0,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "${_formatDate(startDate)}",
                                style: AppWidget.normaltextstyle(20.0),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Divider(
                            thickness: 2.0,
                          ),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Check-out Date",
                              style: AppWidget.normaltextstyle(22.0),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  _selectEndDate(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(5.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                  child: const Icon(
                                    Icons.calendar_month,
                                    color: Colors.white,
                                    size: 25.0,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Text(
                                "${_formatDate(endDate)}",
                                style: AppWidget.normaltextstyle(20.0),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Number of Guests",
                            style: AppWidget.normaltextstyle(20.0),
                          ),
                          Container(
                            padding: const EdgeInsets.only(left: 10.0),
                            decoration: BoxDecoration(
                              color: const Color(0xFFececf8),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: TextField(
                              onChanged: (value) {
                                finalAmount = finalAmount! * int.parse(value);
                                setState(() {});
                              },
                              controller: guestscontroller,
                              style: AppWidget.headlinetextstyle(19.0),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "1",
                                hintStyle: TextStyle(
                                    color: Colors.grey, fontSize: 20.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          GestureDetector(
                            onTap: ()async {
                              if(int.parse(wallet!)> finalAmount! ){
                                int updatedamount =
                                    int.parse(wallet!) - finalAmount!;
                                print(updatedamount);
                                await DatabaseMethods().updateWallet(
                                  id!,
                                  updatedamount.toString(),
                                );
                                String bookid= randomAlphaNumeric(10);
                                Map<String, dynamic> addBooking={
                                  "CheckIn":  "${_formatDate(startDate)}".toString(),
                                  "CheckOut": "${_formatDate(endDate)}".toString(),
                                  "Guests": guestscontroller.text,
                                  "HotelName": widget.name,
                                  "Total": finalAmount.toString(),
                                  "Username": username,
                                };
                                await DatabaseMethods().addUserBooking(addBooking, id!, bookid);
                                await DatabaseMethods().addHotelOwnerBooking(addBooking, widget.hotelid,bookid );
                                await SharedpreferenceHelper().saveUserWallet(
                                  updatedamount.toString(),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                      "Hotel Booked Successfully!",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(
                                      "Please Add Money to your Wallet",
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }
                            },

                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                  child: Text(
                                "Book Now",
                                style: AppWidget.whitetextstyle(20.0),
                              ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
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
