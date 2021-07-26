import 'package:flutter/material.dart';
import 'package:hive_todo_app/views/home_page.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({ Key? key }) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(context, PageTransition(
        child: HomePage(),
        type: PageTransitionType.fade,
        duration: Duration(milliseconds: 400)
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff151d27),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/note-animation.json',
                frameRate: FrameRate(60),
                repeat: false                
              ),
              Text('Hive Todo App!', style: TextStyle(
                fontSize: 48,
                fontFamily: 'RobotoSlab',
                color: Colors.white,
                fontWeight: FontWeight.bold          
              ),)
            ],
          ),
        ),
      )
    );
  }
}