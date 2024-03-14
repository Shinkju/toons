import 'package:flutter/material.dart';
import 'package:toons/models/webtoon_detail_model.dart';
import 'package:toons/models/webtoon_episode_model.dart';
import 'package:toons/services/api_service.dart';

class DetailScreen extends StatefulWidget{
  final String title, thumb, id;

  const DetailScreen({
    super.key,
    required this.title,
    required this.thumb,
    required this.id,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  //호출 api
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;

  //초기화 작업 -> initState()를 사용하지 않으면 비동기 작업 즉, api호출에 대한 async-await에 대한 작업이 불가하다. 오류가 발생할 수 있다.
  @override
  void initState(){ //initState()는 항상 build보다 먼저 호출된다.
    super.initState();
    webtoon = ApiService.getToonById(widget.id);  //statefulWidget을 사용할 때 HomeScreen에서 받아온 데이터는 widget.id 처럼 widget을 붙여 사용할 수 있다.
    episodes = ApiService.getLatestEpisodesById(widget.id);
  }

 @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.white,
        foregroundColor: Colors.green,
        title: Text(
            widget.title,
            style: const TextStyle(
              fontSize: 24,
              fontFamily: 'Lato',
            ),
          ),
      ),
      body: SingleChildScrollView( //over view 처리
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center, //가운데정렬
                children: [
                  Hero(  //Hero로 위젯에서 id를 전달받았음(자연스럽게 전달됨)
                    tag: widget.id,
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
                        widget.thumb,
                        headers: const{
                          'Referer': 'https://comic.naver.com'
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              FutureBuilder(
                  future: webtoon,
                  builder: (context, snapshot){
                    if(snapshot.hasData){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start, //children 요소들을 전부 왼쪽정렬
                        children: [
                          Text(snapshot.data!.about,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 15,),
                          Text('${snapshot.data!.genre} / ${snapshot.data!.age}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      );
                    }
                    return Text("...");
                  },
                ),
              const SizedBox(
                height: 50,
              ),
              FutureBuilder(
                future: episodes,
                builder: (context, snapshot) {
                  if(snapshot.hasData){
                    //최근 10개의 에피소드만 랜더링 할 것.일단은.
                    return Column(
                      children: [
                        for(var episode in snapshot.data!)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green.shade400,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    episode.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right_rounded, 
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}