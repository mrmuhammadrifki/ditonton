import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movies/get_watchlist_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movies/get_watchlist_movies_event.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movies/get_watchlist_movies_state.dart';
import 'package:ditonton/presentation/widgets/movie_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistMoviePage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  @override
  _WatchlistMoviePageState createState() => _WatchlistMoviePageState();
}

class _WatchlistMoviePageState extends State<WatchlistMoviePage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<GetWatchlistMoviesBloc>().add(
            FetchWatchlistMovies(),
          ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Future.microtask(
      () => context.read<GetWatchlistMoviesBloc>().add(
            FetchWatchlistMovies(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist Movies'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetWatchlistMoviesBloc, GetWatchlistMoviesState>(
          builder: (context, state) {
            if (state is GetWatchlistMoviesLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetWatchlistMoviesHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return MovieCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is GetWatchlistMoviesError) {
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
