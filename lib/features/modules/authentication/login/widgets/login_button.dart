import 'package:crm_gt/features/modules/authentication/login/cubit/login_cubit.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:crm_gt/widgets/button_custom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginButton extends BaseWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<LoginCubit>();

    return ButtonCustom(
      onPressed: cubit.onTapLogin,
      title: "ĐĂNG NHẬP",
      textSize: 27,
      margin: const EdgeInsets.only(top: 16, left: 40, right: 40),
    );
  }
}
