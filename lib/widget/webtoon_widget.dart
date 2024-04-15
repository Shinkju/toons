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
    return GestureDetector(
      onTap:(){
        Navigator.push(
          context, 
          PageRouteBuilder(
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
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
              DetailScreen(title: title, thumb: thumb, id: id),
              fullscreenDialog: true,
          ),
        );
      } ,
      child: Column(
            children: [
              Hero(
                tag: id,
                child: Container(
                  width: 250,
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
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