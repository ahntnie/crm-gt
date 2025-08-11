import 'package:crm_gt/features/modules/messege/components/messege_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/messege_cubit.dart';

class MessegeScreen extends StatelessWidget {
  const MessegeScreen({super.key, required this.idDir});
  final String idDir;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessegeCubit(),
      child: MessegeView(
        idDir: idDir,
      ),
    );
  }
}
