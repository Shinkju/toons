import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:toons/screens/login_screen.dart';

class JoinScreen extends StatefulWidget{
  const JoinScreen({super.key});
  
  @override
  State<JoinScreen> createState() => _JoinScreenState();
}

class _JoinScreenState extends State<JoinScreen>{
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMsg = '';
  void _fireAuthSignUp() async{
    if(emailController.text.isEmpty){
      errorMsg = '사용하실 이메일을 입력해주세요';
    }else if(passwordController.text.isEmpty){
      errorMsg = '사용하실 비밀번호를 입력해주세요.';
    }

    if(errorMsg.isNotEmpty){
      Fluttertoast.showToast(
        msg: errorMsg,
        gravity: ToastGravity.TOP, //위치
        backgroundColor: Colors.white,
        textColor: Colors.red,
        fontSize: 20,
        toastLength: Toast.LENGTH_SHORT,  //AOS
        timeInSecForIosWeb: 1,            //IOS
      );
    }else{
      try{
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(), 
          password: passwordController.text.trim()
        );

        Fluttertoast.showToast(msg: "회원가입이 완료되었습니다.");

        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );

      } on FirebaseAuthException catch (e){
        print('Failed with error code: ${e.code}');
        Fluttertoast.showToast(msg: e.message!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 30, 0, 20),
                  child: const Text(
                    "툰s와 함께해요",
                    style: TextStyle(
                      fontSize: 40,
                      fontFamily: 'Lato',
                      color: Colors.green,
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
                  margin: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => _fireAuthSignUp(), //sign up
                    child: const Text("회원가입"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}