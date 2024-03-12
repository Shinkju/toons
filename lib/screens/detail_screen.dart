import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget{
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

 @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Lato Bold',
            ),
          ),
      ),
    );
  }
}