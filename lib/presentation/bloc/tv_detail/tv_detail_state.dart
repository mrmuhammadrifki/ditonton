import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/utils/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';

class TvDetailState {
  final TvDetail tvDetail;
  final StateEnum tvDetailState;
  final List<Tv> tvRecommendations;
  final StateEnum tvRecommendationsState;
  final bool isAddedToWatchlist;
  final String message;

  TvDetailState({
    required this.tvDetail,
    required this.tvDetailState,
    required this.tvRecommendations,
    required this.tvRecommendationsState,
    required this.isAddedToWatchlist,
    required this.message,
  });

  factory TvDetailState.initial() => TvDetailState(
        tvDetail: TvDetail(
          adult: false,
          backdropPath: 'backdropPath',
          genres: [Genre(id: 1, name: 'Action')],
          id: 1,
          originalName: 'originalName',
          overview: 'overview',
          posterPath: 'posterPath',
          firstAirDate: 'firstAirDate',
          name: 'name',
          voteAverage: 1,
          voteCount: 1,
        ),
        tvDetailState: StateEnum.Empty,
        tvRecommendations: [],
        tvRecommendationsState: StateEnum.Empty,
        isAddedToWatchlist: false,
        message: '',
      );

  TvDetailState copyWith({
    TvDetail? tvDetail,
    StateEnum? tvDetailState,
    List<Tv>? tvRecommendations,
    StateEnum? tvRecommendationsState,
    bool? isAddedToWatchlist,
    String? message,
  }) {
    return TvDetailState(
      tvDetail: tvDetail ?? this.tvDetail,
      tvDetailState: tvDetailState ?? this.tvDetailState,
      tvRecommendations: tvRecommendations ?? this.tvRecommendations,
      tvRecommendationsState:
          tvRecommendationsState ?? this.tvRecommendationsState,
      isAddedToWatchlist: isAddedToWatchlist ?? this.isAddedToWatchlist,
      message: message ?? this.message,
    );
  }
}
