import 'package:flutter/material.dart';
import 'package:toons/screens/detail_screen.dart';

class Webtoon extends StatelessWidget{
  final String title, thumb, id;

  const Webtoon({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  Widget build(BuildContext context){
    return GestureDetector(  //GestureDetector: 동작감지
      onTap:(){ //클릭이벤트
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => 
                DetailScreen(title: title, thumb: thumb, id: id,),
          ),
        );
      } ,
      child: Column(
            children: [
              Container(
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
                child: Image.network(  //이미지를 넣을때 사용함
                thumb,
                headers: const{
                  'Referer': 'https://comic.naver.com'
                },
                //headers: const {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac 0S X 10_15_7) AppleWebkit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",},
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 22,),
              ),
            ],
          ),
    );
  }
}