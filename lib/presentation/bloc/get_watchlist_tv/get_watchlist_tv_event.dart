import 'package:equatable/equatable.dart';

abstract class GetWatchlistTvEvent extends Equatable {
  const GetWatchlistTvEvent();

  @override
  List<Object> get props => [];
}

class FetchWatchlistTv extends GetWatchlistTvEvent {}
