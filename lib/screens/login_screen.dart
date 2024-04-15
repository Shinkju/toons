import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  bool isLoading = false;
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
        gravity: ToastGravity.TOP,
        backgroundColor: Colors.white,
        textColor: Colors.redAccent,
        fontSize: 20,
        toastLength: Toast.LENGTH_SHORT,  //aos
        timeInSecForIosWeb: 1,            //ios
      );
    }else{
      _fireAuthLogin(emailController.text.trim(), passwordController.text.trim());
    }
  }

  void _fireAuthLogin(String email, String password) async{
    if(_formKey.currentState!.validate()){
      FocusScope.of(context).requestFocus(FocusNode());
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, 
          password: password
        ).then((Value){
          setState(() {
            isLoading = false;
            //_showResisterDialog();
            Navigator.pushReplacement(
              context, 
              MaterialPageRoute(builder: (context) => HomeScreen()),
            );
          });
        });
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
          gravity: ToastGravity.TOP,
          backgroundColor: Colors.white,
          textColor: Colors.red,
          fontSize: 20,
          toastLength: Toast.LENGTH_SHORT,  //aos
          timeInSecForIosWeb: 1,            //ios
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
      body: SingleChildScrollView(
        child: Form(
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
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: isLoading ? null : _fireAuthSignIn,  //sign in
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ), 
                      child: const Text("로그인"),
                    ),
                    if(isLoading)
                      const Positioned(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                  ],
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
      ),
    );
  }
}