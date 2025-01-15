import 'package:equatable/equatable.dart';

abstract class GetNowPlayingMoviesEvent extends Equatable {
  const GetNowPlayingMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingMovies extends GetNowPlayingMoviesEvent {}
