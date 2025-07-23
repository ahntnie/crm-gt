import 'package:crm_gt/presentations/modules/authentication/login/cubit/login_cubit.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:crm_gt/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserNameField extends BaseWidget {
  const UserNameField({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<LoginCubit>();

    return TextsField(
      onChanged: cubit.usernameChanged,
      controller: cubit.usernameController,
      labelText: 'Email / Số điện thoại',
      isPasswordFields: false,
      textInputAction: TextInputAction.done,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Xin hãy nhập email / số điện thoại';
        }
        return null;
      },
    );
  }
}
