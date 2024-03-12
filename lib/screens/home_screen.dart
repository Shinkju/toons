import 'package:flutter/material.dart';
import 'package:toons/models/webtoon_model.dart';
import 'package:toons/services/api_service.dart';
import 'package:toons/widget/webtoon_widget.dart';

class HomeScreen extends StatelessWidget{
 // const HomeToday({super.key}); //Future를 사용하면 미리 값을 알고있어야 하는 const사용불가
  HomeScreen({super.key});

  final Future<List<WebtoonModel>> webtoons = ApiService.getTodaysToons();
 
  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 2, //하단 음영
        backgroundColor: Colors.white,
        foregroundColor: Colors.green, //font color
        title: const Center(
          child: Text(
            "오늘의 툰s",
            style: TextStyle(
              fontSize: 24,
              fontFamily: 'Lato Bold',
            ),
          ),
        ),  
      ),
      body: FutureBuilder(
        future: webtoons,
        builder: (context, snapshot){ //snapshot을 통해 에러여부 확인
          if(snapshot.hasData){
            return Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                Expanded(child: makeList(snapshot)) //Expanded: 위젯크기에 맞게 자식분배
              ],
            );
          }
          return const Center(
            child: CircularProgressIndicator(), //data를 아직 못받았을때
          );
        },
      ),
    );
  }

  ListView makeList(AsyncSnapshot<List<WebtoonModel>> snapshot) {
     return ListView.separated(
      scrollDirection: Axis.horizontal, //필요할 때 만들어짐
      itemCount: snapshot.data!.length,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),  //옆스크롤시 벽에붙음방지
      itemBuilder: (context, index) {
        var webtoon = snapshot.data![index];
        return Webtoon(title: webtoon.title, thumb: webtoon.thumb, id: webtoon.id);
      },
      separatorBuilder: (context, index) => const SizedBox(width: 20,), //구분자
    );
  }
}