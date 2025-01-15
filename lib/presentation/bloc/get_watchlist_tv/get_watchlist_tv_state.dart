import 'package:ditonton/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class GetWatchlistTvState extends Equatable {
  const GetWatchlistTvState();

  @override
  List<Object> get props => [];
}

class GetWatchlistTvEmpty extends GetWatchlistTvState {}

class GetWatchlistTvLoading extends GetWatchlistTvState {}

class GetWatchlistTvError extends GetWatchlistTvState {
  final String message;

  GetWatchlistTvError(this.message);

  @override
  List<Object> get props => [message];
}

class GetWatchlistTvHasData extends GetWatchlistTvState {
  final List<Tv> result;

  GetWatchlistTvHasData(this.result);

  @override
  List<Object> get props => [result];
}
