import 'package:equatable/equatable.dart';

abstract class GetTopRatedTvEvent extends Equatable {
  const GetTopRatedTvEvent();

  @override
  List<Object> get props => [];
}

class FetchTopRatedTv extends GetTopRatedTvEvent {}
