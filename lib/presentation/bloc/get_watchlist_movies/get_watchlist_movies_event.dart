import 'package:equatable/equatable.dart';

abstract class GetWatchlistMoviesEvent extends Equatable {
  const GetWatchlistMoviesEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistMovies extends GetWatchlistMoviesEvent {}
