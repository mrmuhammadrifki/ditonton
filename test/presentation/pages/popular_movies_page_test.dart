import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/presentation/bloc/get_popular_movies/get_popular_movies_bloc.dart';
import 'package:ditonton/presentation/bloc/get_popular_movies/get_popular_movies_event.dart';
import 'package:ditonton/presentation/bloc/get_popular_movies/get_popular_movies_state.dart';
import 'package:ditonton/presentation/pages/popular_movie_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../dummy_data/dummy_objects.dart';

class PopularMoviesEventFake extends Fake implements GetPopularMoviesEvent {}

class PopularMoviesStateFake extends Fake implements GetPopularMoviesEvent {}

class MockPopularMoviesBloc
    extends MockBloc<GetPopularMoviesEvent, GetPopularMoviesState>
    implements GetPopularMoviesBloc {}

void main() {
  late MockPopularMoviesBloc mockPopularMoviesBloc;

  setUpAll(() {
    registerFallbackValue(PopularMoviesEventFake());
    registerFallbackValue(PopularMoviesStateFake());
  });

  setUp(() {
    mockPopularMoviesBloc = MockPopularMoviesBloc();
  });

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<GetPopularMoviesBloc>.value(
      value: mockPopularMoviesBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(GetPopularMoviesLoading());

    final progressBarFinder = find.byType(CircularProgressIndicator);
    final centerFinder = find.byType(Center);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviePage()));

    expect(centerFinder, findsOneWidget);
    expect(progressBarFinder, findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(GetPopularMoviesHasData([testMovie]));

    final listViewFinder = find.byType(ListView);

    await tester.pumpWidget(_makeTestableWidget(PopularMoviePage()));

    expect(listViewFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Empty',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state).thenReturn(GetPopularMoviesEmpty());

    final textFinder = find.text('No data available');

    await tester.pumpWidget(_makeTestableWidget(PopularMoviePage()));

    expect(textFinder, findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockPopularMoviesBloc.state)
        .thenReturn(GetPopularMoviesError('Failed'));

    final textFinder = find.byKey(const Key('error_message'));

    await tester.pumpWidget(_makeTestableWidget(PopularMoviePage()));

    expect(textFinder, findsOneWidget);
  });
}
