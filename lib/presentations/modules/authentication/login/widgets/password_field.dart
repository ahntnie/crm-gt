import 'package:crm_gt/presentations/modules/authentication/login/cubit/login_cubit.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:crm_gt/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordField extends BaseWidget {
  const PasswordField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<LoginCubit>();

    return TextsField(
      onChanged: cubit.passwordChanged,
      controller: cubit.passwordController,
      labelText: 'Mật khẩu',
      isPasswordFields: true,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (_) => cubit.onTapLogin(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Xin hãy nhập mật khẩu';
        }
        return null;
      },
    );
  }
}
