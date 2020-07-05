import 'dart:convert';
import 'package:flutter_movie_app/bloc/login_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movie_app/model/movie_model.dart';
import 'package:flutter_movie_app/screen/MovieItem.dart';
import 'package:flutter_movie_app/screen/MovieResModel.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({this.title});

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool isShow = false;

  TextEditingController searchController = new TextEditingController();
  String searchText = "";

  String url =
      "https://api.themoviedb.org/3/movie/now_playing?api_key=a51eac45a2930b3835032b8418cf3fa8";
  MovieResponse movie;
  MovieResponse search;
  @override
  void initState() {
    super.initState();
    fetchMovies();
  }

  fetchMovies() async {
    var response = await http.get(url);
    var decodedJson = jsonDecode(response.body);
//    movie = MovieResponse.fromJson(decodedJson);
    print(movie);
    print(response.body);
    setState(() {
      movie = MovieResponse.fromJson(decodedJson);
    });
//    print(2);
  }


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final width = size.width;
    final height = size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Wrap(
           // alignment: WrapAlignment.end,
            children: <Widget>[
              _buildSearchBar(),
              Expanded(//loads github user list
                  child:  StreamBuilder(
                      stream: movieBloc.items,
                      builder: (context, AsyncSnapshot<MovieResponse1> snapshot) {
                        if (snapshot.hasData) {
                          return _buildListView(snapshot.data);
                        } else if (snapshot.hasError) {
                          return Text(snapshot.error.toString());
                        }
                        return isShow ? Center(child: CircularProgressIndicator()) : Center(child: Text(''));
                      })
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: SingleChildScrollView(
                  child: Container(
                    height:  height,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: movie == null
          ? Center(
                  child: CircularProgressIndicator(),
            )
          :ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return MovieItem(
                          movie: movie.results[index],);
                      },
                      itemCount: movie.results.length,
                    ),
                  ),
                ),
              ),
            ],
        ),
       ),
        ),
    );
  }


  Widget _buildSearchBar() {
    return new Container(
      color: Theme.of(context).accentColor,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: new Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: new ListTile(
            leading: new Icon(Icons.search),
            title: new TextField(
              controller: searchController,
              decoration: new InputDecoration(
                  hintText: 'Search', border: InputBorder.none),
              onChanged: (value) {
                if (value != "") {
                  //fetch github users as per search value
                  setState(() {
                    isShow = true;
                  });
                  movieBloc.fetchUserItems(value);
                }
              },
            ),
            trailing: new IconButton(
              icon: new Icon(Icons.cancel), onPressed: () {
              searchController.clear();
              onSearchTextChanged('');
              movieBloc.fetchUserItems('');
            },),
          ),
        ),
      ),
    );
  }

  onSearchTextChanged(String text) async {
    if (searchController.text.isEmpty) {
      setState(() {});
      return;
    }
  }

  Widget _buildListView(MovieResponse1 data){
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 5;
    final double itemWidth = size.width / 2;
    return  CustomScrollView(
      primary: false,
      slivers: <Widget>[
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverGrid.count(
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            crossAxisCount: 1,
            childAspectRatio: (itemWidth / itemHeight),
            children: data.items.map((value) {
              return Container(
                alignment: Alignment.center,
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  color: Colors.cyan[100],
                ),
                child: Column(
                  children: <Widget>[
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Image.network(value.poster,),
                        )
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("${value.title}",style: Theme.of(context).textTheme.bodyText1),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Text("Year: ${value.year}",style: Theme.of(context).textTheme.bodyText2,textAlign: TextAlign.center),
                    ),

                  ],
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
