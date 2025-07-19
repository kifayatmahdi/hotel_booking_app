import 'package:flutter/material.dart';
import 'package:hotel_booking_app/pages/signUp.dart';

class Onboarding extends StatefulWidget {
  const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  bool owner = true, user = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "images/bg.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 90.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              children: [
                const Text(
                  "Please select your role to get started:",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40.0),
                owner
                    ? Material(
                  elevation: 6.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 2.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff67C0FB),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Image.asset(
                            "images/hotel.png",
                            height: 45,
                            width: 45,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Looking for guests?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 19.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width:
                              MediaQuery.of(context).size.width / 1.8,
                              child: const Text(
                                "Easily find guests for your hotel.",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: () {
                    owner=true;
                    user=false;
                    setState(() {});
                  },
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xff67C0FB),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Image.asset(
                              "images/hotel.png",
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 15.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Looking for guests?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width:
                                MediaQuery.of(context).size.width /
                                    1.8,
                                child: const Text(
                                  "Easily find guests for your hotel.",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40.0),
                user
                    ? Material(
                  elevation: 6.0,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 2.0),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff67C0FB),
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Image.asset(
                            "images/user.png",
                            height: 45,
                            width: 45,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 15.0),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Looking for a hotel?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 19.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            SizedBox(
                              width:
                              MediaQuery.of(context).size.width / 1.8,
                              child: const Text(
                                "Join our platform to find and book the best hotels.",
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
                    : GestureDetector(
                  onTap: (){
                    owner=false;
                    user=true;
                    setState(() {

                    });
                  },
                  child: Material(
                    elevation: 2.0,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color(0xff67C0FB),
                                width: 2.0,
                              ),
                              borderRadius: BorderRadius.circular(60),
                            ),
                            child: Image.asset(
                              "images/user.png",
                              height: 45,
                              width: 45,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 15.0),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Looking for a hotel?",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 19.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(
                                width:
                                MediaQuery.of(context).size.width / 1.8,
                                child: const Text(
                                  "Join our platform to find and book the best hotels.",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=> Signup(redirect: owner?"Owner":"User",)));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 40.0),
                    height: 60,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: const Color(0xff432277),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Center(
                      child: Text(
                        "Next",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
