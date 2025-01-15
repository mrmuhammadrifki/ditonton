import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/presentation/bloc/get_popular_movies/get_popular_movies_event.dart';
import 'package:ditonton/presentation/bloc/get_popular_movies/get_popular_movies_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPopularMoviesBloc
    extends Bloc<GetPopularMoviesEvent, GetPopularMoviesState> {
  final GetPopularMovies _getPopularMovies;

  GetPopularMoviesBloc(this._getPopularMovies)
      : super(GetPopularMoviesLoading()) {
    on<FetchPopularMovies>(
      (event, emit) async {
        emit(GetPopularMoviesLoading());
        final result = await _getPopularMovies.execute();

        result.fold(
          (failure) {
            emit(GetPopularMoviesError(failure.message));
          },
          (data) {
            emit(GetPopularMoviesHasData(data));
          },
        );
      },
    );
  }
}
