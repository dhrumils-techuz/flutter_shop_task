import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:new_flutter_task/data/data.dart';
import 'package:new_flutter_task/home/bloc/home_bloc.dart';
import 'package:new_flutter_task/product_page/ui/product_page.dart';
import 'package:new_flutter_task/shop_page/bloc/shop_page_bloc.dart';

class ShopPage extends StatefulWidget {
  const ShopPage(
      {super.key,
      required this.products,
      required this.bloc,
      required this.pageNumber});

  final List<Data> products;
  final HomeBloc bloc;
  final int pageNumber;

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc = widget.bloc;
    final ShopPageBloc shopPageBloc = ShopPageBloc();
    return BlocConsumer<ShopPageBloc, ShopPageState>(
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
        switch (state.runtimeType) {}
        return ListView.builder(
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
                  (index == (widget.products.length) - 1)
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                                onPressed: () {
                                  homeBloc
                                      .add(HomeInitialEvent(state: 'before'));
                                },
                                icon:
                                    const Icon(Icons.navigate_before_outlined)),
                            Text('${widget.pageNumber + 2} off 4'),
                            IconButton(
                                onPressed: () {
                                  homeBloc.add(HomeInitialEvent(state: 'next'));
                                },
                                icon: const Icon(Icons.navigate_next_outlined)),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
