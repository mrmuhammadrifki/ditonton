import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/get_popular_movies.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/presentation/bloc/get_popular_movies/get_popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/get_popular_movies/get_popular_movies_event.dart';
import 'package:ditonton/presentation/bloc/get_popular_movies/get_popular_movies_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_popular_movies_bloc_test.mocks.dart';

@GenerateMocks([GetPopularMovies])
void main() {
  late GetPopularMoviesBloc getPopularMoviesBloc;
  late MockGetPopularMovies mockGetPopularMovies;

  setUp(() {
    mockGetPopularMovies = MockGetPopularMovies();
    getPopularMoviesBloc = GetPopularMoviesBloc(mockGetPopularMovies);
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

  blocTest<GetPopularMoviesBloc, GetPopularMoviesState>(
    'Should emit [Loading, HasData] when data is fetched successfully',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Right(tMovieList));
      return getPopularMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovies()),
    expect: () =>
        [GetPopularMoviesLoading(), GetPopularMoviesHasData(tMovieList)],
  );

  blocTest<GetPopularMoviesBloc, GetPopularMoviesState>(
    'Should emit [Loading, Error] when data fetch fails',
    build: () {
      when(mockGetPopularMovies.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getPopularMoviesBloc;
    },
    act: (bloc) => bloc.add(FetchPopularMovies()),
    expect: () => [
      GetPopularMoviesLoading(),
      GetPopularMoviesError('Server Failure'),
    ],
  );
}
