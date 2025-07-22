part of '../core.dart';

class WidgetUtils {
  static Future<void> showLoading() => EasyLoading.show();
  static Future<void> dismissLoading() => EasyLoading.dismiss();

  static void showSnackBar({
    EdgeInsetsGeometry? margin,
    required BuildContext context,
    required AppTheme theme,
    required String title,
    Duration? duration,
    Widget? icon,
    DismissDirection? dismissDirection,
  }) async {
    final controller = ScaffoldMessenger.of(context);
    final snackBar = snackBarWidget(
      // backgroundColor: theme.colors.neutral13,
      // context: context,
      title: title,
      margin: margin ?? EdgeInsets.only(bottom: DeviceUtils.getHeight3(context) - 56 - 58),
      // color: theme.colors.primary,
      theme: theme,
      dismissDirection: dismissDirection,
      duration: duration,
      controller: controller,
    );
    controller.showSnackBar(snackBar);
  }

  static void configLoading(Widget logo) {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..textColor = Colors.white
      ..radius = 10
      ..indicatorType = EasyLoadingIndicatorType.rotatingCircle
      ..indicatorColor = Colors.transparent
      ..userInteractions = false
      ..indicatorWidget = BrandLoading(logoDark: false, logo: logo)
      ..boxShadow = <BoxShadow>[]
      ..maskColor = Colors.black.withOpacity(0.6)
      ..backgroundColor = Colors.transparent
      ..maskType = EasyLoadingMaskType.custom
      ..dismissOnTap = false;
  }
}

class BrandLoading extends StatelessWidget {
  final bool logoDark;
  final double? size;
  final Widget logo;

  const BrandLoading({
    super.key,
    this.logoDark = false,
    required this.logo,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double sizeLoading = size ?? screenWidth * 0.25;

    return Stack(
      alignment: Alignment.center,
      children: [
        SpinKitDualRing(
          color: logoDark ? Colors.white : Colors.black,
          size: sizeLoading * 0.8,
          duration: const Duration(milliseconds: 1500),
          lineWidth: 4,
        ),
        Container(
          width: sizeLoading * 0.5,
          height: sizeLoading * 0.5,
          decoration: const ShapeDecoration(
            color: Colors.transparent,
            shape: CircleBorder(),
          ),
          child: logo,
        ),
      ],
    );
  }
}
