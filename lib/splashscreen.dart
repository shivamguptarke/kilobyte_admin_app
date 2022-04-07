import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 2),() async {
        await checkLogin();
        if(isLoggedIn)
        {
          Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => HomeScreen()));
        }else{
          Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => LoginScreen()));
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("kilobyte", style: TextStyle(fontSize: 50, letterSpacing: 2, fontWeight: FontWeight.w800),),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text("We build products that your customers love.",textAlign: TextAlign.center, style: TextStyle(letterSpacing: 2, fontWeight: FontWeight.w800),),
            ),
            SizedBox(height: 150,),
            CircularProgressIndicator(),            
          ],
        ),
      ),
    );
  }

  checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    //log('preference stored................' + prefs.getBool("LoggedIn").toString());
    if(prefs.containsKey("LoggedIn"))
    {
      isLoggedIn = true;
    }else{
      isLoggedIn = false;
    }
  }
}