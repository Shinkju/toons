import 'package:flutter/material.dart';
import 'package:toons/models/webtoon_model.dart';
import 'package:toons/services/api_service.dart';

class HomeToday extends StatelessWidget{
 // const HomeToday({super.key}); //Future를 사용하면 미리 값을 알고있어야 하는 const사용불가
  HomeToday({super.key});

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
            "툰s",
            style: TextStyle(
              fontSize: 24, 
              fontWeight: FontWeight.w400
            ),
          ),
        ),  
      ),
      body: FutureBuilder( //api를 불러올 때 유용한 비동기식(await, setState, isLoading 할 필요 없음)
        future: webtoons,
        builder: (context, snapshot){ //snapshot을 통해 에러여부를 알 수 있음
          if(snapshot.hasData){
           /* //ListView를 그냥 사용하면 모든 데이터를 한꺼번에 로드함-비효율적 메모리사용 (사용자가보는 섹션만 로딩!)
            return ListView(
              children: [      //`!`는 데이터가 존재한다고 확신한다는 의미로 쓰임
                for(var webtoon in snapshot.data!) Text(webtoon.title)
              ],
            );*/
            return ListView.separated(
              scrollDirection: Axis.horizontal, //필요할 때 만들어짐
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var webtoon = snapshot.data![index];
                return Text(webtoon.title);
              },
              separatorBuilder: (context, index) => const SizedBox(width: 20,), //구분자콤마를 랜딩하지 않고, 콤마를 기준으로 넓이를 넓혀줌
            );
          }
          //data를 아직 못받았을 때 실행
          return const Center(
            child: CircularProgressIndicator(), //로딩서클
          );
        },
      ),
    );
  }
}