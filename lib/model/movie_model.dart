import 'package:flutter_movie_app/model/movie_items_model.dart';

class MovieResponse1{
  List<MovieItem> _items;
  MovieResponse1.fromJson(Map<String, dynamic> parsedJson) {
    List<MovieItem> items = [];
    for (int i = 0; i < parsedJson['results'].length; i++) {
      MovieItem result = MovieItem(parsedJson['results'][i]);
      items.add(result);
    }
    _items = items;
  }
  List<MovieItem> get items => _items;
  set items(List<MovieItem> value) {
    _items = value;
  }

}