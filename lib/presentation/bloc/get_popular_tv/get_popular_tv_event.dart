import 'package:equatable/equatable.dart';

abstract class GetPopularTvEvent extends Equatable {
  const GetPopularTvEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTv extends GetPopularTvEvent {}
