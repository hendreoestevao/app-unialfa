import 'package:app_unialfa/screens/auth/login_screen.dart';
import 'package:app_unialfa/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

late Size mq;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: mq.height * .15,
              right: mq.width * .25,
              width: mq.width * .5,
              child: Image.asset('images/icons.png')),
          Positioned(
              bottom: mq.height * .15,
              left: mq.width * .1,
              width: mq.width * .8,
              height: mq.height * .07,
              child: Text(
                'UniAlfa',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                ),
              )),
        ],
      ),
    );
  }
}
