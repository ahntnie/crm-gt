import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/features/modules/home/cubit/home/home_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddMemberDialog extends StatefulWidget {
  final HomeCubit cubit;
  const AddMemberDialog({required this.cubit, super.key});

  @override
  State<AddMemberDialog> createState() => _AddMemberDialogState();
}

class _AddMemberDialogState extends State<AddMemberDialog> {
  bool _isLoading = false;

  @override
  void dispose() {
    widget.cubit.phoneController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.mono0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.cempedak101.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person_add,
              color: AppColors.cempedak101,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Thêm thành viên',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: widget.cubit.phoneController,
            onChanged: widget.cubit.changePhone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              labelText: 'Số điện thoại',
              hintText: 'Nhập số điện thoại',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.cempedak101),
              ),
              filled: true,
              fillColor: Colors.grey[50],
              prefixIcon: const Icon(
                Icons.phone,
                color: AppColors.cempedak101,
              ),
            ),
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.of(context).pop(),
          child: const Text(
            'Hủy',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.cempedak101,
            foregroundColor: AppColors.mono0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: _isLoading ? null : _handleAddMember,
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.mono0),
                  ),
                )
              : const Text(
                  'Thêm vào',
                  style: TextStyle(fontSize: 16),
                ),
        ),
      ],
    );
  }

  Future<void> _handleAddMember() async {
    final phoneNumber = widget.cubit.phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      _showErrorSnackBar('Vui lòng nhập số điện thoại');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final currentDirId = widget.cubit.state.currentDir?.id;
      if (currentDirId != null) {
        // Gọi trực tiếp usecase để lấy response message
        final result = await widget.cubit.homeUsecase.invatedToChat(currentDirId, phoneNumber);

        if (context.mounted) {
          // Kiểm tra nếu message chứa từ khóa lỗi
          if (result.toLowerCase().contains('lỗi') ||
              result.toLowerCase().contains('error') ||
              result.toLowerCase().contains('không tìm thấy') ||
              result.toLowerCase().contains('không tồn tại')) {
            _showErrorSnackBar(result);
          } else {
            // Hiển thị thông báo thành công
            _showSuccessSnackBar(result);
            Navigator.of(context).pop();
          }
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar('Lỗi: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle,
              color: AppColors.mono0,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.mono0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: AppColors.mono0,
              size: 20,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: AppColors.mono0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }
}
