import 'package:crm_gt/presentations/modules/authentication/profile/components/profile_view.dart';
import 'package:crm_gt/presentations/modules/authentication/profile/cubit/profile_cubit.dart';
import 'package:crm_gt/presentations/modules/home/cubit/home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProfileCubit()..getCurrentUser(),
        ),
        BlocProvider(
          create: (_) => HomeCubit(),
        ),
      ],
      child: const ProfileView(),
    );
  }
}
