import 'package:devnology/view/chart_view.dart';
import 'package:devnology/viewmodel/home_state.dart';
import 'package:devnology/viewmodel/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
    required this.homeViewModel,
  }) : super(key: key);

  final HomeViewModel homeViewModel;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        BlocBuilder<HomeViewModel, HomeState>(
          builder: (context, state) => state is HomeInitialState
              ? Shimmer.fromColors(
                  baseColor: const Color.fromARGB(255, 209, 210, 210),
                  highlightColor: const Color.fromARGB(255, 237, 237, 237),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.shopping_cart_outlined),
                  ),
                )
              : IconButton(
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
                ),
        )
      ],
    );
  }
}
