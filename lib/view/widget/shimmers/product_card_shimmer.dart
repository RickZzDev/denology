import 'package:devnology/model/product_list_model.dart';
import 'package:devnology/viewmodel/home_state.dart';
import 'package:devnology/viewmodel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 80,
              child: Center(),
            ),
            const SizedBox(
              width: 5,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "",
                        style: TextStyle(
                            color: Colors.red[400],
                            decoration: TextDecoration.lineThrough),
                      ),
                      const Text("")
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
                    onPressed: () {},
                    icon: Icon(
                      Icons.favorite,
                    ),
                  ),
                ),
                IconButton(
                    onPressed: () => {}, icon: const Icon(Icons.shopping_cart))
              ],
            )
          ],
        ),
      ),
    );
  }
}
