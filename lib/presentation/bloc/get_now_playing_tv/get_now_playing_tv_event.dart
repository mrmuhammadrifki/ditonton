import 'package:equatable/equatable.dart';

abstract class GetNowPlayingTvEvent extends Equatable {
  const GetNowPlayingTvEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTv extends GetNowPlayingTvEvent {}
