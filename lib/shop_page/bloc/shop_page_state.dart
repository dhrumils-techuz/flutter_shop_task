part of 'shop_page_bloc.dart';

@immutable
abstract class ShopPageState {}

class ShopPageInitial extends ShopPageState {}

class ShopPageNavigateToProductPage extends ShopPageState {}

class ShopPageLoading extends ShopPageState {}

class ShopPageLoadedSuccess extends ShopPageState {}
