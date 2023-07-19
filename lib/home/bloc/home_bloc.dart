import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:new_flutter_task/data/data.dart';
import 'package:http/http.dart' as http;
part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeEvent>((event, emit) {});
    on<HomeInitialEvent>(homeInitalEvent);
    on<HomeErrorEvent>(homeErrorEvent);
  }

  FutureOr<void> homeInitalEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoadingState());

    List<Data> products = [];

    if (event.state == 'next' || event.state == 'initial') {
      skipCounter++;
    } else if (event.state == 'before') {
      skipCounter--;
      if (skipCounter == -1) {
        emit(HomeErrorState());
        return;
      }
    }
    var abc = skipCounter * skip;

    final queryParams = {'limit': '25', 'skip': abc.toString()};

    final url = Uri.http(
      'dummyjson.com',
      'products',
      queryParams,
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final dynamic responseData = json.decode(response.body);
      if ((responseData['products'] as List).isEmpty) {
        emit(HomeErrorState());
        return;
      }

      List<dynamic> productList = responseData['products'];
      products = productList
          .map((item) => Data(
                index: item['id'],
                title: item['title'],
                description: item['description'],
                price: item['price'],
                discountPercentage: item['discountPercentage'],
                rating: item['rating'],
                stock: item['stock'],
                brand: item['brand'],
                category: item['category'],
                thumbnail: item['thumbnail'],
                images: item['images'],
              ))
          .toList();
    } else {
      throw Exception('Failed to fetch data');
    }
    emit(HomeLoadedSuccessState(
        products: products, pageNumber: skipCounter - 1));
  }

  FutureOr<void> homeErrorEvent(HomeErrorEvent event, Emitter<HomeState> emit) {
    emit(HomeErrorState());
  }
}
