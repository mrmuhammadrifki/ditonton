import 'package:ditonton/presentation/bloc/get_top_rated_tv/get_top_rated_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_tv/get_top_rated_tv_event.dart';
import 'package:ditonton/presentation/bloc/get_top_rated_tv/get_top_rated_tv_state.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopRatedTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/top-rated-tv';

  @override
  _TopRatedTvPageState createState() => _TopRatedTvPageState();
}

class _TopRatedTvPageState extends State<TopRatedTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<GetTopRatedTvBloc>().add(
            FetchTopRatedTv(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Rated Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetTopRatedTvBloc, GetTopRatedTvState>(
          builder: (context, state) {
            if (state is GetTopRatedTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetTopRatedTvHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is GetTopRatedTvError) {
              return Center(
                key: Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return Center(
                child: Text('No data available'),
              );
            }
          },
        ),
      ),
    );
  }
}
