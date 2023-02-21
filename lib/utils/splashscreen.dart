import 'dart:async';

import 'package:flutter/material.dart';
import 'package:merchandising/login_page.dart';



class SplashScreen extends StatefulWidget {
  SplashScreen();

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  loadValues()
  {
    Timer(Duration(seconds: 5),
            () =>
            Navigator.of(context).pushReplacementNamed(LoginPage.routeName)

    );
  }

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadValues();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).viewPadding.top;
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        margin: const EdgeInsets.only(left: 0,right: 0),
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/RMS_Splash.png"),
                    fit: BoxFit.contain,
                  )
              ),
      ),
    );
  }
}
