import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/pages/bottomnav.dart';
import 'package:hotel_booking_app/pages/signup.dart';

import '../hotelowner/owner_home.dart';
import '../services/database.dart';
import '../services/shared_pref.dart';
import '../services/widget_support.dart';

class LogIn extends StatefulWidget {
  String redirect;
  LogIn({required this.redirect});

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  String email = "", password = "", role = "", name = "", id = "", wallet="";
  TextEditingController passwordcontroller = new TextEditingController();
  TextEditingController mailcontroller = new TextEditingController();

  userLogin() async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email!, password: password!);

      QuerySnapshot querySnapshot = await DatabaseMethods().getUserbyemail(
        email,
      );

      name = "${querySnapshot.docs[0]["Name"]}";
      id = "${querySnapshot.docs[0]["Id"]}";
      role = "${querySnapshot.docs[0]["Role"]}";
      wallet = "${querySnapshot.docs[0]["Wallet"]}";

      await SharedpreferenceHelper().saveUserName(name);
      await SharedpreferenceHelper().saveUserEmail(mailcontroller.text);
      await SharedpreferenceHelper().saveUserId(id);
      await SharedpreferenceHelper().saveUserWallet(wallet);


      role == "Owner"
          ? Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OwnerHome()),
      )
          : Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const BottomNav()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "No user Found for that Email",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
          "Wrong Password Provided by User",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.only(top: 40.0),
          child: Column(
            children: [
              Image.asset(
                "images/login.png",
                width: MediaQuery.of(context).size.width,
                height: 300,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 212, 222, 228),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TextField(
                  controller: mailcontroller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.email, color: Colors.blueGrey),
                    hintText: "Enter Email",
                    hintStyle:
                        TextStyle(color: Colors.blueGrey, fontSize: 18.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 35.0,
              ),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                padding: const EdgeInsets.only(left: 20),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 212, 222, 228),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: TextField(
                  controller: passwordcontroller,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.password, color: Colors.blueGrey),
                    hintText: "Enter Password",
                    hintStyle:
                        TextStyle(color: Colors.blueGrey, fontSize: 18.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 30.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: AppWidget.normaltextstyle(18.0),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30.0,
              ),
              GestureDetector(
                onTap: () {
                  if (mailcontroller.text != "" &&
                      passwordcontroller.text != "") {
                    setState(() {
                      email = mailcontroller.text;
                      password = passwordcontroller.text;
                    });
                    userLogin();
                  }
                },
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width / 3,
                    height: 45,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 228, 65, 89),
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Center(
                        child: Text(
                      "Login",
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
                    "Don't have an account?",
                    style: AppWidget.normaltextstyle(18.0),
                  ),
                  const SizedBox(
                    width: 20.0,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signup(redirect: widget.redirect)));
                      },
                      child: Text(
                        "Sigh Up",
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
