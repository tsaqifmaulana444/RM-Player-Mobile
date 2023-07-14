import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rm_crud/templates/home.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _opacity = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.forward();

    return Scaffold(
        body: Center(
            child: AnimatedBuilder(
                animation: _opacity,
                builder: (BuildContext context, Widget? child) {
                  return Opacity(
                    opacity: _opacity.value,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 2000),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 30),
                        width: 230,
                        height: 230,
                        child: Image.network(
                            "https://upload.wikimedia.org/wikipedia/en/thumb/5/56/Real_Madrid_CF.svg/1200px-Real_Madrid_CF.svg.png"),
                      ),
                    ),
                  );
                })),
        bottomNavigationBar: AnimatedBuilder(
            animation: _opacity,
            builder: (BuildContext context, Widget? child) {
              return Opacity(
                opacity: _opacity.value,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 1100),
                  child: Container(
                      margin: const EdgeInsets.only(bottom: 30),
                      height: 50,
                      child: const Center(
                          child: Text(
                        "Real Madrid Players",
                        style: TextStyle(fontSize: 26),
                      ))),
                ),
              );
            }));
  }
}
