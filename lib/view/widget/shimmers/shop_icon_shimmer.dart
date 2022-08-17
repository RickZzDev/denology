import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShopIconShimmer extends StatelessWidget {
  const ShopIconShimmer(
      {Key? key, this.iconData = Icons.shopping_cart_outlined})
      : super(key: key);

  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: const Color.fromARGB(255, 209, 210, 210),
        highlightColor: const Color.fromARGB(255, 237, 237, 237),
        child: Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.favorite_outline),
            ),
            const SizedBox(
              width: 8,
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.shopping_cart_outlined),
            ),
          ],
        ));
  }
}
