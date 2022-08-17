import 'package:devnology/view/chart_view.dart';
import 'package:devnology/viewmodel/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShopIconButton extends StatelessWidget {
  const ShopIconButton({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => BlocProvider.value(
            value: homeViewModel,
            child: ChartItems(
              products: homeViewModel.localProducstVariable,
            ),
          ),
        ),
      ),
      icon: const Icon(
        Icons.shopping_cart_outlined,
      ),
    );
  }
}
