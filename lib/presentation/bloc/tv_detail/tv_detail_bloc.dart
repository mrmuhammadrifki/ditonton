import 'package:ditonton/domain/usecases/get_tv_detail.dart';
import 'package:ditonton/domain/usecases/get_tv_recommendations.dart';
import 'package:ditonton/domain/usecases/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/remove_watchlist_tv.dart';
import 'package:ditonton/domain/usecases/save_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_detail/tv_detail_state.dart';
import 'package:ditonton/utils/state_enum.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvDetailBloc extends Bloc<TvDetailEvent, TvDetailState> {
  final GetTvDetail getTvDetail;
  final GetTvRecommendations getTvRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlistTv saveWatchlist;
  final RemoveWatchlistTv removeWatchlist;

  TvDetailBloc({
    required this.getTvDetail,
    required this.getTvRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(TvDetailState.initial()) {
    on<FetchTvDetail>((event, emit) async {
      emit(state.copyWith(tvDetailState: StateEnum.Loading));

      final detailResult = await getTvDetail.execute(event.id);
      final recommendationResult = await getTvRecommendations.execute(event.id);

      detailResult.fold(
        (failure) async {
          emit(state.copyWith(
            tvDetailState: StateEnum.Error,
            message: failure.message,
            tvRecommendationsState: StateEnum.Loading,
          ));
          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                tvRecommendationsState: StateEnum.Error,
                message: failure.message,
              ));
            },
            (tv) {
              emit(state.copyWith(
                tvRecommendationsState: StateEnum.HasData,
                tvRecommendations: tv,
              ));
            },
          );
        },
        (tv) async {
          emit(state.copyWith(
            tvRecommendationsState: StateEnum.Loading,
            tvDetail: tv,
            tvDetailState: StateEnum.HasData,
          ));
          recommendationResult.fold(
            (failure) {
              emit(state.copyWith(
                tvRecommendationsState: StateEnum.Error,
                message: failure.message,
              ));
            },
            (tv) {
              emit(state.copyWith(
                tvRecommendationsState: StateEnum.HasData,
                tvRecommendations: tv,
              ));
            },
          );
          add(LoadWatchlistStatus(event.id));
        },
      );
    });

    on<AddToWatchlist>((event, emit) async {
      final result = await saveWatchlist.execute(event.tv);

      result.fold((failure) {
        emit(state.copyWith(message: failure.message));
      }, (successMessage) {
        emit(state.copyWith(message: successMessage));
      });
      add(LoadWatchlistStatus(event.tv.id));
    });
    on<RemoveFromWatchlist>((event, emit) async {
      final result = await removeWatchlist.execute(event.tv);

      result.fold((failure) {
        emit(state.copyWith(message: failure.message));
      }, (successMessage) {
        emit(state.copyWith(message: successMessage));
      });
      add(LoadWatchlistStatus(event.tv.id));
    });
    on<LoadWatchlistStatus>((event, emit) async {
      final result = await getWatchListStatus.execute(event.id);
      emit(state.copyWith(isAddedToWatchlist: result));
    });
    on<ResetMessage>((event, emit) {
      emit(state.copyWith(message: ''));
    });
  }
}
