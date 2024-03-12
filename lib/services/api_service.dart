import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:toons/models/webtoon_model.dart';

class ApiService{
  //api base url
  static const String baseUrl = "https://webtoon-crawler.nomadcoders.workers.dev";
  static const String today = "today";

  static Future<List<WebtoonModel>> getTodaysToons() async {  //Future: 당장 완료될 수 있는 작업이 아닌 것
    List<WebtoonModel> webtoonInstance = [];
    final url = Uri.parse('$baseUrl/$today');
    final response = await http.get(url); //대기를 위한 비동기

    if(response.statusCode == 200){ //jsonDecode는 dynamic type
      final List<dynamic> webtoons = jsonDecode(response.body);
      for(var webtoon in webtoons){
        webtoonInstance.add(WebtoonModel.fromJson(webtoon));
      }
      return webtoonInstance;
    }
    throw Error();
  }
}