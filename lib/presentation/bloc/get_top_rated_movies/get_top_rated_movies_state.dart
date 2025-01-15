import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class GetTopRatedMoviesState extends Equatable {
  const GetTopRatedMoviesState();

  @override
  List<Object> get props => [];
}

class GetTopRatedMoviesEmpty extends GetTopRatedMoviesState {}

class GetTopRatedMoviesLoading extends GetTopRatedMoviesState {}

class GetTopRatedMoviesError extends GetTopRatedMoviesState {
  final String message;

  GetTopRatedMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetTopRatedMoviesHasData extends GetTopRatedMoviesState {
  final List<Movie> result;

  GetTopRatedMoviesHasData(this.result);

  @override
  List<Object> get props => [result];
}
