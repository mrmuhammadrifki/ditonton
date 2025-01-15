import 'package:ditonton/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class GetNowPlayingTvState extends Equatable {
  const GetNowPlayingTvState();

  @override
  List<Object> get props => [];
}

class GetNowPlayingTvEmpty extends GetNowPlayingTvState {}

class GetNowPlayingTvLoading extends GetNowPlayingTvState {}

class GetNowPlayingTvError extends GetNowPlayingTvState {
  final String message;

  GetNowPlayingTvError(this.message);

  @override
  List<Object> get props => [message];
}

class GetNowPlayingTvHasData extends GetNowPlayingTvState {
  final List<Tv> result;

  GetNowPlayingTvHasData(this.result);

  @override
  List<Object> get props => [result];
}
