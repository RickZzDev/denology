import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:devnology/model/product_list_model.dart';
import 'package:devnology/model/reviewd_items_model.dart';
import 'package:devnology/viewmodel/home_state.dart';
import 'package:devnology/viewmodel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shared_preferences/shared_preferences.dart';

class DetailsView extends StatefulWidget {
  ProducstItem item;
  DetailsView({Key? key, required this.item}) : super(key: key);

  @override
  State<DetailsView> createState() => _DetailsViewState();
}

class _DetailsViewState extends State<DetailsView> {
  TextEditingController reviewController = TextEditingController();

  Future<void> saveReview() async {
    widget.item.review.add(reviewController.text);
    await context.read<HomeViewModel>().updateReviewsInCache(
        ReviewdItems(id: widget.item.id, reviews: widget.item.review));
    _resetReviewController();
  }

  void _resetReviewController() {
    reviewController.text = "";
  }

  void _showDialog() => showDialog(
        context: context,
        builder: (context) => Dialog(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Deixe seu review: ",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              TextField(
                maxLines: null,
                controller: reviewController,
                decoration: const InputDecoration(hintText: "Escreva aqui...."),
              ),
              const SizedBox(
                height: 8,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  saveReview();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.save),
                label: const Text("Enviar"),
              )
            ],
          ),
        )),
      );

  @override
  Widget build(BuildContext _) {
    return Builder(builder: (context) {
      return BlocConsumer<HomeViewModel, HomeState>(
        listener: (context, state) {
          if (state is ReviewAdded) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Review adicionado")));
          }
        },
        buildWhen: (previous, current) => current is ReviewAdded,
        builder: (context, state) => Scaffold(
          appBar: AppBar(
            title: Text(widget.item.name!),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showDialog(),
            child: const Icon(Icons.comment),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                        enlargeCenterPage: true, viewportFraction: 0.7),
                    items: widget.item.gallery!
                        .map((image) => Container(
                              child: Center(
                                child: Image.network(image),
                              ),
                            ))
                        .toList(),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Divider(
                          thickness: 2,
                        ),
                        const Text(
                          "Descrição: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(widget.item.description!),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "Material: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Text(widget.item.details.material),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text(
                          "Reviews: ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        widget.item.review.isNotEmpty
                            ? ListView.builder(
                                itemCount: widget.item.review.length,
                                itemBuilder: (context, index) => ReviewCard(
                                    review: widget.item.review[index]),
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                              )
                            : const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8.0),
                                child: Text(
                                    "Produto ainda não recebeu nenhuma avaliação :("),
                              )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class ReviewCard extends StatelessWidget {
  const ReviewCard({Key? key, required this.review}) : super(key: key);
  final String review;
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints:
          BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const CircleAvatar(
                child: Icon(Icons.person),
              ),
              const SizedBox(
                width: 8,
              ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [Text(review)],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
