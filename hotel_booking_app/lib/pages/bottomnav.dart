import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hotel_booking_app/pages/profile.dart';
import 'package:hotel_booking_app/pages/wallet.dart';

import 'booking.dart';
import 'home.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int currentTabIndex = 0;
  late List<Widget> pages;

  late Widget currentPage;
  late Home home;
  late Booking booking;
  late Profile profile;
  late Wallet wallet;

  @override
  void initState() {
    home = const Home();
    booking = const Booking();
    profile = const Profile();
    wallet = const Wallet();
    pages = [home, booking, wallet, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
          height: 65,
          backgroundColor: Colors.white,
          color: Colors.black,
          animationDuration: const Duration(milliseconds: 500),
          onTap: (int index){
            setState(() {
              currentTabIndex = index;
            });
          },
          items: const [
            Icon(
              Icons.home,
              color: Colors.white,
              size: 30.0,
            ),
            Icon(
              Icons.shopping_bag,
              color: Colors.white,
              size: 30.0,
            ),
            Icon(
              Icons.wallet,
              color: Colors.white,
              size: 30.0,
            ),
            Icon(
              Icons.person,
              color: Colors.white,
              size: 30.0,
            ),
          ]),
      body: pages[currentTabIndex]
    );
  }
}
