import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:toons/screens/home_screen.dart';
import 'package:toons/screens/join_screen.dart';

class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});
  
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMsg = "";
  void _fireAuthSignIn(){
    if(emailController.text.isEmpty){
      errorMsg = "이메일을 입력하세요.";
    }else if(passwordController.text.isEmpty){
      errorMsg = "비밀번호를 입력하세요.";
    }

    if(errorMsg.isNotEmpty){
      Fluttertoast.showToast(
        msg: errorMsg,
        gravity: ToastGravity.TOP, //위치
        backgroundColor: Colors.white,
        textColor: Colors.redAccent,
        fontSize: 20,
        toastLength: Toast.LENGTH_SHORT,  //AOS
        timeInSecForIosWeb: 1,            //IOS
      );
    }else{
      _fireAuthLogin(emailController.text.trim(), passwordController.text.trim());
    }
  }

  void _fireAuthLogin(String email, String password) async{
    if(_formKey.currentState!.validate()){ //키보드숨기기
      FocusScope.of(context).requestFocus(FocusNode());

      //Firebase Auth
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, 
          password: password
        );

        Fluttertoast.showToast(msg: "$email님 환영합니다:)");

        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );

      } on FirebaseAuthException catch (e){
        if(e.code == 'user-not-found'){
          errorMsg = '사용자가 존재하지 않습니다.';
        }else if(e.code == 'wrong-password'){
          errorMsg = '비밀번호가 일치하지 않습니다.';
        }else if(e.code == 'invalid-email'){
          errorMsg = '이메일이 일치하지 않습니다.';
        }

        Fluttertoast.showToast(
          msg: errorMsg,
          gravity: ToastGravity.TOP, //위치
          backgroundColor: Colors.white,
          textColor: Colors.red,
          fontSize: 20,
          toastLength: Toast.LENGTH_SHORT,  //AOS
          timeInSecForIosWeb: 1,            //IOS
        );
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(0, 30, 0, 15),
                child: const Text(
                  "툰s",
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Lato',
                    color: Colors.green,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: const Text(
                  "LOGIN",
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Lato'
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("e-mail"),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(5),
                child: TextField(
                  controller: passwordController,
                  obscureText: true,  //****처리
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), label: Text("password"),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(0, 2, 5, 0),
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => _fireAuthSignIn(), //sign in
                  child: const Text("로그인"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 50.0,),
              GestureDetector(
                child: const Text(
                  "회원가입",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Lato',
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const JoinScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}