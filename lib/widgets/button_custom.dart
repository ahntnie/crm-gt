import 'package:crm_gt/apps/app_colors.dart';
import 'package:flutter/material.dart';

class ButtonCustom extends StatefulWidget {
  final Function()? onPressed;
  final bool? isSplashScreen;
  final String? title;
  final double textSize;
  final double? borderRadius;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Widget? customTitle;

  const ButtonCustom({
    super.key,
    this.onPressed,
    this.isSplashScreen,
    this.title,
    required this.textSize,
    this.margin,
    this.padding,
    this.height = 50,
    this.width,
    this.borderRadius,
    this.customTitle,
  });

  @override
  State<ButtonCustom> createState() => _ButtonCustomState();
}

class _ButtonCustomState extends State<ButtonCustom> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      decoration: BoxDecoration(
        gradient: widget.isSplashScreen == null
            ? const LinearGradient(
                colors: [
                  Color(0xFFEB6E2C),
                  Color(0xFFFABD1D),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        color: widget.isSplashScreen != null ? AppColors.mono0 : null,
        borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 25)),
      ),
      height: widget.height,
      width: widget.width,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onPressed,
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius ?? 25)),
          child: Padding(
            padding: widget.padding ?? EdgeInsets.zero,
            child: Center(
              child: widget.customTitle ??
                  Text(
                    widget.title!,
                    style: TextStyle(
                        fontSize: widget.textSize,
                        fontWeight: FontWeight.bold,
                        color: widget.isSplashScreen == null
                            ? AppColors.mono0
                            : const Color(0xffEB6E2C)),
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
