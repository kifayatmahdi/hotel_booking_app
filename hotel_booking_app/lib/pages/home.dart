import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hotel_booking_app/pages/detail_page.dart';
import 'package:hotel_booking_app/services/database.dart';
import 'package:hotel_booking_app/services/widget_support.dart';

import '../services/shared_pref.dart';
import 'city_hotel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream? hotelStream;
  String? address, name;

  getontheload() async {
    name = await SharedpreferenceHelper().getUserName();
    hotelStream = await DatabaseMethods().getallHotels();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getontheload();

    getCityCounts();
    _getLocationAndAddress();
  }

  bool search = false;
  var queryResultSet = [];
  var tempSearchStore = [];
  TextEditingController searchcontroller = new TextEditingController();

  initiateSearch(value) {
    if (value.length == 0) {
      setState(() {
        queryResultSet = [];
        tempSearchStore = [];
      });
    }
    setState(() {
      search = true;
    });

    var CapitalizedValue =
        value.substring(0, 1).toUpperCase() + value.substring(1);
    if (queryResultSet.isEmpty && value.length == 1) {
      DatabaseMethods().search(value).then((QuerySnapshot docs) {
        for (int i = 0; i < docs.docs.length; ++i) {
          queryResultSet.add(docs.docs[i].data());
        }
      });
    } else {
      tempSearchStore = [];
      queryResultSet.forEach((element) {
        if (element['UpdatedName'].startsWith(CapitalizedValue)) {
          setState(() {
            tempSearchStore.add(element);
          });
        }
      });
    }
  }

  int? dhakacount, chittagongcount, rajshahicount, sylhetcount;

  Future<Position> _getCurrentPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // Check for permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Future<String> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark place = placemarks[0];

      return '${place.locality}, ${place.country}';
    } catch (e) {
      return 'Error: $e';
    }
  }

  void _getLocationAndAddress() async {
    Position position = await _getCurrentPosition();
    address = await _getAddressFromLatLng(position);

    print('Address: $address');
  }

  Future<void> getCityCounts() async {
    final firestore = FirebaseFirestore.instance;

    // Count documents where city == 'Dhaka'
    final dhakaQuerySnapshot = await firestore
        .collection('Hotel')
        .where('HotelCity', isEqualTo: 'dhaka')
        .get();
    dhakacount = dhakaQuerySnapshot.docs.length;

    // Count documents where city == 'Chittagong'
    final chittagongQuerySnapshot = await firestore
        .collection('Hotel')
        .where('HotelCity', isEqualTo: 'chittagong')
        .get();
    chittagongcount = chittagongQuerySnapshot.docs.length;

    // Count documents where city == 'Rajshahi'
    final rajshahiQuerySnapshot = await firestore
        .collection('Hotel')
        .where('HotelCity', isEqualTo: 'rajshahi')
        .get();
    rajshahicount = rajshahiQuerySnapshot.docs.length;

    // Count documents where city == 'Sylhet'
    final sylhetQuerySnapshot = await firestore
        .collection('Hotel')
        .where('HotelCity', isEqualTo: 'sylhet')
        .get();
    sylhetcount = sylhetQuerySnapshot.docs.length;

    setState(() {});
  }

  Widget allHotels() {
    return StreamBuilder(
      stream: hotelStream,
      builder: (context, AsyncSnapshot snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DetailPage(
                                    bathroom: ds["Bathroom"],
                                    description: ds["HotelDescription"],
                                    hdtv: ds["HDTV"],
                                    kitchen: ds["Kitchen"],
                                    name: ds["HotelName"],
                                    price: ds["HotelCharges"],
                                    wifi: ds["WiFi"],
                                    hotelid: ds.id,
                                  )));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0, bottom: 5.0, right: 10.0),
                      child: Material(
                        elevation: 2.0,
                        borderRadius: BorderRadius.circular(30),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30.0),
                                child: Image.asset(
                                  ds["Image"],
                                  width:
                                      MediaQuery.of(context).size.width / 1.2,
                                  fit: BoxFit.cover,
                                  height: 220,
                                ),
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, top: 5.0),
                                child: Row(
                                  children: [
                                    Text(
                                      ds["HotelName"],
                                      style: AppWidget.headlinetextstyle(20.0),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          3.5,
                                    ),
                                    Text(
                                      "\$" + ds["HotelCharges"],
                                      style: AppWidget.headlinetextstyle(25.0),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 5.0,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10.0),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.blue,
                                      size: 30.0,
                                    ),
                                    const SizedBox(
                                      width: 2.0,
                                    ),
                                    Text(
                                      ds["HotelAddress"],
                                      style: AppWidget.normaltextstyle(16.0),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              )
            : Container();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(229, 246, 242, 242),
      body: address == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                          child: Image.asset(
                            "images/home.png",
                            width: MediaQuery.of(context).size.width,
                            height: 280,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 30.0, left: 20.0),
                          width: MediaQuery.of(context).size.width,
                          height: 280,
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(97, 0, 0, 0),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(40),
                                bottomRight: Radius.circular(40),
                              )),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.location_on, color: Colors.white),
                                  const SizedBox(
                                    width: 10.0,
                                  ),
                                  Text(
                                    address!,
                                    style: AppWidget.whitetextstyle(20.0),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 30.0,
                              ),
                              Text(
                                "Hey, " +
                                    name! +
                                    "! " +
                                    "Tell us where you want to go",
                                style: AppWidget.whitetextstyle(24.0),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                margin: const EdgeInsets.only(right: 20.0),
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                                decoration: BoxDecoration(
                                    color: const Color.fromARGB(103, 255, 255, 255),
                                    borderRadius: BorderRadius.circular(30.0)),
                                child: TextField(
                                  controller: searchcontroller,
                                  onChanged: (value) {
                                    initiateSearch(value.toUpperCase());
                                  },
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    prefixIcon: search
                                        ? GestureDetector(
                                            onTap: () {
                                              searchcontroller.text = "";
                                              search = false;
                                              setState(() {});
                                            },
                                            child: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ))
                                        : const Icon(
                                            Icons.search,
                                            color: Colors.white,
                                          ),
                                    hintText: "Search Places...",
                                    hintStyle: AppWidget.whitetextstyle(20.0),
                                  ),
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    search
                        ? ListView(
                            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                            primary: false,
                            shrinkWrap: true,
                            children: tempSearchStore.map((element) {
                              return buildResultCard(element);
                            }).toList())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "The most relevant",
                                  style: AppWidget.headlinetextstyle(22.0),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              SizedBox(height: 330, child: allHotels()),
                              const SizedBox(height: 20.0),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(
                                  "Discover new places",
                                  style: AppWidget.headlinetextstyle(22.0),
                                ),
                              ),
                              const SizedBox(height: 20.0),
                              Container(
                                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                                height: 280,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CityHotel(city: "Dhaka"),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 5.0),
                                        child: Material(
                                          elevation: 2.0,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: Image.asset(
                                                    "images/dhaka.png",
                                                    height: 200,
                                                    width: 180,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(height: 10.0),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: Text(
                                                    "Dhaka",
                                                    style: AppWidget
                                                        .headlinetextstyle(
                                                            20.0),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.hotel,
                                                          color: Colors.blue),
                                                      const SizedBox(width: 5.0),
                                                      Text(
                                                        dhakacount.toString() +
                                                            " Hotels",
                                                        style: AppWidget
                                                            .normaltextstyle(
                                                                18.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CityHotel(city: "Chittagong"),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 20.0, bottom: 5.0),
                                        child: Material(
                                          elevation: 2.0,
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(30),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(30),
                                                  child: Image.asset(
                                                    "images/chittagong.png",
                                                    height: 200,
                                                    width: 180,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(height: 10.0),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 20.0),
                                                  child: Text(
                                                    "Chittagong",
                                                    style: AppWidget
                                                        .headlinetextstyle(
                                                        20.0),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 20.0),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.hotel,
                                                          color: Colors.blue),
                                                      const SizedBox(width: 5.0),
                                                      Text(
                                                        chittagongcount.toString() +
                                                            " Hotels",
                                                        style: AppWidget
                                                            .normaltextstyle(
                                                            18.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CityHotel(city: "Rajshahi"),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 20.0, bottom: 5.0),
                                        child: Material(
                                          elevation: 2.0,
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  child: Image.asset(
                                                    "images/rajshahi.png",
                                                    height: 200,
                                                    width: 180,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(height: 10.0),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: Text(
                                                    "Rajshahi",
                                                    style: AppWidget
                                                        .headlinetextstyle(
                                                            20.0),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 20.0),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.hotel,
                                                          color: Colors.blue),
                                                      const SizedBox(width: 5.0),
                                                      Text(
                                                        rajshahicount
                                                                .toString() +
                                                            " Hotels",
                                                        style: AppWidget
                                                            .normaltextstyle(
                                                                18.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CityHotel(city: "Sylhet"),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 20.0, bottom: 5.0),
                                        child: Material(
                                          elevation: 2.0,
                                          borderRadius:
                                          BorderRadius.circular(30),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                              BorderRadius.circular(30),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(30),
                                                  child: Image.asset(
                                                    "images/sylhet.png",
                                                    height: 200,
                                                    width: 180,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                const SizedBox(height: 10.0),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 20.0),
                                                  child: Text(
                                                    "Sylhet",
                                                    style: AppWidget
                                                        .headlinetextstyle(
                                                        20.0),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  const EdgeInsets.only(
                                                      left: 20.0),
                                                  child: Row(
                                                    children: [
                                                      const Icon(Icons.hotel,
                                                          color: Colors.blue),
                                                      const SizedBox(width: 5.0),
                                                      Text(
                                                        sylhetcount
                                                            .toString() +
                                                            " Hotels",
                                                        style: AppWidget
                                                            .normaltextstyle(
                                                            18.0),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 50.0),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget buildResultCard(data) {
    return GestureDetector(
      onTap: () {},
      child: Container(
        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Material(
          elevation: 3.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.only(left: 20.0),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            height: 100,
            child: Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      "images/hotel1.png",
                      height: 70,
                      width: 70,
                      fit: BoxFit.cover,
                    )),
                const SizedBox(
                  width: 20.0,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data["HotelName"],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 22.0,
                          fontFamily: 'Poppins'),
                    ),
                    Text(
                      "\$" + data["HotelCharges"],
                      style: const TextStyle(
                          color: Colors.black54,
                          fontSize: 22.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailPage(
                          bathroom: data["Bathroom"],
                          description: data["HotelDescription"],
                          hdtv: data["HDTV"],
                          kitchen: data["Kitchen"],
                          name: data["HotelName"],
                          price: data["HotelCharges"],
                          wifi: data["WiFi"],
                          hotelid: data["Id"],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 20.0),
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: const Color(0xff0000ff),
                        borderRadius: BorderRadius.circular(60)),
                    child: const Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 30.0,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
