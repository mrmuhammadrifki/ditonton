import 'package:ditonton/domain/usecases/get_watchlist_tv.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tv/get_watchlist_tv_event.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tv/get_watchlist_tv_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetWatchlistTvBloc
    extends Bloc<GetWatchlistTvEvent, GetWatchlistTvState> {
  final GetWatchlistTv _getWatchlistTv;

  GetWatchlistTvBloc(this._getWatchlistTv) : super(GetWatchlistTvLoading()) {
    on<FetchWatchlistTv>(
      (event, emit) async {
        emit(GetWatchlistTvLoading());
        final result = await _getWatchlistTv.execute();

        result.fold(
          (failure) {
            emit(GetWatchlistTvError(failure.message));
          },
          (data) {
            emit(GetWatchlistTvHasData(data));
          },
        );
      },
    );
  }
}
