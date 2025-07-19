import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/hotelowner/owner_home.dart';
import 'package:hotel_booking_app/services/database.dart';
import 'package:hotel_booking_app/services/widget_support.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

import '../services/shared_pref.dart';

class HotelDetail extends StatefulWidget {
  const HotelDetail({super.key});

  @override
  State<HotelDetail> createState() => _HotelDetailState();
}

class _HotelDetailState extends State<HotelDetail> {
  bool isChecked = false,
      isChecked1 = false,
      isChecked2 = false,
      isChecked3 = false;

  String? id;

  getonthesharedpref() async {
    id = await SharedpreferenceHelper().getUserId();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getonthesharedpref();
  }

  File? selectedImage;
  final ImagePicker _picker = ImagePicker();

  TextEditingController hotelnamecontroller = new TextEditingController();
  TextEditingController hotelchargescontroller = new TextEditingController();
  TextEditingController hoteladdresscontroller = new TextEditingController();
  TextEditingController hoteldescriptioncontroller = new TextEditingController();
  TextEditingController hotelcitycontroller = new TextEditingController();

  Future getImage() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    selectedImage = File(image!.path);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Container(
        margin: const EdgeInsets.only(top: 40.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hotel Details",
                  style: AppWidget.boldwhitetextstyle(26.0),
                )
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(left: 20.0, right: 20.0),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30))),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20.0,
                      ),
                      selectedImage != null
                          ? Center(
                            child: SizedBox(
                                height: 200,
                                width: 200,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20.0),
                                  child: Image.file(
                                    selectedImage!,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                          )
                          : GestureDetector(
                              onTap: () {
                                getImage();
                              },
                              child: Center(
                                child: Container(
                                  height: 200,
                                  width: 200,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20.0),
                                      border: Border.all(
                                          width: 2.0, color: Colors.black45)),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.blue,
                                    size: 35.0,
                                  ),
                                ),
                              ),
                            ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Hotel Name",
                        style: AppWidget.normaltextstyle(20.0),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: TextField(
                          controller: hotelnamecontroller,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Hotel Name",
                              hintStyle: TextStyle(fontSize: 18.0)),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Hotel Room Charges",
                        style: AppWidget.normaltextstyle(20.0),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: TextField(
                          controller: hotelchargescontroller,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Room Charges",
                              hintStyle: TextStyle(fontSize: 18.0)),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Hotel Address",
                        style: AppWidget.normaltextstyle(20.0),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: TextField(
                          controller: hoteladdresscontroller,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter Hotel Address",
                              hintStyle: TextStyle(fontSize: 18.0)),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text("City", style: AppWidget.normaltextstyle(20.0)),
                      const SizedBox(height: 5.0),
                      Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFececf8),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextField(
                          controller: hotelcitycontroller,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "Enter City",
                            hintStyle: AppWidget.normaltextstyle(18.0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        "What service you want to offer?",
                        style: AppWidget.normaltextstyle(22.0),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                              value: isChecked,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked = value!;
                                });
                              }),
                          const Icon(
                            Icons.wifi,
                            color: Color.fromARGB(255, 5, 112, 184),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text("WiFi", style: AppWidget.normaltextstyle(23.0)),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                              value: isChecked1,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked1 = value!;
                                });
                              }),
                          const Icon(
                            Icons.tv,
                            color: Color.fromARGB(255, 5, 112, 184),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Text("HDTV", style: AppWidget.normaltextstyle(23.0)),
                        ],
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                              value: isChecked2,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked2 = value!;
                                });
                              }),
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
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                              value: isChecked3,
                              onChanged: (bool? value) {
                                setState(() {
                                  isChecked3 = value!;
                                });
                              }),
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
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Text(
                        "Hotel Description",
                        style: AppWidget.normaltextstyle(20.0),
                      ),
                      const SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 20.0),
                        decoration: BoxDecoration(
                            color: const Color(0xFFececf8),
                            borderRadius: BorderRadius.circular(15.0)),
                        child: TextField(
                          controller: hoteldescriptioncontroller,
                          maxLines: 6,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Enter About Hotel",
                              hintStyle: TextStyle(fontSize: 18.0)),
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      GestureDetector(
                        onTap: () async {

                          // Reference firebaseStorageRef= FirebaseStorage.instance.ref().child("blogImage").child(addId);
                          // final UploadTask task= firebaseStorageRef.putFile(selectedImage!);
                          // var downloadUrl= await(await task).ref.getDownloadURL();

                          String firstletter =
                          hotelnamecontroller.text
                              .substring(0, 1)
                              .toUpperCase();

                          Map<String, dynamic> addHotel = {
                            "Image": "",
                            "HotelName": hotelnamecontroller.text,
                            "HotelCharges": hotelchargescontroller.text,
                            "HotelCity": hotelcitycontroller.text.toLowerCase(),
                            "HotelAddress": hoteladdresscontroller.text,
                            "UpdatedName":
                            hotelnamecontroller.text.toUpperCase(),
                            "SearchKey": firstletter.toUpperCase(),
                            "HotelDescription": hoteldescriptioncontroller.text,
                            "WiFi": isChecked ? "true" : "false",
                            "HDTV": isChecked1 ? "true" : "false",
                            "Kitchen": isChecked2 ? "true" : "false",
                            "Bathroom": isChecked3 ? "true" : "false",
                            "Id": id,
                          };

                          await DatabaseMethods().addHotel(addHotel, id!);

                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text(
                              "Hotel Details has been Uploaded Successfully!",
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                          ));
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const OwnerHome()));
                        },
                        child: Center(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10.0)),
                            width: MediaQuery.of(context).size.width / 2,
                            height: 50.0,
                            child: Center(
                              child: Text(
                                "Submit",
                                style: AppWidget.boldwhitetextstyle(26.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
