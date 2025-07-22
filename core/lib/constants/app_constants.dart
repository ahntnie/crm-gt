part of '../core.dart';

class Dimension {
//height
  static const double h2 = 2.0;
  static const double h4 = 4.0;
  static const double h8 = 8.0;
  static const double h14 = 14.0;

  static const double h16 = 16.0;
  static const double h20 = 20.0;
  static const double h22 = 22.0;
  static const double h24 = 24.0;
  static const double h28 = 28.0;
  static const double h32 = 32.0;
  static const double h40 = 40.0;
  static const double h44 = 44.0;
  static const double h46 = 46.0;
  static const double h48 = 48.0;
  static const double h50 = 50.0;
  static const double h52 = 52.0;
  static const double h56 = 56.0;
  static const double h60 = 60.0;
  static const double h62 = 62.0;
  static const double h64 = 64.0;
  static const double h66 = 66.0;
  static const double h68 = 68.0;
  static const double h70 = 70.0;
  static const double h108 = 108.0;
  static const double h128 = 128.0;
  static const double h178 = 178.0;
  static const double divideHeight = 1.0;
  static const double buttonHeight = 44.0;

  // Padding
  static const double padding0 = 0.0;
  static const double padding4 = 4.0;
  static const double padding6 = 6.0;
  static const double padding8 = 8.0;
  static const double padding10 = 10.0;
  static const double padding12 = 12.0;
  static const double padding14 = 14.0;
  static const double padding16 = 16.0;
  static const double padding18 = 18.0;
  static const double padding20 = 20.0;
  static const double padding24 = 24.0;
  static const double padding28 = 28.0;
  static const double padding32 = 32.0;
  static const double padding36 = 36.0;
  static const double padding40 = 40.0;
  static const double padding44 = 44.0;
  static const double padding48 = 48.0;
  static const double padding52 = 52.0;
  static const double padding54 = 54.0;
  static const double padding56 = 56.0;
  static const double padding60 = 60.0;
  static const double padding64 = 64.0;
  static const double padding80 = 80.0;
  static const double padding115 = 115.0;
  static const double padding120 = 120.0;

  // Margin
  static const double margin0 = 0.0;
  static const double margin4 = 4.0;
  static const double margin8 = 8.0;
  static const double margin12 = 12.0;
  static const double margin16 = 16.0;
  static const double margin20 = 20.0;
  static const double margin24 = 24.0;
  static const double margin28 = 28.0;
  static const double margin32 = 32.0;
  static const double margin36 = 36.0;
  static const double margin40 = 40.0;
  static const double margin44 = 44.0;
  static const double margin48 = 48.0;
  static const double margin52 = 52.0;
  static const double margin56 = 56.0;
  static const double margin60 = 60.0;
  static const double margin64 = 64.0;

  // Radius
  static const double radius2 = 2.0;
  static const double radius4 = 4.0;
  static const double radius8 = 8.0;
  static const double radius16 = 16.0;
}

class AppRegex {
  AppRegex._();

  // Must contain at least 3 characters
  static const String username = r'^.{3,}$';

  // Must contain at least one number and one uppercase and lowercase letter, and one special character,
  // and at least 8 or more characters
  static const String password = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[^\w\s]).{8,}$';

  // Email
  static const String email = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
}

final class AppDefined {
  AppDefined._();
  static const int defaultPageSize = 30;
}
