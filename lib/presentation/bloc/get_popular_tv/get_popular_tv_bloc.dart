import 'package:ditonton/domain/usecases/get_popular_tv.dart';
import 'package:ditonton/presentation/bloc/get_popular_tv/get_popular_tv_event.dart';
import 'package:ditonton/presentation/bloc/get_popular_tv/get_popular_tv_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPopularTvBloc extends Bloc<GetPopularTvEvent, GetPopularTvState> {
  final GetPopularTv _getPopularTv;

  GetPopularTvBloc(this._getPopularTv) : super(GetPopularTvLoading()) {
    on<FetchPopularTv>(
      (event, emit) async {
        emit(GetPopularTvLoading());
        final result = await _getPopularTv.execute();

        result.fold(
          (failure) {
            emit(GetPopularTvError(failure.message));
          },
          (data) {
            emit(GetPopularTvHasData(data));
          },
        );
      },
    );
  }
}
