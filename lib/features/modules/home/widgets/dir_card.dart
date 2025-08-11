import 'package:core/core.dart';
import 'package:crm_gt/apps/app_assets.dart';
import 'package:crm_gt/apps/app_colors.dart' as app;
import 'package:crm_gt/features/modules/notifications/notifications_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domains/entities/dir/dir_entities.dart';

class DirCard extends StatelessWidget {
  const DirCard({
    super.key,
    required this.dirEntities,
    required this.onTap,
    this.unreadCount = 0,
  });

  final DirEntities dirEntities;
  final VoidCallback? onTap;
  final int unreadCount;

  @override
  Widget build(BuildContext context) {
    final isParent = dirEntities.level == '0';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: app.AppColors.mono0,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: Colors.grey.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Icon container with background
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: isParent
                          ? app.AppColors.cempedak101.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: AppImage.icFolder(height: 32, width: 32),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dirEntities.name ?? '',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1A1A1A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Ngày tạo: ${DateTimeUtils.convertDate(dirEntities.createdAt)}',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: isParent
                                ? Colors.blue.withOpacity(0.1)
                                : Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            isParent ? 'Thư mục gốc' : 'Thư mục con',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isParent ? Colors.blue[700] : Colors.green[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Right side indicators
                  if (dirEntities.level != '2') ...[
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        BlocBuilder<NotificationsCubit, NotificationsState>(
                          buildWhen: (previous, current) =>
                              previous.isLoading != current.isLoading ||
                              previous.currentNoti?.threadId != current.currentNoti?.threadId ||
                              previous.unreadCount != current.unreadCount,
                          builder: (context, state) {
                            // Loading indicator
                            if (state.isLoading && state.currentNoti?.threadId == dirEntities.id) {
                              return Container(
                                width: 24,
                                height: 24,
                                padding: const EdgeInsets.all(4),
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    app.AppColors.cempedak101,
                                  ),
                                ),
                              );
                            }

                            // Unread count badge
                            if (unreadCount > 0) {
                              return Container(
                                constraints: const BoxConstraints(
                                  minWidth: 24,
                                  minHeight: 24,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: app.AppColors.prime100,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: app.AppColors.prime100.withOpacity(0.3),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Text(
                                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: app.AppColors.mono0,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }

                            return const SizedBox(width: 24, height: 24);
                          },
                        ),
                        const SizedBox(height: 8),
                        Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey[400],
                          size: 16,
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
