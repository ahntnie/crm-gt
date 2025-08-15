import 'package:crm_gt/features/modules/progress/components/progress_view.dart';
import 'package:crm_gt/features/modules/progress/cubit/progress_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProgressScreen extends StatelessWidget {
  final String dirId;

  const ProgressScreen({
    super.key,
    required this.dirId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProgressCubit()..loadProgressByDirId(dirId),
      child: ProgressView(dirId: dirId),
    );
  }
}
