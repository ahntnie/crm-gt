import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/presentations/modules/authentication/login/cubit/login_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PasswordField extends StatelessWidget {
  const PasswordField({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<LoginCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mật khẩu',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade700,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: TextFormField(
            controller: cubit.passwordController,
            onChanged: cubit.passwordChanged,
            obscureText: !cubit.state.isPasswordVisible,
            textInputAction: TextInputAction.done,
            onFieldSubmitted: (_) => cubit.onTapLogin(),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Nhập mật khẩu của bạn',
              hintStyle: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 16,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.all(12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.cempedak101.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.lock,
                  color: AppColors.cempedak101,
                  size: 20,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  cubit.state.isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade600,
                ),
                onPressed: () => cubit.togglePasswordVisibility(),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                  color: AppColors.cempedak101,
                  width: 2,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red.shade400,
                  width: 2,
                ),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: Colors.red.shade400,
                  width: 2,
                ),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
        // if (!cubit.state.isPasswordValid)
        //   Padding(
        //     padding: const EdgeInsets.only(top: 8, left: 4),
        //     child: Text(
        //       'Mật khẩu không hợp lệ',
        //       style: TextStyle(
        //         color: Colors.red.shade600,
        //         fontSize: 12,
        //         fontWeight: FontWeight.w500,
        //       ),
        //     ),
        //   ),
      ],
    );
  }
}
