part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadedSuccessState extends HomeState {
  final List<Data> products;
  final int pageNumber;
  // final String status;

  HomeLoadedSuccessState(
      {required this.pageNumber,
      // required this.status,
      required this.products});
}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {}

class ShopToHomeErrorState extends HomeState {}

class ShopPageLoadingState extends HomeState {}
