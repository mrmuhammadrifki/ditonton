import 'package:ditonton/domain/usecases/get_top_rated_tv.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_tv/get_top_rated_tv_event.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_tv/get_top_rated_tv_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetTopRatedTvBloc extends Bloc<GetTopRatedTvEvent, GetTopRatedTvState> {
  final GetTopRatedTv _getTopRatedTv;

  GetTopRatedTvBloc(this._getTopRatedTv) : super(GetTopRatedTvLoading()) {
    on<FetchTopRatedTv>(
      (event, emit) async {
        emit(GetTopRatedTvLoading());
        final result = await _getTopRatedTv.execute();

        result.fold(
          (failure) {
            emit(GetTopRatedTvError(failure.message));
          },
          (data) {
            emit(GetTopRatedTvHasData(data));
          },
        );
      },
    );
  }
}
