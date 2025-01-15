import 'package:ditonton/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class GetTopRatedTvState extends Equatable {
  const GetTopRatedTvState();

  @override
  List<Object> get props => [];
}

class GetTopRatedTvEmpty extends GetTopRatedTvState {}

class GetTopRatedTvLoading extends GetTopRatedTvState {}

class GetTopRatedTvError extends GetTopRatedTvState {
  final String message;

  GetTopRatedTvError(this.message);

  @override
  List<Object> get props => [message];
}

class GetTopRatedTvHasData extends GetTopRatedTvState {
  final List<Tv> result;

  GetTopRatedTvHasData(this.result);

  @override
  List<Object> get props => [result];
}
