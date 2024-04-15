import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toons/models/webtoon_detail_model.dart';
import 'package:toons/models/webtoon_episode_model.dart';
import 'package:toons/services/api_service.dart';
import 'package:url_launcher/url_launcher_string.dart';

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
  late Future<WebtoonDetailModel> webtoon;
  late Future<List<WebtoonEpisodeModel>> episodes;
  late SharedPreferences prefs;
  bool isLiked = false;

  Future initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    final likedToons = prefs.getStringList('likedToons');
    if(likedToons != null){
      if(likedToons.contains(widget.id) == true){
        setState(() {
          isLiked = true;
        });
      }
    }else{
      await prefs.setStringList('likedToons', []);
    }
  }

  @override
  void initState(){
    super.initState();
    webtoon = ApiService.getToonById(widget.id);
    episodes = ApiService.getLatestEpisodesById(widget.id);
    initPrefs();
  }

  onHeartTap() async{
    final likedToons = prefs.getStringList('likedToons');
    if(likedToons != null){
      if(isLiked){
        likedToons.remove(widget.id);
      }else{
        likedToons.add(widget.id);
      }
      await prefs.setStringList('likedToons', likedToons);
      setState(() {
        isLiked = !isLiked;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(50),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: widget.id,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                    return Column(
                      children: [
                        for(var episode in snapshot.data!)
                          Episode(
                            episode: episode, 
                            webtoonId: widget.id
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

  Future<void> initPrefs() async{
    prefs = await SharedPreferences.getInstance();
    final clickedEpi = prefs.getStringList('clickedEpi');
    if(clickedEpi != null){
      if(clickedEpi.contains(widget.episode.id) == true){
        setState(() {
          isClicked = true;
        });
      }
    }else{
      await prefs.setStringList('clickedEpi', []);
    }
  }

  //웹 사이트 launcher
  onButtonTap() async {
    final clickedEpi = prefs.getStringList('clickedEpi');
    if(clickedEpi != null){
      clickedEpi.add(widget.episode.id);
      await prefs.setStringList('clickedEpi', clickedEpi);
      setState(() {
        isClicked = isClicked;
      });
    }

    await launchUrlString("https://comic.naver.com/webtoon/detail?titleId=${widget.webtoonId}&no=${widget.episode.id}");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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