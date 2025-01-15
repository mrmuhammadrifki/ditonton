import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_movie_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_movie.dart';
import 'package:ditonton/domain/usecases/save_watchlist_movie.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/utils/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_movie_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetMovieDetail,
  GetMovieRecommendations,
  GetWatchListMovieStatus,
  SaveWatchlistMovie,
  RemoveWatchlistMovie,
])
void main() {
  late MovieDetailBloc movieDetailBloc;
  late MockGetMovieDetail mockGetMovieDetail;
  late MockGetMovieRecommendations mockGetMovieRecommendations;
  late MockGetWatchListMovieStatus mockGetWatchListStatus;
  late MockSaveWatchlistMovie mockSaveWatchlistMovie;
  late MockRemoveWatchlistMovie mockRemoveWatchlistMovie;

  setUp(() {
    mockGetMovieDetail = MockGetMovieDetail();
    mockGetMovieRecommendations = MockGetMovieRecommendations();
    mockGetWatchListStatus = MockGetWatchListMovieStatus();
    mockSaveWatchlistMovie = MockSaveWatchlistMovie();
    mockRemoveWatchlistMovie = MockRemoveWatchlistMovie();
    movieDetailBloc = MovieDetailBloc(
      getMovieDetail: mockGetMovieDetail,
      getMovieRecommendations: mockGetMovieRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlistMovie,
      removeWatchlist: mockRemoveWatchlistMovie,
    );
  });

  final tId = 1;

  final tMovie = Movie(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalTitle: 'originalTitle',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    releaseDate: 'releaseDate',
    title: 'title',
    video: false,
    voteAverage: 1,
    voteCount: 1,
  );
  final tMovies = <Movie>[tMovie];

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Shoud emit MovieDetailLoading, RecomendationLoading, MovieDetailHasData and RecomendationHasData when get  Detail Movie and Recommendation Success',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Right(testMovieDetail));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(tId)),
    expect: () => [
      isA<MovieDetailState>().having((state) => state.movieDetailState,
          'movieDetailState', StateEnum.Loading),
      isA<MovieDetailState>()
          .having((state) => state.movieDetail, 'movieDetail', testMovieDetail)
          .having((state) => state.movieDetailState, 'movieDetailState',
              StateEnum.HasData)
          .having((state) => state.movieRecommendationsState,
              'movieRecommendationsState', StateEnum.Loading),
      isA<MovieDetailState>()
          .having((state) => state.movieRecommendationsState,
              'movieRecommendationsState', StateEnum.HasData)
          .having((state) => state.movieRecommendations, 'movieRecommendations',
              tMovies)
          .having(
              (state) => state.isAddedToWatchlist, 'isAddedToWatchlist', false),
      isA<MovieDetailState>().having(
          (state) => state.isAddedToWatchlist, 'isAddedToWatchlist', false),
    ],
    verify: (_) {
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Shoud emit MovieDetailLoading, RecomendationLoading, MovieDetailError and RecomendationHasData when get Detail Tv and Recommendation Success',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(tId)),
    expect: () => [
      isA<MovieDetailState>().having(
        (state) => state.movieDetailState,
        'movieDetailState',
        StateEnum.Loading,
      ),
      isA<MovieDetailState>()
          .having((state) => state.message, 'message', 'Failed')
          .having((state) => state.movieDetailState, 'movieDetailState',
              StateEnum.Error)
          .having(
            (state) => state.movieRecommendationsState,
            'movieRecommendationsState',
            StateEnum.Loading,
          ),
      isA<MovieDetailState>()
          .having((state) => state.movieRecommendationsState,
              'movieRecommendationsState', StateEnum.HasData)
          .having(
            (state) => state.movieRecommendations,
            'movieRecommendations',
            tMovies,
          ),
    ],
    verify: (_) {
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Shoud emit MovieDetailLoading, RecomendationLoading, MovieDetailError and RecomendationHasData when get Detail Tv and Recommendation Success',
    build: () {
      when(mockGetMovieDetail.execute(tId))
          .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
      when(mockGetMovieRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tMovies));
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(FetchMovieDetail(tId)),
    expect: () => [
      isA<MovieDetailState>().having(
        (state) => state.movieDetailState,
        'movieDetailState',
        StateEnum.Loading,
      ),
      isA<MovieDetailState>()
          .having((state) => state.message, 'message', 'Failed')
          .having((state) => state.movieDetailState, 'MovieDetailState',
              StateEnum.Error)
          .having(
            (state) => state.movieRecommendationsState,
            'movieRecommendationsState',
            StateEnum.Loading,
          ),
      isA<MovieDetailState>()
          .having((state) => state.movieRecommendationsState,
              'movieRecommendationsState', StateEnum.HasData)
          .having(
            (state) => state.movieRecommendations,
            'movieRecommendations',
            tMovies,
          ),
    ],
    verify: (_) {
      verify(mockGetMovieDetail.execute(tId));
      verify(mockGetMovieRecommendations.execute(tId));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Shoud emit WatchlistMessage and isAddedToWatchlist True when Success AddWatchlist',
    build: () {
      when(mockSaveWatchlistMovie.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => true);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(AddToWatchlist(testMovieDetail)),
    expect: () => [
      isA<MovieDetailState>()
          .having((state) => state.message, 'message', 'Added to Watchlist'),
      isA<MovieDetailState>().having(
        (state) => state.isAddedToWatchlist,
        'isAddedToWatchlist',
        true,
      ),
    ],
    verify: (_) {
      verify(mockSaveWatchlistMovie.execute(testMovieDetail));
      verify(mockGetWatchListStatus.execute(testMovieDetail.id));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Shoud emit watchlistMessage when Failed',
    build: () {
      when(mockSaveWatchlistMovie.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(AddToWatchlist(testMovieDetail)),
    expect: () => [
      isA<MovieDetailState>()
          .having((state) => state.message, 'message', 'Failed'),
      isA<MovieDetailState>().having(
        (state) => state.isAddedToWatchlist,
        'isAddedToWatchlist',
        false,
      ),
    ],
    verify: (_) {
      verify(mockSaveWatchlistMovie.execute(testMovieDetail));
      verify(mockGetWatchListStatus.execute(testMovieDetail.id));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Shoud emit WatchlistMessage and isAddedToWatchlist False when Success RemoveFromWatchlist',
    build: () {
      when(mockRemoveWatchlistMovie.execute(testMovieDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
    expect: () => [
      isA<MovieDetailState>().having(
          (state) => state.message, 'message', 'Removed from Watchlist'),
      isA<MovieDetailState>().having(
        (state) => state.isAddedToWatchlist,
        'isAddedToWatchlist',
        false,
      ),
    ],
    verify: (_) {
      verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
      verify(mockGetWatchListStatus.execute(testMovieDetail.id));
    },
  );

  blocTest<MovieDetailBloc, MovieDetailState>(
    'Shoud emit watchlistMessage when Failed',
    build: () {
      when(mockRemoveWatchlistMovie.execute(testMovieDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return movieDetailBloc;
    },
    act: (bloc) => bloc.add(RemoveFromWatchlist(testMovieDetail)),
    expect: () => [
      isA<MovieDetailState>()
          .having((state) => state.message, 'message', 'Failed'),
      isA<MovieDetailState>().having(
        (state) => state.isAddedToWatchlist,
        'isAddedToWatchlist',
        false,
      ),
    ],
    verify: (_) {
      verify(mockRemoveWatchlistMovie.execute(testMovieDetail));
      verify(mockGetWatchListStatus.execute(testMovieDetail.id));
    },
  );
}
