import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/hotelowner/hotel_detail.dart';
import 'package:hotel_booking_app/services/widget_support.dart';
import 'package:intl/intl.dart';

import '../services/database.dart';
import '../services/shared_pref.dart';

class OwnerHome extends StatefulWidget {
  const OwnerHome({super.key});

  @override
  State<OwnerHome> createState() => _OwnerHomeState();
}

class _OwnerHomeState extends State<OwnerHome> {
  String? id, name;
  getonthesharedpref() async{
    id = await SharedpreferenceHelper().getUserId();
    name = await SharedpreferenceHelper().getUserName();
    bookingStream = await DatabaseMethods().getAdminbookings(id!);
    print("Booking stream assigned for userId: $id");
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getonthesharedpref();
  }

  Stream? bookingStream;

  Widget allAdminBooking() {
    return StreamBuilder(
      stream: bookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            final format = DateFormat('dd MMM yyyy');
            final date = format.parse(ds["CheckIn"]);
            final now = DateTime.now();

            return date.isAfter(now) ? Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
              child: Material(
                elevation: 2.0,
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  //width: MediaQuery.of(context).size.width,
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
                                Icons.person,
                                color: Colors.blue,
                                //size: 30.0,
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                ds["Username"],
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
            ) : Container();
          },
        ) : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: name==null? const Center(child: CircularProgressIndicator()): Container(
        child: Stack(
          children: [
            Container(
              child: Image.asset(
                "images/home.png",
                width: MediaQuery.of(context).size.width,
                height: 280,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: 280,
              decoration: const BoxDecoration(
                color: Color.fromARGB(83, 0, 0, 0),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40.0, left: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        "images/waving.png",
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        "Hello, "+name!,
                        style: AppWidget.boldwhitetextstyle(22.0),
                      )
                    ],
                  ),
                  Text(
                    "ready to welcome\nyour next guest?",
                    style: AppWidget.whitetextstyle(24.0),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 3.4,
              ),
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Color(0xFFececf8),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 20.0),
                  Container(
                      height: MediaQuery.of(context).size.height/1.87,
                      child: allAdminBooking()),
                  SizedBox(height: 20.0,),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                          MaterialPageRoute(builder: (context) => const HotelDetail(),),);
                      },
                      child: Container(
                        width: 280.0,
                        height: 65.0,
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Center(
                          child: Text(
                            "Update Information",
                            style: AppWidget.whitetextstyle(22.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
