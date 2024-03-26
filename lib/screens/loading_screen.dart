import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toons/screens/home_screen.dart';
import 'package:toons/screens/login_screen.dart';

class LoadingScreen extends StatefulWidget{
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends  State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 1500), (){
      checkUserLoggIn();
    });
  }

  void checkUserLoggIn(){
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if(user != null){
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
      }else{
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const String loadingImage = 'assets/images/logo.png';

    //유저 미디어크기
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height; 

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)), 
      child: Scaffold(
        backgroundColor: Colors.green,
        body: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[ //<Widget>[] : 비어있는 위젯리스트를 생성한다는 의미
              SizedBox(
                height: screenHeight * 0.384375,
              ),
              const Expanded(child: SizedBox()), //Expanded: 남은공간 모두 차지
              Align(  //Align: 텍스트 가운데정렬
                child: Text(
                  '툰s',
                  style: TextStyle(
                    fontSize: screenWidth * (14 / 360),
                    color: Colors.black,
                    fontFamily: 'Lato',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}