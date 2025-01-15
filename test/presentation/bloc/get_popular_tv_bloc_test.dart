import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/presentation/bloc/get_popular_tv/get_popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/get_popular_tv/get_popular_tv_event.dart';
import 'package:ditonton/presentation/bloc/get_popular_tv/get_popular_tv_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_popular_tv_bloc_test.mocks.dart';

@GenerateMocks([GetPopularTv])
void main() {
  late GetPopularTvBloc getPopularTvBloc;
  late MockGetPopularTv mockGetPopularTv;

  setUp(() {
    mockGetPopularTv = MockGetPopularTv();
    getPopularTvBloc = GetPopularTvBloc(mockGetPopularTv);
  });

  final tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: 1,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvList = <Tv>[tTv];

  blocTest<GetPopularTvBloc, GetPopularTvState>(
    'Should emit [Loading, HasData] when data is fetched successfully',
    build: () {
      when(mockGetPopularTv.execute()).thenAnswer((_) async => Right(tTvList));
      return getPopularTvBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTv()),
    expect: () => [GetPopularTvLoading(), GetPopularTvHasData(tTvList)],
  );

  blocTest<GetPopularTvBloc, GetPopularTvState>(
    'Should emit [Loading, Error] when data fetch fails',
    build: () {
      when(mockGetPopularTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getPopularTvBloc;
    },
    act: (bloc) => bloc.add(FetchPopularTv()),
    expect: () => [
      GetPopularTvLoading(),
      GetPopularTvError('Server Failure'),
    ],
  );
}
