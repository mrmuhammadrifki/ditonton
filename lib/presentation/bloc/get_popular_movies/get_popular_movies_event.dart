import 'package:equatable/equatable.dart';

abstract class GetPopularMoviesEvent extends Equatable {
  const GetPopularMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularMovies extends GetPopularMoviesEvent {}
