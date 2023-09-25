import 'dart:async';

import 'package:car_app/helpers/theme_helper.dart';
import 'package:car_app/screens/LoginScreen.dart';
import 'package:flutter/material.dart';

import 'MainScreen.dart';


class SplashScreen extends StatefulWidget {
  final String? token;
  const SplashScreen({super.key,required this.token});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2),(){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => widget.token == null ? SignInScreen() : MainScreen())
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white60,
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/splash.png'),
            SizedBox(height: 16,),
            Text('En del av Gensolv.no')
          ],
        ),
      ),
    );
  }
}
