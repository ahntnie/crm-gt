import 'package:core/core.dart';
import 'package:crm_gt/apps/app_colors.dart' as app;
import 'package:crm_gt/domains/entities/progress/progress_entities.dart';
import 'package:crm_gt/features/modules/progress/widgets/percentage_slider_dialog.dart';
import 'package:flutter/material.dart';

class ProgressCard extends StatelessWidget {
  final ProgressEntity progress;
  final Function(double) onPercentageChanged;
  final bool isAdmin;

  const ProgressCard({
    super.key,
    required this.progress,
    required this.onPercentageChanged,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = double.tryParse(progress.completionPercentage ?? '0') ?? 0.0;
    final isCompleted = percentage >= 100.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white,
            isCompleted
                ? Colors.green.withOpacity(0.02)
                : app.AppColors.cempedak101.withOpacity(0.02),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
        border: Border.all(
          color: isCompleted
              ? Colors.green.withOpacity(0.2)
              : app.AppColors.cempedak101.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(isCompleted, percentage),
            if (progress.description?.isNotEmpty == true) ...[
              const SizedBox(height: 12),
              _buildDescription(),
            ],
            const SizedBox(height: 20),
            _buildProgressSection(percentage, isCompleted),
            const SizedBox(height: 20),
            _buildFooter(context, isCompleted),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isCompleted, double percentage) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green.withOpacity(0.1)
                : app.AppColors.cempedak101.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isCompleted ? Icons.check_circle : Icons.trending_up,
            color: isCompleted ? Colors.green[600] : app.AppColors.cempedak101,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                progress.title ?? '',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isCompleted ? Colors.grey[600] : const Color(0xFF2D3748),
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  decorationColor: Colors.grey[400],
                  decorationThickness: 2,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _getStatusColor(percentage).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _getStatusText(percentage),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _getStatusColor(percentage),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isCompleted
                ? Colors.green.withOpacity(0.1)
                : app.AppColors.cempedak101.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '${percentage.toStringAsFixed(0)}%',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isCompleted ? Colors.green[600] : app.AppColors.cempedak101,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.description,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              progress.description!,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressSection(double percentage, bool isCompleted) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Tiến độ hoàn thành',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '${percentage.toStringAsFixed(1)}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isCompleted ? Colors.green[600] : app.AppColors.cempedak101,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(4),
          ),
          child: Stack(
            children: [
              Container(
                width: double.infinity,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percentage / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getProgressGradient(percentage),
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: _getStatusColor(percentage).withOpacity(0.3),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('0%', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            Text('50%', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            Text('100%', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context, bool isCompleted) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.calendar_today,
            size: 16,
            color: Colors.blue[600],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dự kiến hoàn thành',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                progress.expectedCompletionDate != null
                    ? DateTimeUtils.convertDate(progress.expectedCompletionDate)
                    : 'Chưa xác định',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
        if (isAdmin) // Chỉ hiển thị nút edit cho admin
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  app.AppColors.cempedak101,
                  app.AppColors.cempedak90,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: app.AppColors.cempedak101.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: isAdmin ? () => _showPercentageDialog(context) : null,
                borderRadius: BorderRadius.circular(12),
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Cập nhật',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Color _getStatusColor(double percentage) {
    if (percentage >= 100) {
      return Colors.green[600]!;
    } else if (percentage >= 75) {
      return Colors.blue[600]!;
    } else if (percentage >= 50) {
      return Colors.orange[600]!;
    } else if (percentage >= 25) {
      return Colors.amber[600]!;
    } else {
      return Colors.red[600]!;
    }
  }

  String _getStatusText(double percentage) {
    if (percentage >= 100) {
      return 'Hoàn thành';
    } else if (percentage >= 75) {
      return 'Gần hoàn thành';
    } else if (percentage >= 50) {
      return 'Đang tiến triển';
    } else if (percentage >= 25) {
      return 'Bắt đầu';
    } else {
      return 'Chưa bắt đầu';
    }
  }

  List<Color> _getProgressGradient(double percentage) {
    if (percentage >= 100) {
      return [Colors.green[400]!, Colors.green[600]!];
    } else if (percentage >= 75) {
      return [Colors.blue[400]!, Colors.blue[600]!];
    } else if (percentage >= 50) {
      return [Colors.orange[400]!, Colors.orange[600]!];
    } else if (percentage >= 25) {
      return [Colors.amber[400]!, Colors.amber[600]!];
    } else {
      return [Colors.red[400]!, Colors.red[600]!];
    }
  }

  void _showPercentageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PercentageSliderDialog(
        currentPercentage: double.tryParse(progress.completionPercentage ?? '0') ?? 0.0,
        title: progress.title ?? '',
        onConfirm: onPercentageChanged,
      ),
    );
  }
}
