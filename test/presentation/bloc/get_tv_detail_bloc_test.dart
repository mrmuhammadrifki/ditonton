import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_state.dart';
import 'package:ditonton/utils/state_enum.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/dummy_objects.dart';
import 'get_tv_detail_bloc_test.mocks.dart';

@GenerateMocks([
  GetTvDetail,
  GetTvRecommendations,
  GetWatchListStatus,
  SaveWatchlistTv,
  RemoveWatchlistTv,
])
void main() {
  late TvDetailBloc tvDetailBloc;
  late MockGetTvDetail mockGetTvDetail;
  late MockGetTvRecommendations mockGetTvRecommendations;
  late MockGetWatchListStatus mockGetWatchListStatus;
  late MockSaveWatchlistTv mockSaveWatchlistTv;
  late MockRemoveWatchlistTv mockRemoveWatchlistTv;

  setUp(() {
    mockGetTvDetail = MockGetTvDetail();
    mockGetTvRecommendations = MockGetTvRecommendations();
    mockGetWatchListStatus = MockGetWatchListStatus();
    mockSaveWatchlistTv = MockSaveWatchlistTv();
    mockRemoveWatchlistTv = MockRemoveWatchlistTv();
    tvDetailBloc = TvDetailBloc(
      getTvDetail: mockGetTvDetail,
      getTvRecommendations: mockGetTvRecommendations,
      getWatchListStatus: mockGetWatchListStatus,
      saveWatchlist: mockSaveWatchlistTv,
      removeWatchlist: mockRemoveWatchlistTv,
    );
  });

  const tId = 1;
  final tTv = Tv(
    adult: false,
    backdropPath: 'backdropPath',
    genreIds: [1, 2, 3],
    id: tId,
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1.0,
    posterPath: 'posterPath',
    firstAirDate: 'firstAirDate',
    name: 'name',
    voteAverage: 8.5,
    voteCount: 100,
  );

  final tTvList = <Tv>[tTv];

  blocTest<TvDetailBloc, TvDetailState>(
    'Shoud emit TvDetailLoading, RecomendationLoading, TvDetailHasData and RecomendationHasData when get  Detail Tv and Recommendation Success',
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Right(testTvDetail));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvList));
      when(mockGetWatchListStatus.execute(tId)).thenAnswer((_) async => false);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(FetchTvDetail(tId)),
    expect: () => [
      isA<TvDetailState>().having(
          (state) => state.tvDetailState, 'tvDetailState', StateEnum.Loading),
      isA<TvDetailState>()
          .having((state) => state.tvDetail, 'tvDetail', testTvDetail)
          .having((state) => state.tvDetailState, 'tvDetailState',
              StateEnum.HasData)
          .having((state) => state.tvRecommendationsState,
              'tvRecommendationsState', StateEnum.Loading),
      isA<TvDetailState>()
          .having((state) => state.tvRecommendationsState,
              'tvRecommendationsState', StateEnum.HasData)
          .having(
              (state) => state.tvRecommendations, 'tvRecommendations', tTvList),
      isA<TvDetailState>().having(
          (state) => state.isAddedToWatchlist, 'isAddedToWatchlist', false),
    ],
    verify: (_) {
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
      verify(mockGetWatchListStatus.execute(tId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Shoud emit TvDetailLoading, RecomendationLoading, TvDetailError and RecomendationHasData when get Detail Tv and Recommendation Success',
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvList));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(FetchTvDetail(tId)),
    expect: () => [
      isA<TvDetailState>().having(
        (state) => state.tvDetailState,
        'tvDetailState',
        StateEnum.Loading,
      ),
      isA<TvDetailState>()
          .having((state) => state.message, 'message', 'Failed')
          .having(
              (state) => state.tvDetailState, 'tvDetailState', StateEnum.Error)
          .having(
            (state) => state.tvRecommendationsState,
            'tvRecommendationsState',
            StateEnum.Loading,
          ),
      isA<TvDetailState>()
          .having((state) => state.tvRecommendationsState,
              'tvRecommendationsState', StateEnum.HasData)
          .having(
            (state) => state.tvRecommendations,
            'tvRecommendations',
            tTvList,
          ),
    ],
    verify: (_) {
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Shoud emit TvDetailLoading, RecomendationLoading, TvDetailError and RecomendationHasData when get Detail Tv and Recommendation Success',
    build: () {
      when(mockGetTvDetail.execute(tId))
          .thenAnswer((_) async => Left(ConnectionFailure('Failed')));
      when(mockGetTvRecommendations.execute(tId))
          .thenAnswer((_) async => Right(tTvList));
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(FetchTvDetail(tId)),
    expect: () => [
      isA<TvDetailState>().having(
        (state) => state.tvDetailState,
        'tvDetailState',
        StateEnum.Loading,
      ),
      isA<TvDetailState>()
          .having((state) => state.message, 'message', 'Failed')
          .having(
              (state) => state.tvDetailState, 'tvDetailState', StateEnum.Error)
          .having(
            (state) => state.tvRecommendationsState,
            'tvRecommendationsState',
            StateEnum.Loading,
          ),
      isA<TvDetailState>()
          .having((state) => state.tvRecommendationsState,
              'tvRecommendationsState', StateEnum.HasData)
          .having(
            (state) => state.tvRecommendations,
            'tvRecommendations',
            tTvList,
          ),
    ],
    verify: (_) {
      verify(mockGetTvDetail.execute(tId));
      verify(mockGetTvRecommendations.execute(tId));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Shoud emit WatchlistMessage and isAddedToWatchlist True when Success AddWatchlist',
    build: () {
      when(mockSaveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => Right('Added to Watchlist'));
      when(mockGetWatchListStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => true);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(AddToWatchlist(testTvDetail)),
    expect: () => [
      isA<TvDetailState>()
          .having((state) => state.message, 'message', 'Added to Watchlist'),
      isA<TvDetailState>().having(
        (state) => state.isAddedToWatchlist,
        'isAddedToWatchlist',
        true,
      ),
    ],
    verify: (_) {
      verify(mockSaveWatchlistTv.execute(testTvDetail));
      verify(mockGetWatchListStatus.execute(testTvDetail.id));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Shoud emit watchlistMessage when Failed',
    build: () {
      when(mockSaveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatus.execute(testMovieDetail.id))
          .thenAnswer((_) async => false);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(AddToWatchlist(testTvDetail)),
    expect: () => [
      isA<TvDetailState>()
          .having((state) => state.message, 'message', 'Failed'),
      isA<TvDetailState>().having(
        (state) => state.isAddedToWatchlist,
        'isAddedToWatchlist',
        false,
      ),
    ],
    verify: (_) {
      verify(mockSaveWatchlistTv.execute(testTvDetail));
      verify(mockGetWatchListStatus.execute(testTvDetail.id));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Shoud emit WatchlistMessage and isAddedToWatchlist False when Success RemoveFromWatchlist',
    build: () {
      when(mockRemoveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => Right('Removed from Watchlist'));
      when(mockGetWatchListStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(RemoveFromWatchlist(testTvDetail)),
    expect: () => [
      isA<TvDetailState>().having(
          (state) => state.message, 'message', 'Removed from Watchlist'),
      isA<TvDetailState>().having(
        (state) => state.isAddedToWatchlist,
        'isAddedToWatchlist',
        false,
      ),
    ],
    verify: (_) {
      verify(mockRemoveWatchlistTv.execute(testTvDetail));
      verify(mockGetWatchListStatus.execute(testTvDetail.id));
    },
  );

  blocTest<TvDetailBloc, TvDetailState>(
    'Shoud emit watchlistMessage when Failed',
    build: () {
      when(mockRemoveWatchlistTv.execute(testTvDetail))
          .thenAnswer((_) async => Left(DatabaseFailure('Failed')));
      when(mockGetWatchListStatus.execute(testTvDetail.id))
          .thenAnswer((_) async => false);
      return tvDetailBloc;
    },
    act: (bloc) => bloc.add(RemoveFromWatchlist(testTvDetail)),
    expect: () => [
      isA<TvDetailState>()
          .having((state) => state.message, 'message', 'Failed'),
      isA<TvDetailState>().having(
        (state) => state.isAddedToWatchlist,
        'isAddedToWatchlist',
        false,
      ),
    ],
    verify: (_) {
      verify(mockRemoveWatchlistTv.execute(testTvDetail));
      verify(mockGetWatchListStatus.execute(testTvDetail.id));
    },
  );
}
