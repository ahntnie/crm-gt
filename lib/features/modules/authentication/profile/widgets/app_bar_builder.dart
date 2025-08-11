import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/features/routes.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget buildAppBar(BuildContext context) {
  return AppBar(
    leading: IconButton(
      icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.mono0),
      onPressed: () {
        AppNavigator.pop();
      },
    ),
    backgroundColor: AppColors.cempedak101,
    centerTitle: true,
    title: const Text(
      'Hồ sơ',
      style: TextStyle(
        color: AppColors.mono0,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
  );
}
