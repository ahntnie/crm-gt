import 'dart:convert';

import 'package:core/core.dart';
import 'package:crm_gt/domains/entities/user/user_entities.dart';

class RoleUtils {
  /// Check if current user has admin role
  static bool isAdmin() {
    try {
      final userInfoJson = AppSP.get('user_info');
      if (userInfoJson == null) return false;

      final userInfo = UserEntities.fromJson(jsonDecode(userInfoJson) as Map<String, dynamic>);

      return userInfo.role?.toLowerCase() == 'admin';
    } catch (e) {
      print('Error checking admin role: $e');
      return false;
    }
  }

  /// Get current user info
  static UserEntities? getCurrentUser() {
    try {
      final userInfoJson = AppSP.get('user_info');
      if (userInfoJson == null) return null;

      return UserEntities.fromJson(jsonDecode(userInfoJson) as Map<String, dynamic>);
    } catch (e) {
      print('Error getting user info: $e');
      return null;
    }
  }

  /// Check if user has specific role
  static bool hasRole(String role) {
    final user = getCurrentUser();
    return user?.role?.toLowerCase() == role.toLowerCase();
  }
}
