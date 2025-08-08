import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/presentations/modules/home/cubit/home/home_cubit.dart';
import 'package:crm_gt/presentations/modules/home/widgets/dialog_utils.dart';
import 'package:flutter/material.dart';

Widget? buildFloatingActionButton(BuildContext context, HomeCubit cubit) {
  if (cubit.state.currentDir != null) return null;
  return FloatingActionButton.extended(
    backgroundColor: AppColors.cempedak101,
    foregroundColor: AppColors.mono0,
    onPressed: () => showAddDirDialog(context),
    icon: const Icon(Icons.add),
    label: const Text('Thêm thư mục'),
    elevation: 4,
  );
}
