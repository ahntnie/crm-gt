import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/features/modules/home/cubit/home/home_cubit.dart';
import 'package:flutter/material.dart';

class AddDirDialog extends StatefulWidget {
  final HomeCubit cubit;
  const AddDirDialog({required this.cubit, super.key});

  @override
  State<AddDirDialog> createState() => _AddDirDialogState();
}

class _AddDirDialogState extends State<AddDirDialog> {
  bool _isLoading = false;

  @override
  void dispose() {
    widget.cubit.nameDirController.clear();
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
              Icons.folder_open,
              color: AppColors.cempedak101,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Thêm thư mục',
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
            controller: widget.cubit.nameDirController,
            onChanged: widget.cubit.changeDirName,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Tên thư mục',
              hintText: 'Nhập tên thư mục',
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
                Icons.folder,
                color: AppColors.cempedak101,
              ),
            ),
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
          onPressed: _isLoading ? null : _handleCreateDir,
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
                  'Thêm',
                  style: TextStyle(fontSize: 16),
                ),
        ),
      ],
    );
  }

  Future<void> _handleCreateDir() async {
    final dirName = widget.cubit.nameDirController.text.trim();
    if (dirName.isEmpty) {
      _showErrorSnackBar('Vui lòng nhập tên thư mục');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await widget.cubit.createDir();
      if (context.mounted) {
        Navigator.of(context).pop();
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

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
