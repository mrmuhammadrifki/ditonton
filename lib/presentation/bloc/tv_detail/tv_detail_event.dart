import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvDetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchTvDetail extends TvDetailEvent {
  final int id;

  FetchTvDetail(this.id);

  @override
  List<Object?> get props => [id];
}

class AddToWatchlist extends TvDetailEvent {
  final TvDetail tv;

  AddToWatchlist(this.tv);

  @override
  List<Object?> get props => [tv];
}

class RemoveFromWatchlist extends TvDetailEvent {
  final TvDetail tv;

  RemoveFromWatchlist(this.tv);

  @override
  List<Object?> get props => [tv];
}

class LoadWatchlistStatus extends TvDetailEvent {
  final int id;

  LoadWatchlistStatus(this.id);

  @override
  List<Object?> get props => [id];
}

class ResetMessage extends TvDetailEvent {}
