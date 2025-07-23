import 'package:crm_gt/presentations/modules/home/cubit/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home View'),
      ),
      body: Center(
        child: Text(
          'Welcome to Home View',
          style: Theme.of(context).textTheme.headline4,
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            cubit.getAllDir();
          },
          child: const Icon(Icons.add)),
    );
  }
}
