import 'package:crm_gt/presentations/modules/authentication/login/cubit/login_cubit.dart';
import 'package:crm_gt/presentations/modules/authentication/login/widgets/login_button.dart';
import 'package:crm_gt/presentations/modules/authentication/login/widgets/password_field.dart';
import 'package:crm_gt/presentations/modules/authentication/login/widgets/username_field.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginView extends BaseWidget {
  const LoginView({super.key});
  @override
  onInit(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LoginCubit>().checkTokenLogin();
    });
    return super.onInit(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LoginCubit, LoginState>(
        builder: (context, state) {
          return const Form(
              child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// INPUT
                  SizedBox(height: 18),
                  UserNameField(),
                  SizedBox(height: 24),
                  PasswordField(),
                  SizedBox(height: 12),
                  LoginButton(),
                ]),
          ));
        },
      ),
    );
  }
}
