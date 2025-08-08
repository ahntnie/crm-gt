import 'package:crm_gt/apps/app_colors.dart';
import 'package:flutter/material.dart';

Widget buildProfileOption({
  required IconData icon,
  required String title,
  required String subtitle,
  required VoidCallback onTap,
}) {
  return ListTile(
    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    leading: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cempedak101.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        icon,
        color: AppColors.cempedak101,
        size: 22,
      ),
    ),
    title: Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF2D3748),
      ),
    ),
    subtitle: Text(
      subtitle,
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[600],
      ),
    ),
    trailing: const Icon(
      Icons.arrow_forward_ios,
      size: 16,
      color: Colors.grey,
    ),
    onTap: onTap,
  );
}
