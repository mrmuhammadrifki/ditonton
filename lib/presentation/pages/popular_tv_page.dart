import 'package:ditonton/presentation/bloc/get_popular_tv/get_popular_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/get_popular_tv/get_popular_tv_event.dart';
import 'package:ditonton/presentation/bloc/get_popular_tv/get_popular_tv_state.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv';

  @override
  _PopularTvPageState createState() => _PopularTvPageState();
}

class _PopularTvPageState extends State<PopularTvPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<GetPopularTvBloc>().add(
            FetchPopularTv(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetPopularTvBloc, GetPopularTvState>(
          builder: (context, state) {
            if (state is GetPopularTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetPopularTvHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.result[index];
                  return TvCard(tv);
                },
                itemCount: state.result.length,
              );
            } else if (state is GetPopularTvError) {
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
