import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tv/get_watchlist_tv_bloc.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tv/get_watchlist_tv_event.dart';
import 'package:ditonton/presentation/bloc/get_watchlist_tv/get_watchlist_tv_state.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTvPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv';

  @override
  _WatchlistTvPageState createState() => _WatchlistTvPageState();
}

class _WatchlistTvPageState extends State<WatchlistTvPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => context.read<GetWatchlistTvBloc>().add(
            FetchWatchlistTv(),
          ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    Future.microtask(
      () => context.read<GetWatchlistTvBloc>().add(
            FetchWatchlistTv(),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Watchlist Tv Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<GetWatchlistTvBloc, GetWatchlistTvState>(
          builder: (context, state) {
            if (state is GetWatchlistTvLoading) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is GetWatchlistTvHasData) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final movie = state.result[index];
                  return TvCard(movie);
                },
                itemCount: state.result.length,
              );
            } else if (state is GetWatchlistTvError) {
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
