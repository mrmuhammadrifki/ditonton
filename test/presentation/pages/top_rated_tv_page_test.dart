import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_tv/get_top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_tv/get_top_rated_tv_event.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_tv/get_top_rated_tv_state.dart';
import 'package:ditonton/presentation/pages/top_rated_tv_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class TopRatedTvEventFake extends Fake implements GetTopRatedTvEvent {}

class TopRatedTvStateFake extends Fake implements GetTopRatedTvEvent {}

class MockTopRatedTvBloc
    extends MockBloc<GetTopRatedTvEvent, GetTopRatedTvState>
    implements GetTopRatedTvBloc {}

void main() {
  late MockTopRatedTvBloc mockTopRatedTvBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedTvEventFake());
    registerFallbackValue(TopRatedTvStateFake());
  });

  setUp(() {
    mockTopRatedTvBloc = MockTopRatedTvBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetTopRatedTvBloc>.value(
      value: mockTopRatedTvBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvBloc.state).thenReturn(GetTopRatedTvLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvBloc.state)
        .thenReturn(GetTopRatedTvHasData([testTv]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Empty',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvBloc.state).thenReturn(GetTopRatedTvEmpty());

    final textFinder = find.text('No data available');

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTopRatedTvBloc.state)
        .thenReturn(GetTopRatedTvError('Failed'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedTvPage()));

    expect(textFinder, findsOneWidget);
  });
}
