import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/presentation/bloc/get_now_playing_tv/get_now_playing_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/get_now_playing_tv/get_now_playing_tv_event.dart';
import 'package:ditonton/presentation/bloc/get_now_playing_tv/get_now_playing_tv_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_now_playing_tv_bloc_test.mocks.dart';

@GenerateMocks([GetNowPlayingTv])
void main() {
  late GetNowPlayingTvBloc getNowPlayingTvBloc;
  late MockGetNowPlayingTv mockGetNowPlayingTv;

  setUp(() {
    mockGetNowPlayingTv = MockGetNowPlayingTv();
    getNowPlayingTvBloc = GetNowPlayingTvBloc(mockGetNowPlayingTv);
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

  blocTest<GetNowPlayingTvBloc, GetNowPlayingTvState>(
    'Should emit [Loading, HasData] when data is fetched successfully',
    build: () {
      when(mockGetNowPlayingTv.execute()).thenAnswer((_) async => Right(tTvList));
      return getNowPlayingTvBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTv()),
    expect: () => [GetNowPlayingTvLoading(), GetNowPlayingTvHasData(tTvList)],
  );

  blocTest<GetNowPlayingTvBloc, GetNowPlayingTvState>(
    'Should emit [Loading, Error] when data fetch fails',
    build: () {
      when(mockGetNowPlayingTv.execute())
          .thenAnswer((_) async => Left(ServerFailure('Server Failure')));
      return getNowPlayingTvBloc;
    },
    act: (bloc) => bloc.add(FetchNowPlayingTv()),
    expect: () => [
      GetNowPlayingTvLoading(),
      GetNowPlayingTvError('Server Failure'),
    ],
  );
}
