import 'package:devnology/repository/products_repository.dart';
import 'package:devnology/service/home_service.dart';
import 'package:devnology/view/home_view.dart';
import 'package:devnology/viewmodel/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    MaterialApp(
      home: BlocProvider(
        create: (context) =>
            HomeViewModel(RestHomeService(), ProductsRepository()),
        child: HomeView(),
      ),
    ),
  );
}
