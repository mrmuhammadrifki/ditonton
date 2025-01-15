import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_state.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv_detail_page.dart';
import 'package:ditonton/utils/state_enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../dummy_data/dummy_objects.dart';

class TvDetailEventFake extends Fake implements TvDetailEvent {}

class TvDetailStateFake extends Fake implements TvDetailState {}

class MockTvDetailBloc extends MockBloc<TvDetailEvent, TvDetailState>
    implements TvDetailBloc {}

void main() {
  late MockTvDetailBloc mockTvDetailBloc;

  setUpAll(() {
    registerFallbackValue(TvDetailEventFake());
    registerFallbackValue(TvDetailStateFake());
  });

  setUp(() {
    mockTvDetailBloc = MockTvDetailBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<TvDetailBloc>.value(
      value: mockTvDetailBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Detail Tv Page should display Progressbar when loading',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: StateEnum.Loading,
      ),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('should display loading when recommendationState loading',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: StateEnum.HasData,
        tvDetail: testTvDetail,
        tvRecommendationsState: StateEnum.Loading,
        tvRecommendations: <Tv>[],
        isAddedToWatchlist: false,
      ),
    );

    final progressBarFinder = find.byType(CircularProgressIndicator);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(progressBarFinder, findsWidgets);
  });

  testWidgets(
      'Watchlist button should display add icon when Tv not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: StateEnum.HasData,
        tvDetail: testTvDetail,
        tvRecommendationsState: StateEnum.HasData,
        tvRecommendations: [testTv],
        isAddedToWatchlist: false,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.add);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when Tv is added to wathclist',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: StateEnum.HasData,
        tvDetail: testTvDetail,
        tvRecommendationsState: StateEnum.HasData,
        tvRecommendations: [testTv],
        isAddedToWatchlist: true,
      ),
    );

    final watchlistButtonIcon = find.byIcon(Icons.check);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));

    expect(watchlistButtonIcon, findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    whenListen(
      mockTvDetailBloc,
      Stream.fromIterable([
        TvDetailState.initial().copyWith(
          tvDetailState: StateEnum.HasData,
          tvDetail: testTvDetail,
          tvRecommendationsState: StateEnum.HasData,
          tvRecommendations: [testTv],
          isAddedToWatchlist: false,
        ),
        TvDetailState.initial().copyWith(
          tvDetailState: StateEnum.HasData,
          tvDetail: testTvDetail,
          tvRecommendationsState: StateEnum.HasData,
          tvRecommendations: [testTv],
          isAddedToWatchlist: false,
          message: 'Added to Watchlist',
        ),
      ]),
      initialState: TvDetailState.initial(),
    );

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when removed from watchlist',
      (WidgetTester tester) async {
    whenListen(
      mockTvDetailBloc,
      Stream.fromIterable([
        TvDetailState.initial().copyWith(
          tvDetailState: StateEnum.HasData,
          tvDetail: testTvDetail,
          tvRecommendationsState: StateEnum.HasData,
          tvRecommendations: [testTv],
          isAddedToWatchlist: false,
        ),
        TvDetailState.initial().copyWith(
          tvDetailState: StateEnum.HasData,
          tvDetail: testTvDetail,
          tvRecommendationsState: StateEnum.HasData,
          tvRecommendations: [testTv],
          isAddedToWatchlist: false,
          message: 'Removed from Watchlist',
        ),
      ]),
      initialState: TvDetailState.initial(),
    );

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump();

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Removed from Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    whenListen(
      mockTvDetailBloc,
      Stream.fromIterable([
        TvDetailState.initial().copyWith(
          tvDetailState: StateEnum.HasData,
          tvDetail: testTvDetail,
          tvRecommendationsState: StateEnum.HasData,
          tvRecommendations: [testTv],
          isAddedToWatchlist: false,
        ),
        TvDetailState.initial().copyWith(
          tvDetailState: StateEnum.HasData,
          tvDetail: testTvDetail,
          tvRecommendationsState: StateEnum.HasData,
          tvRecommendations: [testTv],
          isAddedToWatchlist: false,
          message: 'Failed',
        ),
        TvDetailState.initial().copyWith(
          tvDetailState: StateEnum.HasData,
          tvDetail: testTvDetail,
          tvRecommendationsState: StateEnum.HasData,
          tvRecommendations: [testTv],
          isAddedToWatchlist: false,
          message: 'Failed ',
        ),
      ]),
      initialState: TvDetailState.initial(),
    );

    final watchlistButton = find.byType(FilledButton);

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton, warnIfMissed: false);
    await tester.pump();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });

  testWidgets(
      'Detail tv Page should display Error Text when No Internet Network (Error)',
      (WidgetTester tester) async {
    when(() => mockTvDetailBloc.state).thenReturn(
      TvDetailState.initial().copyWith(
        tvDetailState: StateEnum.Error,
        message: 'Failed to connect to the network',
      ),
    );

    final textErrorBarFinder = find.text('Failed to connect to the network');

    await tester.pumpWidget(_makeTestableWidget(TvDetailPage(id: 1)));
    await tester.pump();

    expect(textErrorBarFinder, findsOneWidget);
  });
}
