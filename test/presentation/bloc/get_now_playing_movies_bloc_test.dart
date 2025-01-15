import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_now_playing_movies.dart';
import 'package:ditonton/presentation/bloc/get_now_playing_movies/get_now_playing_movies_bloc.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/get_now_playing_movies/get_now_playing_movies_event.dart';
import 'package:ditonton/presentation/bloc/get_now_playing_movies/get_now_playing_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_now_playing_movies_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingMovies])
void main() {
  late GetNowPlayingMoviesBloc getNowPlayingMoviesBloc;
  late MockGetNowPlayingMovies mockGetNowPlayingMovies;

  setUp(() {
    mockGetNowPlayingMovies = MockGetNowPlayingMovies();
    getNowPlayingMoviesBloc = GetNowPlayingMoviesBloc(mockGetNowPlayingMovies);
  });

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
  final tMovieList = <Movie>[tMovie];

  blocTest<GetNowPlayingMoviesBloc, GetNowPlayingMoviesState>(
    'Should emit [Loading, HasData] when data is fetched successfully',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return getNowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovies()),
    expect: () =>
        [GetNowPlayingMoviesLoading(), GetNowPlayingMoviesHasData(tMovieList)],
  );

  blocTest<GetNowPlayingMoviesBloc, GetNowPlayingMoviesState>(
    'Should emit [Loading, Error] when data fetch fails',
    build: () {
      when(mockGetNowPlayingMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getNowPlayingMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingMovies()),
    expect: () => [
      GetNowPlayingMoviesLoading(),
      GetNowPlayingMoviesError('Server Failure'),
    ],
  );
}
