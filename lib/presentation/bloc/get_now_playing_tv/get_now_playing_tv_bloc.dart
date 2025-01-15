import 'package:ditonton/domain/usecases/get_now_playing_tv.dart';
import 'package:ditonton/presentation/bloc/get_now_playing_tv/get_now_playing_tv_event.dart';
import 'package:ditonton/presentation/bloc/get_now_playing_tv/get_now_playing_tv_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetNowPlayingTvBloc
    extends Bloc<GetNowPlayingTvEvent, GetNowPlayingTvState> {
  final GetNowPlayingTv _getNowPlayingTv;

  GetNowPlayingTvBloc(this._getNowPlayingTv) : super(GetNowPlayingTvLoading()) {
    on<FetchNowPlayingTv>(
      (event, emit) async {
        emit(GetNowPlayingTvLoading());
        final result = await _getNowPlayingTv.execute();

        result.fold(
          (failure) {
            emit(GetNowPlayingTvError(failure.message));
          },
          (data) {
            emit(GetNowPlayingTvHasData(data));
          },
        );
      },
    );
  }
}
