import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toons/models/webtoon_detail_model.dart';
import 'package:toons/models/webtoon_episode_model.dart';
import 'package:toons/models/webtoon_model.dart';

class ApiService{
  static const String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  /* List */
  static Future<List<WebtoonModel>> getTodaysToons() async {
    List<WebtoonModel> webtoonInstance = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url);

    if(response.statusCode == 200){
      final List<dynamic> webtoons = jsonDecode(response.body);
      for(var webtoon in webtoons){
        webtoonInstance.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstance;
    }
    throw Error();
  }


  /* One */
  static Future<WebtoonDetailModel> getToonById(String id) async{
    final url = Uri.parse("$baseUrl/$id");
    final response = await http.get(url);
    if(response.statusCode == 200){
      final webtoon = jsonDecode(response.body);
      return WebtoonDetailModel.fromJson(webtoon);
    }
    throw Error();
  }


  /* epi */
  static Future<List<WebtoonEpisodeModel>> getLatestEpisodesById(String id) async{
    List<WebtoonEpisodeModel> episodesInstance = [];
    final url = Uri.parse("$baseUrl/$id/episodes");
    final response = await http.get(url);
    if(response.statusCode == 200){
      final episodes = jsonDecode(response.body);
      for(var episode in episodes){
        episodesInstance.add(WebtoonEpisodeModel.fromJson(episode));
      }
      return episodesInstance;
    }
    throw Error();
  }
}