import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_flutter_task/data/data.dart';
import 'package:new_flutter_task/home/bloc/home_bloc.dart';
import 'package:new_flutter_task/shop_page/ui/shop_page.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  final HomeBloc homeBloc = HomeBloc();
  dynamic response;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    homeBloc.add(HomeInitialEvent(state: 'initial'));
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      throw Exception('Some Error Occured  $e');
    }
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listener: (context, state) {},
      builder: (context, state) {
        switch (state.runtimeType) {
          case HomeLoadingState:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          case HomeLoadedSuccessState:
            final successState = state as HomeLoadedSuccessState;
            return Scaffold(
              appBar: AppBar(
                title: const Text(
                  'Welcome to Shopping World',
                ),
              ),
              body: (_connectionStatus == ConnectivityResult.none)
                  ? AlertDialog(
                      actions: [
                        const Text('Please Connect to the internet'),
                        TextButton(
                          onPressed: () {
                            homeBloc.add(HomeInitialEvent(state: 'reload'));
                          },
                          child: const Text('Retry'),
                        ),
                        TextButton(
                          onPressed: () {
                            exit(0);
                          },
                          child: const Text('Close'),
                        ),
                      ],
                    )
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.fromARGB(255, 4, 7, 35),
                            Color.fromARGB(255, 7, 39, 51),
                          ],
                        ),
                      ),
                      child: (ShopPage(
                        products: successState.products,
                        bloc: homeBloc,
                        pageNumber: successState.pageNumber,
                        // status: successState.status,
                      )),
                    ),
            );
          case HomeErrorState:
            return Scaffold(
                body: Center(
                    child: AlertDialog(actions: [
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  const Padding(
                    padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: Text(
                        'Error! No Data Found. Please Refresh the app and start again'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        homeBloc.add(HomeInitialEvent(state: 'before'));
                      },
                      child: const Text('Go Back'))
                ],
              ),
            ])));

          default:
            return const Center(
              child: Text('Some Error Occured'),
            );
        }
      },
    );
  }
}
