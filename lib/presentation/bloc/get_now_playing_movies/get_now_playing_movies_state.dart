import 'package:ditonton/domain/entities/movie.dart';
import 'package:equatable/equatable.dart';

abstract class GetNowPlayingMoviesState extends Equatable {
  const GetNowPlayingMoviesState();

  @override
  List<Object> get props => [];
}

class GetNowPlayingMoviesEmpty extends GetNowPlayingMoviesState {}

class GetNowPlayingMoviesLoading extends GetNowPlayingMoviesState {}

class GetNowPlayingMoviesError extends GetNowPlayingMoviesState {
  final String message;

  GetNowPlayingMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class GetNowPlayingMoviesHasData extends GetNowPlayingMoviesState {
  final List<Movie> result;

  GetNowPlayingMoviesHasData(this.result);

  @override
  List<Object> get props => [result];
}
