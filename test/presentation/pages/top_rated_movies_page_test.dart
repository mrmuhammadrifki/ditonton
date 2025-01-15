import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_movies/get_top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_movies/get_top_rated_movies_event.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_movies/get_top_rated_movies_state.dart';
import 'package:ditonton/presentation/pages/top_rated_movie_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class TopRatedMoviesEventFake extends Fake implements GetTopRatedMoviesEvent {}

class TopRatedMoviesStateFake extends Fake implements GetTopRatedMoviesEvent {}

class MockTopRatedMoviesBloc
    extends MockBloc<GetTopRatedMoviesEvent, GetTopRatedMoviesState>
    implements GetTopRatedMoviesBloc {}

void main() {
  late MockTopRatedMoviesBloc mockTopRatedMoviesBloc;

  setUpAll(() {
    registerFallbackValue(TopRatedMoviesEventFake());
    registerFallbackValue(TopRatedMoviesStateFake());
  });

  setUp(() {
    mockTopRatedMoviesBloc = MockTopRatedMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetTopRatedMoviesBloc>.value(
      value: mockTopRatedMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(GetTopRatedMoviesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviePage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(GetTopRatedMoviesHasData([testMovie]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviePage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Empty',
      (WidgetTester tester) async {
    when(() => mockTopRatedMoviesBloc.state).thenReturn(GetTopRatedMoviesEmpty());

    final textFinder = find.text('No data available');

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviePage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockTopRatedMoviesBloc.state)
        .thenReturn(GetTopRatedMoviesError('Failed'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(TopRatedMoviePage()));

    expect(textFinder, findsOneWidget);
  });
}
