import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:flutter_movie_app/model/movie_model.dart';

class ApiProvider{
  Client client = Client();

  Future<MovieResponse1> fetchMovieItems(String searchItem) async {
    final _baseURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=a51eac45a2930b3835032b8418cf3fa8&query=${searchItem}";
    print("baseURL: $_baseURL");
    final response = await client.get("$_baseURL");
    if (response.statusCode == 200) {
      print("Dipika: $_baseURL");
      return MovieResponse1.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather');
    }
  }
}