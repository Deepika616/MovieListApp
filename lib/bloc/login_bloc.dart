import 'package:flutter_movie_app/model/movie_model.dart';
import 'package:flutter_movie_app/persistance/repository.dart';
import 'package:rxdart/rxdart.dart';

class MovieBloc{
  Repository _repository = Repository();
  final _itemsFetcher = PublishSubject<MovieResponse1>();
  Observable<MovieResponse1> get items => _itemsFetcher.stream;
  fetchUserItems(String searchItem) async {
    MovieResponse1 movieItemsResponse = await _repository.fetchMovieItems(searchItem);
    print('movieItemsResponse == ${movieItemsResponse}');
    _itemsFetcher.sink.add(movieItemsResponse);
  }
  dispose() {
    //_itemsFetcher.close();
  }
}
final movieBloc = MovieBloc();