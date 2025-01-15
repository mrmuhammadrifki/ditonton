import 'package:ditonton/domain/usecases/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movies/get_watchlist_movies_event.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_movies/get_watchlist_movies_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetWatchlistMoviesBloc
    extends Bloc<GetWatchlistMoviesEvent, GetWatchlistMoviesState> {
  final GetWatchlistMovies _getWatchlistMovies;

  GetWatchlistMoviesBloc(this._getWatchlistMovies)
      : super(GetWatchlistMoviesLoading()) {
    on<FetchWatchlistMovies>(
      (event, emit) async {
        emit(GetWatchlistMoviesLoading());
        final result = await _getWatchlistMovies.execute();

        result.fold(
          (failure) {
            emit(GetWatchlistMoviesError(failure.message));
          },
          (data) {
            emit(GetWatchlistMoviesHasData(data));
          },
        );
      },
    );
  }
}
