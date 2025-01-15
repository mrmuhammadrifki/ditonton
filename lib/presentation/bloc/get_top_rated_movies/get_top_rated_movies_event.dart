import 'package:equatable/equatable.dart';

abstract class GetTopRatedMoviesEvent extends Equatable {
  const GetTopRatedMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedMovies extends GetTopRatedMoviesEvent {}
