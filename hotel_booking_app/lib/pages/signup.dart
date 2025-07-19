import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/services/database.dart';
import 'package:hotel_booking_app/services/widget_support.dart';
import 'package:random_string/random_string.dart';

import '../hotelowner/hotel_detail.dart';
import '../services/shared_pref.dart';
import 'bottomnav.dart';
import 'login.dart';

class Signup extends StatefulWidget {
  String redirect;
  Signup({required this.redirect});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool user = false, owner = false;
  String email = "", password = "", name = "";
  TextEditingController namecontroller = new TextEditingController();
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController mailcontroller = new TextEditingController();

  registration() async {
    if (password != null &&
        namecontroller.text != "" &&
        mailcontroller.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        String id = randomAlphaNumeric(10);
        Map<String, dynamic> userInfoMap = {
          "Name": namecontroller.text,
          "Email": mailcontroller.text,
          "Id": id,
          "Role": widget.redirect == "Owner" ? "Owner" : "User",
          "Wallet":"0",
        };
        await SharedpreferenceHelper().saveUserName(namecontroller.text);
        await SharedpreferenceHelper().saveUserEmail(mailcontroller.text);
        await SharedpreferenceHelper().saveUserId(id);
        await DatabaseMethods().addUserInfo(userInfoMap, id);
        await SharedpreferenceHelper().saveUserWallet("0");
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "Registered Successfully!",
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
        ));

        widget.redirect == "Owner"
            ? Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HotelDetail()),
        )
            : Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const BottomNav()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Password Provided is too Weak",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0),
              )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40.0),
          child: Column(
            children: [
              Image.asset(
                "images/signUp.png",
                width: MediaQuery.of(context).size.width,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20,),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 113, 204, 227),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TextField(
                  controller: namecontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.person, color: Colors.black45),
                    hintText: "Enter Name",
                    hintStyle: TextStyle(color: Colors.black45, fontSize: 18.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 113, 204, 227),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TextField(
                  controller: mailcontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.email, color: Colors.black45),
                    hintText: "Enter Email",
                    hintStyle: TextStyle(color: Colors.black45, fontSize: 18.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 113, 204, 227),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TextField(
                  controller: passwordcontroller,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.password, color: Colors.black45),
                    hintText: "Enter Password",
                    hintStyle: TextStyle(color: Colors.black45, fontSize: 18.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                onTap: () {
                  if (namecontroller.text != "" &&
                      mailcontroller.text != "" &&
                      passwordcontroller.text != "") {
                    setState(() {
                      email = mailcontroller.text;
                      password = passwordcontroller.text;
                    });
                  }
                  registration();
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 122, 180, 237),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                        child: Text(
                      "Sign Up",
                      style: AppWidget.whitetextstyle(20.0),
                    )),
                  ),
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account?",
                    style: AppWidget.normaltextstyle(18.0),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LogIn(redirect: widget.redirect),),);
                      },
                      child: Text(
                        "LogIn",
                        style: AppWidget.headlinetextstyle(20.0),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
