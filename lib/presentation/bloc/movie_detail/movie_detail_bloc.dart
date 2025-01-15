import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movie_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_movie.dart';
import 'package:ditonton/domain/usecases/save_watchlist_movie.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:ditonton/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListMovieStatus getWatchListStatus;
  final SaveWatchlistMovie saveWatchlist;
  final RemoveWatchlistMovie removeWatchlist;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(MovieDetailState.initial()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(state.copyWith(movieDetailState: StateEnum.Loading));

      final detailResult = await getMovieDetail.execute(event.id);
      final recommendationResult =
          await getMovieRecommendations.execute(event.id);

      detailResult.fold(
        (failure) async {
          emit(state.copyWith(
            movieDetailState: StateEnum.Error,
            message: failure.message,
            movieRecommendationsState: StateEnum.Loading,
          ));
          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                movieRecommendationsState: StateEnum.Error,
                message: failure.message,
              ));
            },
            (movie) {
              emit(state.copyWith(
                movieRecommendationsState: StateEnum.HasData,
                movieRecommendations: movie,
              ));
            },
          );
        },
        (movie) async {
          emit(state.copyWith(
            movieRecommendationsState: StateEnum.Loading,
            movieDetail: movie,
            movieDetailState: StateEnum.HasData,
          ));
          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                movieRecommendationsState: StateEnum.Error,
                message: failure.message,
              ));
            },
            (movie) {
              emit(state.copyWith(
                movieRecommendationsState: StateEnum.HasData,
                movieRecommendations: movie,
              ));
            },
          );
          add(LoadWatchlistStatus(event.id));
        },
      );
    });

    on<AddToWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.movie);

      result.fold((failure) {
        emit(state.copyWith(message: failure.message));
      }, (successMessage) {
        emit(state.copyWith(message: successMessage));
      });
      add(LoadWatchlistStatus(event.movie.id));
    });
    on<RemoveFromWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.movie);

      result.fold((failure) {
        emit(state.copyWith(message: failure.message));
      }, (successMessage) {
        emit(state.copyWith(message: successMessage));
      });
      add(LoadWatchlistStatus(event.movie.id));
    });
    on<LoadWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
    on<ResetMessage>((event, emit) {
      emit(state.copyWith(message: ''));
    });
  }
}
