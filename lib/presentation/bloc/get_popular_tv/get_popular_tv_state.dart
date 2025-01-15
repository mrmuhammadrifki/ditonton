import 'package:ditonton/domain/entities/tv.dart';
import 'package:equatable/equatable.dart';

abstract class GetPopularTvState extends Equatable {
  const GetPopularTvState();

  @override
  List<Object> get props => [];
}

class GetPopularTvEmpty extends GetPopularTvState {}

class GetPopularTvLoading extends GetPopularTvState {}

class GetPopularTvError extends GetPopularTvState {
  final String message;

  GetPopularTvError(this.message);

  @override
  List<Object> get props => [message];
}

class GetPopularTvHasData extends GetPopularTvState {
  final List<Tv> result;

  GetPopularTvHasData(this.result);

  @override
  List<Object> get props => [result];
}
