import 'dart:async';

import 'package:flutter/material.dart';
import 'package:INVENTORY/Screens/HomePage.dart';
import 'package:INVENTORY/Screens/LoginView.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ViewModel/CustomerVIewModel.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      checkLoginStatus();
    });
  }

  void checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');
    if (userId != null) {
      // User ID exists, navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeView()),
      );
    } else {
      // No user ID, navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginView()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.25,
            ),
            Center(
              child: Text(
                'Invoicely',
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: MediaQuery.sizeOf(context).width * 0.07),
              ),
            ),
            SizedBox(
              height: height * 0.1,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Designed By ',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500),
                ),
                Image(
                  height: MediaQuery.sizeOf(context).width * 0.08,
                  image: const AssetImage('images/logo.png'),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width * 0.01,
                ),
                const Text(
                  'ATIF IY',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 19,
                      fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              height: height * 0.01,
            ),
            const Text(
              'http://atifiy.com',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 19,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: height * 0.1,
            ),
          ],
        ),
      ),
    );
  }
}
