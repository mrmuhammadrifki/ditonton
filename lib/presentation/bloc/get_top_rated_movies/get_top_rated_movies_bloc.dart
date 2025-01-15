import 'package:ditonton/domain/usecases/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_movies/get_top_rated_movies_event.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_movies/get_top_rated_movies_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetTopRatedMoviesBloc
    extends Bloc<GetTopRatedMoviesEvent, GetTopRatedMoviesState> {
  final GetTopRatedMovies _getTopRatedMovies;

  GetTopRatedMoviesBloc(this._getTopRatedMovies)
      : super(GetTopRatedMoviesLoading()) {
    on<FetchTopRatedMovies>(
      (event, emit) async {
        emit(GetTopRatedMoviesLoading());
        final result = await _getTopRatedMovies.execute();

        result.fold(
          (failure) {
            emit(GetTopRatedMoviesError(failure.message));
          },
          (data) {
            emit(GetTopRatedMoviesHasData(data));
          },
        );
      },
    );
  }
}
