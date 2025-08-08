import 'package:crm_gt/presentations/modules/authentication/profile/cubit/profile_cubit.dart';
import 'package:crm_gt/presentations/modules/authentication/profile/cubit/profile_state.dart';
import 'package:crm_gt/presentations/modules/authentication/profile/widgets/app_bar_builder.dart';
import 'package:crm_gt/presentations/modules/authentication/profile/widgets/profile_body.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileView extends BaseWidget {
  const ProfileView({super.key});

  @override
  onInit(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileCubit>().getCurrentUser();
    });
    return super.onInit(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        // Khi có thay đổi user info (ví dụ: sau khi đổi tên), tự động refresh
        if (state.name != null) {
          // Có thể thêm logic khác nếu cần
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: buildAppBar(context),
        body: buildProfileBody(context),
      ),
    );
  }
}
