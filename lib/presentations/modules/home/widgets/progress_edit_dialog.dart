import 'package:crm_gt/apps/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'progress_tracker_widget.dart';

class ProgressEditDialog extends StatefulWidget {
  final int currentProgress;
  final List<ProgressMilestone> milestones;
  final Function(int progress, List<ProgressMilestone> milestones) onSave;

  const ProgressEditDialog({
    super.key,
    required this.currentProgress,
    required this.milestones,
    required this.onSave,
  });

  @override
  State<ProgressEditDialog> createState() => _ProgressEditDialogState();
}

class _ProgressEditDialogState extends State<ProgressEditDialog> {
  late int _progress;
  late List<ProgressMilestone> _milestones;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _progress = widget.currentProgress;
    _milestones = List.from(widget.milestones);
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
              Icons.edit,
              color: AppColors.cempedak101,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          const Text(
            'Chỉnh sửa tiến độ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProgressSlider(),
            const SizedBox(height: 20),
            _buildMilestonesSection(),
          ],
        ),
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
          onPressed: _isLoading ? null : _handleSave,
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
                  'Lưu',
                  style: TextStyle(fontSize: 16),
                ),
        ),
      ],
    );
  }

  Widget _buildProgressSlider() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tiến độ hiện tại',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.cempedak101.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$_progress%',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.cempedak101,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppColors.cempedak101,
            inactiveTrackColor: Colors.grey[300],
            thumbColor: AppColors.cempedak101,
            overlayColor: AppColors.cempedak101.withOpacity(0.2),
            trackHeight: 6,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(
            value: _progress.toDouble(),
            min: 0,
            max: 100,
            divisions: 20,
            onChanged: (value) {
              setState(() {
                _progress = value.round();
              });
            },
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0%', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            Text('50%', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            Text('100%', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildMilestonesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Các mốc quan trọng',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            TextButton.icon(
              onPressed: _addMilestone,
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Thêm'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.cempedak101,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _milestones.length,
            itemBuilder: (context, index) {
              return _buildMilestoneEditItem(index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMilestoneEditItem(int index) {
    final milestone = _milestones[index];
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (milestone.description.isNotEmpty)
                  Text(
                    milestone.description,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.cempedak101.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              '${milestone.percentage}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.cempedak101,
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: () => _removeMilestone(index),
            icon: const Icon(Icons.delete_outline, size: 18),
            color: Colors.red[400],
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }

  void _addMilestone() {
    showDialog(
      context: context,
      builder: (context) => _AddMilestoneDialog(
        onAdd: (milestone) {
          setState(() {
            _milestones.add(milestone);
            _milestones.sort((a, b) => a.percentage.compareTo(b.percentage));
          });
        },
      ),
    );
  }

  void _removeMilestone(int index) {
    setState(() {
      _milestones.removeAt(index);
    });
  }

  Future<void> _handleSave() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(milliseconds: 500)); // Simulate API call
      widget.onSave(_progress, _milestones);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red[400],
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}

class _AddMilestoneDialog extends StatefulWidget {
  final Function(ProgressMilestone) onAdd;

  const _AddMilestoneDialog({required this.onAdd});

  @override
  State<_AddMilestoneDialog> createState() => _AddMilestoneDialogState();
}

class _AddMilestoneDialogState extends State<_AddMilestoneDialog> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _percentageController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _percentageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Thêm mốc quan trọng'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Tiêu đề',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Mô tả (tùy chọn)',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _percentageController,
            decoration: const InputDecoration(
              labelText: 'Phần trăm (%)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(3),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        FilledButton(
          onPressed: _handleAdd,
          child: const Text('Thêm'),
        ),
      ],
    );
  }

  void _handleAdd() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final percentageText = _percentageController.text.trim();

    if (title.isEmpty || percentageText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập đầy đủ thông tin')),
      );
      return;
    }

    final percentage = int.tryParse(percentageText);
    if (percentage == null || percentage < 0 || percentage > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Phần trăm phải từ 0 đến 100')),
      );
      return;
    }

    widget.onAdd(ProgressMilestone(
      title: title,
      description: description,
      percentage: percentage,
    ));

    Navigator.of(context).pop();
  }
}
