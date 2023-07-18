part of 'shop_page_bloc.dart';

@immutable
abstract class ShopPageEvent {}

class ProductCardClickedEvent extends ShopPageEvent {
  final Data product;

  ProductCardClickedEvent(this.product);
}
