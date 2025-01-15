import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/utils/state_enum.dart';

class MovieDetailState {
  final MovieDetail movieDetail;
  final StateEnum movieDetailState;
  final List<Movie> movieRecommendations;
  final StateEnum movieRecommendationsState;
  final bool isAddedToWatchlist;
  final String message;

  MovieDetailState({
    required this.movieDetail,
    required this.movieDetailState,
    required this.movieRecommendations,
    required this.movieRecommendationsState,
    required this.isAddedToWatchlist,
    required this.message,
  });

  factory MovieDetailState.initial() => MovieDetailState(
        movieDetail: MovieDetail(
          adult: false,
          backdropPath: 'backdropPath',
          genres: [Genre(id: 1, name: 'Action')],
          id: 1,
          originalTitle: 'originalTitle',
          overview: 'overview',
          posterPath: 'posterPath',
          releaseDate: 'releaseDate',
          runtime: 120,
          title: 'title',
          voteAverage: 1,
          voteCount: 1,
        ),
        movieDetailState: StateEnum.Empty,
        movieRecommendations: [],
        movieRecommendationsState: StateEnum.Empty,
        isAddedToWatchlist: false,
        message: '',
      );

  MovieDetailState copyWith({
    MovieDetail? movieDetail,
    StateEnum? movieDetailState,
    List<Movie>? movieRecommendations,
    StateEnum? movieRecommendationsState,
    bool? isAddedToWatchlist,
    String? message,
  }) {
    return MovieDetailState(
      movieDetail: movieDetail ?? this.movieDetail,
      movieDetailState: movieDetailState ?? this.movieDetailState,
      movieRecommendations: movieRecommendations ?? this.movieRecommendations,
      movieRecommendationsState:
          movieRecommendationsState ?? this.movieRecommendationsState,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
    );
  }
}
