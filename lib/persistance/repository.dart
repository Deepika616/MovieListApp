
import 'package:flutter_movie_app/model/movie_model.dart';
import 'api_provider.dart';

class Repository{
  ApiProvider appApiProvider = ApiProvider();
  Future<MovieResponse1> fetchMovieItems(String searchItem) => appApiProvider.fetchMovieItems(searchItem);
}