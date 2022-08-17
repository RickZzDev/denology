import 'package:devnology/model/product_list_model.dart';
import 'package:devnology/view/widget/product_card.dart';
import 'package:devnology/viewmodel/home_state.dart';
import 'package:devnology/viewmodel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChartItems extends StatelessWidget {
  const ChartItems({Key? key, required this.products}) : super(key: key);

  final ProductItemList products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
        child: Column(
          children: [
            const Text(
              "Pedidos incluidos: ",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            BlocBuilder<HomeViewModel, HomeState>(
              builder: (context, state) {
                if (products.shoppedItems.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                        "Você ainda não adicionou nenhum pedido no carrinho :("),
                  );
                }

                return Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: products.shoppedItems.length,
                    itemBuilder: (context, index) => ProductCard(
                        item: products.shoppedItems[index],
                        shouldShowShopOption: true),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
