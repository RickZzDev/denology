import 'package:devnology/model/product_list_model.dart';
import 'package:devnology/viewmodel/home_state.dart';
import 'package:devnology/viewmodel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCard extends StatelessWidget {
  const ProductCard(
      {Key? key, required this.item, required this.shouldShowShopOption})
      : super(key: key);

  final ProducstItem item;
  final bool shouldShowShopOption;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              item.gallery!.first,
              loadingBuilder: (BuildContext context, Widget child,
                  ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                }
                return SizedBox(
                  width: 80,
                  child: Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              width: 80,
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name!,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  !item.hasDiscount
                      ? Text(
                          "R\$ ${item.price!}",
                          style: const TextStyle(fontSize: 12),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "R\$ ${item.price!}",
                              style: TextStyle(
                                  color: Colors.red[400],
                                  decoration: TextDecoration.lineThrough),
                            ),
                            Text("R\$ ${item.discountedValue}")
                          ],
                        )
                ],
              ),
            ),
            Column(
              children: [
                BlocBuilder<HomeViewModel, HomeState>(
                  buildWhen: (previous, current) => current is FavoritedItem,
                  builder: (context, state) => IconButton(
                    onPressed: () => context.read<HomeViewModel>().favorite(
                          item,
                        ),
                    icon: Icon(
                      Icons.favorite,
                      color: item.isFavorite ? Colors.red : Colors.black,
                    ),
                  ),
                ),
                shouldShowShopOption
                    ? BlocBuilder<HomeViewModel, HomeState>(
                        builder: (context, state) => IconButton(
                            onPressed: () =>
                                context.read<HomeViewModel>().addToShop(item),
                            icon: Icon(
                              item.isShopped
                                  ? Icons.shopping_cart
                                  : Icons.add_shopping_cart_outlined,
                            )),
                      )
                    : SizedBox()
              ],
            )
          ],
        ),
      ),
    );
  }
}
