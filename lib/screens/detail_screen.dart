import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toons/models/webtoon_detail_model.dart';
import 'package:toons/models/webtoon_episode_model.dart';
import 'package:toons/services/api_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

/* shared_preferences : 핸드폰 저장소에 데이터를 담을 때 사용하는 라이브러리 ex) 좋아요 등 */

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
  late SharedPreferences prefs;
  bool isLiked = false;

  //좋아요클릭 저장소 관리
  Future initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if(likedToons != null){
      //사용자가 이전에 좋아요를 누른 적이 있다면
      if(likedToons.contains(widget.id) == true){
        setState(() {
          isLiked = true;
        });
      }
    }else{
      //사용자가 처음앱을 실행할 때 likedToons를 생성
      await prefs.setStringList('likedToons', []);
    }
  }

  //초기화 작업 -> initState()를 사용하지 않으면 비동기 작업 즉, api호출에 대한 async-await에 대한 작업이 불가하다. 오류가 발생할 수 있다.
  @override
  void initState(){ //initState()는 항상 build보다 먼저 호출된다.
    super.initState();
    webtoon = ApiService.getToonById(widget.id);  //statefulWidget을 사용할 때 HomeScreen에서 받아온 데이터는 widget.id 처럼 widget을 붙여 사용할 수 있다.
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  //좋아요 버튼
  onHeartTap() async{
    final likedToons = prefs.getStringList('likedToons');
    if(likedToons != null){
      //이미 likedToons에 value가 존재한다면 삭제 (좋아요 취소)
      if(isLiked){
        likedToons.remove(widget.id);
      }else{
        //아니라면 추가 (좋아요)
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked; //상태에는 반대값 부여
      });
    }
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
        actions: [
          IconButton(
            onPressed: onHeartTap, 
            icon: Icon(
              isLiked ? Icons.favorite_rounded : Icons.favorite_outline_outlined
            ),
          ),
        ],
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
                    return const Text("...");
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
                          Episode(
                            episode: episode, 
                            webtoonId: widget.id
                          ), //에피소드 노출 위젯 메소드호출
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


/* EPISODE */
class Episode extends StatefulWidget {
  const Episode({
    super.key,
    required this.episode,
    required this.webtoonId,
  });

  final String webtoonId;
  final WebtoonEpisodeModel episode;

  @override
  State<Episode> createState() => _EpisodeState();
}

class _EpisodeState extends State<Episode> {
  late SharedPreferences prefs;
  bool isClicked = false;

  //prefs받아오기
  @override
  void initState(){
    super.initState();
    initPrefs();
  }
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
  }

  //에피소드클릭 저장소 관리
  Future<void> initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    final clickedEpi = prefs.getStringList('clickedEpi');
    if(clickedEpi != null){
      //사용자가 이전에 에피소드를 봤다면
      if(clickedEpi.contains(widget.episode.id) == true){
        setState(() {
          isClicked = true;
        });
      }
    }else{
      //사용자가 처음앱을 실행할 때 clickedEpi 생성
      await prefs.setStringList('clickedEpi', []);
    }
  }

  //웹 사이트로 이동하는 launcher
  onButtonTap() async {
    //클릭 시 상태변화
    final clickedEpi = prefs.getStringList('clickedEpi');
    if(clickedEpi != null){
      clickedEpi.add(widget.episode.id);
      await prefs.setStringList('clickedEpi', clickedEpi);
      setState(() {
        isClicked = isClicked;
      });
    }

    //launchUrl: Future를 가져다 주는 function이기 때문에 async-await 필수
    await launchUrlString("https://comic.naver.com/webtoon/detail?titleId=${widget.webtoonId}&no=${widget.episode.id}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( //GestureDetector: 사용자의 제스처 이벤트 감지 위젯
      onTap: onButtonTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: isClicked ? Colors.lightGreen.shade100.withOpacity(1.0) : Colors.green.shade400,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.episode.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
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
    );
  }
}