import 'package:equatable/equatable.dart';

abstract class TvSearchEvent extends Equatable {
  const TvSearchEvent();

  @override
  List<Object> get props => [];
}

class OnTvQueryChanged extends TvSearchEvent {
  final String query;

  OnTvQueryChanged(this.query);

  @override
  List<Object> get props => [query];
}
