import 'dart:async';

import 'package:diary_app/screens/home_screen.dart';
import 'package:diary_app/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        PageTransition(
          child: BottomNavBar(),
          type: PageTransitionType.fade,
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 45, 45, 45),
      body: Center(
        child: Image.asset("assets/images/splash_screen_animation.gif"),
      ),
    );
  }
}
