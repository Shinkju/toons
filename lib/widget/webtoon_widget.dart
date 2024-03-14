import 'package:flutter/material.dart';
import 'package:toons/screens/detail_screen.dart';

//실제 body에 보여지는 위젯
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
          PageRouteBuilder(
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              //var begin = const Offset(1.0, 0.0); //시작위치 오른쪽
              var begin = const Offset(0.0, 1.0);
              var end = Offset.zero;
              var curve = Curves.ease;
              var tween = Tween(
                begin: begin,
                end: end,
              ).chain(
                CurveTween(curve: curve,),
              );
              return SlideTransition(
                position: animation.drive(tween),
                child: child,
              );
            },
            pageBuilder: (context, animation, secondaryAnimation) => 
              DetailScreen(title: title, thumb: thumb, id: id),   //detail페이지 이동
              fullscreenDialog: true, //새로운페이지가 전체화면 차지
          ),
        );
      } ,
      child: Column(
            children: [
              Hero(  //Hero 애니메이션: 다른화면으로 전활할 때 위젯간의 매끄러운 애니메이션 제공(제공/수신이 모두 같은 태그의 고유값을 받아야함)
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
                  child: Image.network(  //이미지를 넣을때 사용함
                  thumb,
                  headers: const{
                    'Referer': 'https://comic.naver.com'
                  },
                  //1. 웹은 엑박
                  //headers: const {"User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac 0S X 10_15_7) AppleWebkit/537.36 (KHTML, like Gecko) Chrome/110.0.0.0 Safari/537.36",},
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 22,
                  fontFamily: 'Lato',
                ),
              ),
            ],
          ),
    );
  }
}