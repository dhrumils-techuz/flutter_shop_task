part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class HomeInitialEvent extends HomeEvent {
  HomeInitialEvent({required this.state});
  final String state;
}

class HomeErrorEvent extends HomeEvent {}
