import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/textstyles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      context.pushReplacement('/home');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: Container(),
              ),
              SizedBox(child: Text('squeaky', style: w400.size24.colorWhite)),
              const Spacer(),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(),
              ),
              SizedBox(
                  child: Text('badmeister', style: w400.size24.colorWhite)),
              Expanded(
                child: Container(),
              ),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
