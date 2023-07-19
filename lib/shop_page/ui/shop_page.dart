import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_flutter_task/data/data.dart';
import 'package:new_flutter_task/home/bloc/home_bloc.dart';
import 'package:new_flutter_task/product_page/ui/product_page.dart';
import 'package:new_flutter_task/shop_page/bloc/shop_page_bloc.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({
    super.key,
    required this.products,
    required this.bloc,
    required this.pageNumber,
    // required this.status
  });

  final List<Data> products;
  final HomeBloc bloc;
  final int pageNumber;
  // final String status;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final ScrollController _scrollController = ScrollController();
  final ShopPageBloc shopPageBloc = ShopPageBloc();

  void loadMoreData() {
    shopPageBloc.add(ShopPageProductLoadingEvent(bloc: widget.bloc));
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        loadMoreData();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ShopPageBloc shopPageBloc = ShopPageBloc();
    return Scaffold(
      body: BlocConsumer<ShopPageBloc, ShopPageState>(
        bloc: shopPageBloc,
        listener: (context, state) {
          if (state is ShopPageNavigateToProductPage) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ProductPage(),
              ),
            );
          }
        },
        builder: (context, state) {
          print(shopPageBloc.state.runtimeType);
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    final item = widget.products[index];

                    return InkWell(
                      onTap: () {
                        shopPageBloc.add(ProductCardClickedEvent(item));
                      },
                      child: Column(
                        children: [
                          Card(
                            child: ListTile(
                              leading: Image.network(
                                item.thumbnail,
                                width: 50,
                                height: 250,
                                fit: BoxFit.cover,
                              ),
                              title: Text(item.title),
                              subtitle: Text(item.description),
                              trailing: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text('Price: \$ ${item.price}'),
                                  Text('Discount: ${item.discountPercentage}%'),
                                  Text('Rating: ${item.rating}'),
                                  Text('Stock: ${item.stock}'),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              // if (widget.status == 'shop' &&
              //     ((_scrollController.position.pixels ==
              //         _scrollController.position.maxScrollExtent)))
              //   const Padding(
              //     padding: EdgeInsets.all(16.0),
              //     child: Center(
              //       child: CircularProgressIndicator(),
              //     ),
              //   ),
              (widget.bloc.state.runtimeType is ShopToHomeErrorState)
                  ? const AlertDialog(
                      content: Text('Cannot Load Data'),
                    )
                  : const SizedBox()
            ],
          );
        },
      ),
    );
  }
}
