import 'package:ditonton/presentation/bloc/get_popular_movies/get_popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/get_popular_movies/get_popular_movies_event.dart';
import 'package:ditonton/presentation/bloc/get_popular_movies/get_popular_movies_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-movie';

  @override
  _PopularMoviePageState createState() => _PopularMoviePageState();
}

class _PopularMoviePageState extends State<PopularMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<GetPopularMoviesBloc>().add(
            FetchPopularMovies(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetPopularMoviesBloc, GetPopularMoviesState>(
          builder: (context, state) {
            if (state is GetPopularMoviesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetPopularMoviesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return MovieCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is GetPopularMoviesError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                child: Text('No data available'),
              );
            }
          },
        ),
      ),
    );
  }
}
