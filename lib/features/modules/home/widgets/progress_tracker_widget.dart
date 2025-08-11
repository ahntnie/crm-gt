import 'package:crm_gt/apps/app_colors.dart';
import 'package:flutter/material.dart';

class ProgressTrackerWidget extends StatelessWidget {
  final int currentProgress;
  final String projectName;
  final bool canEdit;
  final VoidCallback? onEditPressed;
  final List<ProgressMilestone> milestones;

  const ProgressTrackerWidget({
    super.key,
    required this.currentProgress,
    required this.projectName,
    required this.canEdit,
    this.onEditPressed,
    required this.milestones,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.cempedak101.withOpacity(0.1),
            AppColors.cempedak90.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.cempedak101.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildProgressBar(),
            const SizedBox(height: 16),
            _buildMilestones(),
            const SizedBox(height: 12),
            _buildProgressStats(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.cempedak101.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.trending_up,
            color: AppColors.cempedak101,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Tiến độ dự án',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                projectName,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        if (canEdit)
          Container(
            decoration: BoxDecoration(
              color: AppColors.cempedak101.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: IconButton(
              onPressed: onEditPressed,
              icon: const Icon(
                Icons.edit,
                color: AppColors.cempedak101,
                size: 18,
              ),
              tooltip: 'Chỉnh sửa tiến độ',
            ),
          ),
      ],
    );
  }

  Widget _buildProgressBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Hoàn thành',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '$currentProgress%',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.cempedak101,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
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
                widthFactor: currentProgress / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getProgressColors(),
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMilestones() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Các mốc quan trọng',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 8),
        ...milestones.map((milestone) => _buildMilestoneItem(milestone)),
      ],
    );
  }

  Widget _buildMilestoneItem(ProgressMilestone milestone) {
    final isCompleted = currentProgress >= milestone.percentage;
    final isCurrent =
        currentProgress >= milestone.percentage - 10 && currentProgress < milestone.percentage + 10;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.cempedak101.withOpacity(0.1)
            : isCurrent
                ? Colors.orange.withOpacity(0.1)
                : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCompleted
              ? AppColors.cempedak101.withOpacity(0.3)
              : isCurrent
                  ? Colors.orange.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isCompleted
                  ? AppColors.cempedak101
                  : isCurrent
                      ? Colors.orange
                      : Colors.grey[400],
              shape: BoxShape.circle,
            ),
            child: Icon(
              isCompleted
                  ? Icons.check
                  : isCurrent
                      ? Icons.play_arrow
                      : Icons.circle,
              color: AppColors.mono0,
              size: 12,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  milestone.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isCompleted
                        ? AppColors.cempedak101
                        : isCurrent
                            ? Colors.orange[700]
                            : Colors.grey[700],
                  ),
                ),
                if (milestone.description.isNotEmpty)
                  Text(
                    milestone.description,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          Text(
            '${milestone.percentage}%',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isCompleted ? AppColors.cempedak101 : Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressStats() {
    final completedMilestones = milestones.where((m) => currentProgress >= m.percentage).length;
    final totalMilestones = milestones.length;

    return Row(
      children: [
        _buildStatItem(
          icon: Icons.flag,
          label: 'Mốc hoàn thành',
          value: '$completedMilestones/$totalMilestones',
          color: AppColors.cempedak101,
        ),
        const SizedBox(width: 16),
        _buildStatItem(
          icon: Icons.schedule,
          label: 'Còn lại',
          value: '${100 - currentProgress}%',
          color: Colors.orange,
        ),
      ],
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Color> _getProgressColors() {
    if (currentProgress < 30) {
      return [Colors.red[400]!, Colors.red[600]!];
    } else if (currentProgress < 70) {
      return [Colors.orange[400]!, Colors.orange[600]!];
    } else {
      return [AppColors.cempedak101, AppColors.cempedak90];
    }
  }
}

class ProgressMilestone {
  final String title;
  final String description;
  final int percentage;

  const ProgressMilestone({
    required this.title,
    required this.description,
    required this.percentage,
  });
}
