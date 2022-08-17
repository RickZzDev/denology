import 'package:devnology/model/product_list_model.dart';
import 'package:devnology/view/chart_view.dart';
import 'package:devnology/view/details_view.dart';
import 'package:devnology/view/widget/favorited_icon_button.dart';
import 'package:devnology/view/widget/product_card.dart';
import 'package:devnology/view/widget/shimmers/product_card_shimmer.dart';
import 'package:devnology/view/widget/shimmers/shop_icon_shimmer.dart';
import 'package:devnology/view/widget/shop_icon_button.dart';
import 'package:devnology/viewmodel/home_state.dart';
import 'package:devnology/viewmodel/home_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class HomeView extends StatefulWidget {
  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late HomeViewModel homeViewModel;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      homeViewModel = BlocProvider.of<HomeViewModel>(context)..getItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          BlocBuilder<HomeViewModel, HomeState>(
              builder: (context, state) => state is HomeInitialState
                  ? const ShopIconShimmer()
                  : Row(
                      children: [
                        FavoritedIconButton(homeViewModel: homeViewModel),
                        const SizedBox(
                          width: 8,
                        ),
                        ShopIconButton(homeViewModel: homeViewModel),
                      ],
                    ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocConsumer<HomeViewModel, HomeState>(
          listener: (context, state) {
            if (state is ChangeItemShopList) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      state.isItemAdded ? "Item adicionado" : "Item removido"),
                ),
              );
            }
          },
          buildWhen: (previous, current) => current is HomeProductsLoaded,
          builder: (context, state) {
            return Column(
              children: [
                TextField(
                  onChanged: (value) => homeViewModel.searchItem(value),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                    ),
                    hintText: 'Enter a search term',
                  ),
                ),
                state is HomeProductsLoaded
                    ? Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 8,
                          ),
                          itemCount: state.productModel.productList.length,
                          itemBuilder: (context, index) {
                            var item = state.productModel.productList[index];
                            return GestureDetector(
                              onTap: () => Navigator.of(context).push(
                                CupertinoPageRoute(
                                  builder: (context) => BlocProvider.value(
                                    value: homeViewModel,
                                    child: DetailsView(item: item),
                                  ),
                                ),
                              ),
                              child: ProductCard(
                                item: item,
                                shouldShowShopOption: true,
                              ),
                            );
                          },
                        ),
                      )
                    : Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) => const SizedBox(
                            height: 8,
                          ),
                          itemCount: 12,
                          itemBuilder: (context, index) => Shimmer.fromColors(
                            baseColor: const Color.fromARGB(255, 209, 210, 210),
                            highlightColor:
                                const Color.fromARGB(255, 237, 237, 237),
                            child: const ProductCardShimmer(),
                          ),
                        ),
                      )
              ],
            );
          },
        ),
      ),
    );
  }
}
