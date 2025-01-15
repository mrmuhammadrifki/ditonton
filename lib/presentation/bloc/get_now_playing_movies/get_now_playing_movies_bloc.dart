import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/get_now_playing_movies/get_now_playing_movies_event.dart';
import 'package:ditonton/presentation/bloc/get_now_playing_movies/get_now_playing_movies_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetNowPlayingMoviesBloc
    extends Bloc<GetNowPlayingMoviesEvent, GetNowPlayingMoviesState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  GetNowPlayingMoviesBloc(this._getNowPlayingMovies)
      : super(GetNowPlayingMoviesLoading()) {
    on<FetchNowPlayingMovies>(
      (event, emit) async {
        emit(GetNowPlayingMoviesLoading());
        final result = await _getNowPlayingMovies.execute();

        result.fold(
          (failure) {
            emit(GetNowPlayingMoviesError(failure.message));
          },
          (data) {
            emit(GetNowPlayingMoviesHasData(data));
          },
        );
      },
    );
  }
}
