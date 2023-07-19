import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:new_flutter_task/data/data.dart';
import 'package:new_flutter_task/home/bloc/home_bloc.dart';

part 'shop_page_event.dart';
part 'shop_page_state.dart';

class ShopPageBloc extends Bloc<ShopPageEvent, ShopPageState> {
  ShopPageBloc() : super(ShopPageInitial()) {
    on<ShopPageEvent>((event, emit) {});
    on<ProductCardClickedEvent>(productCardClickedEvent);
    on<ShopPageProductLoadingEvent>(shopPageProductLoadingEvent);
  }

  FutureOr<void> productCardClickedEvent(
      ProductCardClickedEvent event, Emitter<ShopPageState> emit) {
    products.add(event.product);

    emit(ShopPageNavigateToProductPage());
  }

  FutureOr<void> shopPageProductLoadingEvent(
      ShopPageProductLoadingEvent event, Emitter<ShopPageState> emit) {
    emit(ShopPageLoading());
    final HomeBloc homeBloc = event.bloc;
    homeBloc.add(HomeInitialEvent(state: 'ShopPage'));
  }
}
