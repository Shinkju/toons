import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:toons/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:toons/screens/home_screen.dart';
import 'package:toons/screens/login_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //웹앱 scroll -> 화면 오버플로우방지
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      home: const Root(),
    );
  }
}


class Root extends StatelessWidget{
  const Root({super.key});
  
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),   //stream에 authStateChanges등록
        builder: (context, snapshot){ //사용자의 상태변경(로그인/아웃 등)
          if(!snapshot.hasData){
            return const LoginScreen();
          }else{
            return HomeScreen();
          }
        }
      ),
    );
  }
}

