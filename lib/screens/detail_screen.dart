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
              fontFamily: 'Lato',
            ),
          ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center, //가운데정렬
            children: [
              Hero(  //Hero로 위젯에서 id를 전달받았음(자연스럽게 전달됨)
                tag: id,
                child: Container(
                  width: 250,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(  //border설정만 하면 clipBehavior때문에 적용안됨 (clipBehavior: 자식의 부모영역 침범을 제어)
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [ //border의 쉐도우 처리
                      BoxShadow(
                        blurRadius: 15,
                        offset: const Offset(10, 15),
                        color: Colors.black.withOpacity(0.5),
                      )
                    ]
                  ),
                  child: Image.network(
                    thumb,
                    headers: const{
                      'Referer': 'https://comic.naver.com'
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}