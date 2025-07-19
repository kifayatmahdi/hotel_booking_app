import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/services/shared_pref.dart';
import 'package:hotel_booking_app/services/widget_support.dart';
import 'package:intl/intl.dart';

import '../services/database.dart';

class Booking extends StatefulWidget {
  const Booking({super.key});

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  String? id;
  Stream? bookingStream;

  getontheload() async {
    id = await SharedpreferenceHelper().getUserId();
    bookingStream = await DatabaseMethods().getUserbookings(id!);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();
  }

  Widget allUserBooking() {
    return StreamBuilder(
      stream: bookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  final format = DateFormat('dd MMM yyyy');
                  final date = format.parse(ds["CheckIn"]);
                  final now = DateTime.now();

                  return date.isBefore(now) && past
                      ? Container(
                          margin: const EdgeInsets.only(bottom: 15.0),
                          child: Material(
                            elevation: 2.0,
                            borderRadius: BorderRadius.circular(10.0),
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 237, 229, 229),
                                  borderRadius: BorderRadius.circular(10.0)),
                              child: Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(30.0),
                                      child: Image.asset(
                                        "images/hotel1.png",
                                        height: 120,
                                        width: 120,
                                        fit: BoxFit.cover,
                                      )),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.hotel,
                                            color: Colors.blue,
                                            size: 30.0,
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          Text(
                                            ds["HotelName"],
                                            style:
                                                AppWidget.normaltextstyle(19.0),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.calendar_month,
                                            color: Colors.blue,
                                            size: 28.0,
                                          ),
                                          const SizedBox(
                                            width: 8.0,
                                          ),
                                          SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  2.5,
                                              child: Text(
                                                "From "+ds["CheckIn"] +
                                                    "\nTo " +
                                                    ds["CheckOut"],
                                                style:
                                                    AppWidget.normaltextstyle(
                                                        14.0),
                                              ))
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 5.0,
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.group,
                                            color: Colors.blue,
                                            size: 26.0,
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            ds["Guests"],
                                            style: AppWidget.headlinetextstyle(
                                                18.0),
                                          ),
                                          const SizedBox(
                                            width: 15.0,
                                          ),
                                          const Icon(
                                            Icons.monetization_on,
                                            color: Colors.blue,
                                            size: 26.0,
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            "\$" + ds["Total"],
                                            style: AppWidget.headlinetextstyle(
                                                18.0),
                                          )
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : date.isAfter(now) && incoming
                          ? Container(
                              margin: const EdgeInsets.only(bottom: 15.0),
                              child: Material(
                                elevation: 2.0,
                                borderRadius: BorderRadius.circular(10.0),
                                child: Container(
                                  padding: const EdgeInsets.all(10.0),
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      color: const Color.fromARGB(255, 237, 229, 229),
                                      borderRadius:
                                          BorderRadius.circular(10.0)),
                                  child: Row(
                                    children: [
                                      ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          child: Image.asset(
                                            "images/hotel1.png",
                                            height: 120,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          )),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.hotel,
                                                color: Colors.blue,
                                                size: 30.0,
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              Text(
                                                ds["HotelName"],
                                                style:
                                                    AppWidget.normaltextstyle(
                                                        19.0),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_month,
                                                color: Colors.blue,
                                                size: 28.0,
                                              ),
                                              const SizedBox(
                                                width: 8.0,
                                              ),
                                              SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      2.5,
                                                  child: Text(
                                                    "From "+ds["CheckIn"] +
                                                        "\nTo " +
                                                        ds["CheckOut"],
                                                    style: AppWidget
                                                        .normaltextstyle(14.0),
                                                  ))
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5.0,
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.group,
                                                color: Colors.blue,
                                                size: 26.0,
                                              ),
                                              const SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                ds["Guests"],
                                                style:
                                                    AppWidget.headlinetextstyle(
                                                        18.0),
                                              ),
                                              const SizedBox(
                                                width: 15.0,
                                              ),
                                              const Icon(
                                                Icons.monetization_on,
                                                color: Colors.blue,
                                                size: 26.0,
                                              ),
                                              const SizedBox(
                                                width: 5.0,
                                              ),
                                              Text(
                                                "\$" + ds["Total"],
                                                style:
                                                    AppWidget.headlinetextstyle(
                                                        18.0),
                                              )
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container();
                },
              )
            : Container();
      },
    );
  }

  bool incoming = true, past = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "BOOKING",
          style: AppWidget.headlinetextstyle(30.0),
        ),
        centerTitle: true,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          children: [
            Row(
              children: [
                incoming
                    ? Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 180,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 237, 229, 229),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Image.asset("images/incoming.png",
                                  height: 125, width: 120, fit: BoxFit.cover),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Incoming\nBooking",
                                style: AppWidget.headlinetextstyle(24.0),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          incoming = true;
                          past = false;
                          setState(() {});
                        },
                        child: Container(
                          width: 160,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 237, 229, 229),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Image.asset("images/incoming.png",
                                  height: 120, width: 120, fit: BoxFit.cover),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Incoming\nBooking",
                                style: AppWidget.normaltextstyle(25.0),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
                const SizedBox(
                  width: 30.0,
                ),
                past
                    ? Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          width: 180,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 237, 229, 229),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Image.asset("images/past.png",
                                  height: 125, width: 120, fit: BoxFit.cover),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Past\nBooking",
                                style: AppWidget.headlinetextstyle(24.0),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          past = true;
                          incoming = false;
                          setState(() {});
                        },
                        child: Container(
                          width: 160,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 237, 229, 229),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            children: [
                              Image.asset("images/past.png",
                                  height: 120, width: 120, fit: BoxFit.cover),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Text(
                                "Past\nBooking",
                                style: AppWidget.normaltextstyle(25.0),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ),
              ],
            ),
            const SizedBox(
              height: 30.0,
            ),
            SizedBox(
                height: MediaQuery.of(context).size.height / 2,
                child: allUserBooking())
          ],
        ),
      ),
    );
  }
}
