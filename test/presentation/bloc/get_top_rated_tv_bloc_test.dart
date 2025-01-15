import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_tv/get_top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_tv/get_top_rated_tv_event.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_tv/get_top_rated_tv_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_top_rated_tv_bloc_test.mocks.dart';

@GenerateMocks([GetTopRatedTv])
void main() {
  late GetTopRatedTvBloc getTopRatedTvBloc;
  late MockGetTopRatedTv mockGetTopRatedTv;

  setUp(() {
    mockGetTopRatedTv = MockGetTopRatedTv();
    getTopRatedTvBloc = GetTopRatedTvBloc(mockGetTopRatedTv);
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

  blocTest<GetTopRatedTvBloc, GetTopRatedTvState>(
    'Should emit [Loading, HasData] when data is fetched successfully',
    build: () {
      when(mockGetTopRatedTv.execute()).thenAnswer((_) async => Right(tTvList));
      return getTopRatedTvBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => [GetTopRatedTvLoading(), GetTopRatedTvHasData(tTvList)],
  );

  blocTest<GetTopRatedTvBloc, GetTopRatedTvState>(
    'Should emit [Loading, Error] when data fetch fails',
    build: () {
      when(mockGetTopRatedTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getTopRatedTvBloc;
    },
    act: (bloc) => bloc.add(FetchTopRatedTv()),
    expect: () => [
      GetTopRatedTvLoading(),
      GetTopRatedTvError('Server Failure'),
    ],
  );
}
