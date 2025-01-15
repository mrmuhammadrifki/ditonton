import 'package:ditonton/presentation/bloc/get_top_rated_movies/get_top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_movies/get_top_rated_movies_event.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_movies/get_top_rated_movies_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-movie';

  @override
  _TopRatedMoviePageState createState() => _TopRatedMoviePageState();
}

class _TopRatedMoviePageState extends State<TopRatedMoviePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<GetTopRatedMoviesBloc>().add(
            FetchTopRatedMovies(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetTopRatedMoviesBloc, GetTopRatedMoviesState>(
          builder: (context, state) {
            if (state is GetTopRatedMoviesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetTopRatedMoviesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return MovieCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is GetTopRatedMoviesError) {
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
