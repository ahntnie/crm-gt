import 'package:crm_gt/presentations/modules/home/cubit/home/home_cubit.dart';
import 'package:crm_gt/presentations/modules/home/widgets/add_dir_dialog.dart';
import 'package:crm_gt/presentations/modules/home/widgets/add_member_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void showAddMemberDialog(BuildContext context) {
  final cubit = context.read<HomeCubit>();
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    pageBuilder: (context, animation, secondaryAnimation) => ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ),
      child: AddMemberDialog(cubit: cubit),
    ),
  );
}

void showAddDirDialog(BuildContext context) {
  final cubit = context.read<HomeCubit>();
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    pageBuilder: (context, animation, secondaryAnimation) => ScaleTransition(
      scale: CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      ),
      child: AddDirDialog(cubit: cubit),
    ),
  );
}
