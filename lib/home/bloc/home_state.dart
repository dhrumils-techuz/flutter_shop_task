part of 'home_bloc.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoadedSuccessState extends HomeState {
  final List<Data> products;

  HomeLoadedSuccessState({required this.products});
}

class HomeLoadingState extends HomeState {}

class HomeErrorState extends HomeState {}
