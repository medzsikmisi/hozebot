import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';

class GifManager {
  String? searchTerm;
  bool? trending;

  GifManager.search(this.searchTerm) : trending = false;

  GifManager.trending()
      : trending = true,
        searchTerm = null;

  Future<String> getGif() async {
    final apikey = getAPIKey();
    final url = 'https://api.giphy.com/v1/gifs/search';
    final response = await Dio().get(url,
        queryParameters: {'api_key': apikey, 'q': searchTerm, 'limit': 50});
    final data = response.data['data'];
    final randomIndex = Random().nextInt(data.length);
    final randomGif = data[randomIndex];
    final randomGifUrl = randomGif["images"]["original"]["url"];
    return randomGifUrl;
  }

  String getAPIKey() {
    return Platform.environment['GIPHY']!;
  }
}
