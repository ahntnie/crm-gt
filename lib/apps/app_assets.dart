import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const String _imagePath = 'assets/images';
const String _svgPath = 'assets/svgs';

final class AppImage {
  static const BaseImage _baseImage = BaseImage(_imagePath);

  // static Image logo({BoxFit? fit, double? size, Color? color}) => _baseImage.load(
  //       'logo.png',
  //       width: size,
  //       height: size,
  //       fit: fit,
  //       color: color,
  //     );
  static Image icLogo({BoxFit? fit, double? size, Color? color}) => _baseImage.load(
        'ic_logo.png',
        width: size,
        height: size,
        fit: fit,
        color: color,
      );
  static Image chart1({BoxFit? fit, double? width, double? height, Color? color}) =>
      _baseImage.load(
        'chart1.png',
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
  static Image chart2({BoxFit? fit, double? width, double? height, Color? color}) =>
      _baseImage.load(
        'chart2.png',
        width: width,
        height: height,
        fit: fit,
        color: color,
      );

  static Image icFolder({BoxFit? fit, double? width, double? height, Color? color}) =>
      _baseImage.load(
        'img_folder.png',
        width: width,
        height: height,
        fit: fit,
        color: color,
      );
  static const blankAvatar = _Image('blank_avatar.png');
  static const logo = _Image('ic_logo.png');
}

class _Image extends AssetImage {
  const _Image(String fileName) : super('$_imagePath/$fileName');
}

final class AppSvg {
  static const BaseSvg _baseSvg = BaseSvg(_svgPath);

  static SvgPicture icFaceId({double? size, Color? color}) => _baseSvg.load(
        'ic_face_id.svg',
        width: size,
        height: size,
        colorFilter: color,
      );

  static SvgPicture icEye({double? size, Color? color}) => _baseSvg.load(
        'ic_eye.svg',
        width: size,
        height: size,
        colorFilter: color,
      );

  static SvgPicture icEyeClosed({double? size, Color? color}) => _baseSvg.load(
        'ic_eye_closed.svg',
        width: size,
        height: size,
        colorFilter: color,
      );

  static SvgPicture icSuccess({double? size, Color? color}) => _baseSvg.load(
        'ic_success.svg',
        width: size,
        height: size,
        colorFilter: color,
      );

  static SvgPicture icBackWhite({double? size, Color? color}) => _baseSvg.load(
        'ic_back_white.svg',
        width: size,
        height: size,
        colorFilter: color,
      );

  static SvgPicture icEmpty({double? size, Color? color}) => _baseSvg.load(
        'ic_empty.svg',
        width: size,
        height: size,
        colorFilter: color,
      );

  static SvgPicture icCalendar({double? size, Color? color}) => _baseSvg.load(
        'ic_calendar.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icTo({double? size, Color? color}) => _baseSvg.load(
        'ic_to.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icBack({double? size, Color? color}) => _baseSvg.load(
        'ic_back.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture iClose({double? size, Color? color}) => _baseSvg.load(
        'ic_close.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icDoubleCheck({double? size, Color? color}) => _baseSvg.load(
        'ic_double_check.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icDoubleArrow({double? size, Color? color}) => _baseSvg.load(
        'ic_double_arrow.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icSend({double? size, Color? color}) => _baseSvg.load(
        'ic_send.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icFile({double? size, Color? color}) => _baseSvg.load(
        'ic_file.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icCheck({double? size, Color? color}) => _baseSvg.load(
        'ic_check.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icHome({double? size, Color? color}) => _baseSvg.load(
        'ic_home.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icNoti({double? size, Color? color}) => _baseSvg.load(
        'ic_noti.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icProfile({double? size, Color? color}) => _baseSvg.load(
        'ic_profile.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icHrm({double? size, Color? color}) => _baseSvg.load(
        'ic_hrm.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icMedia({double? size, Color? color}) => _baseSvg.load(
        'ic_media.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icProduce({double? size, Color? color}) => _baseSvg.load(
        'ic_produce.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icTraining({double? size, Color? color}) => _baseSvg.load(
        'ic_training.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icConnection({double? size, Color? color}) => _baseSvg.load(
        'ic_connection.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
  static SvgPicture icDocProfile({double? size, Color? color}) => _baseSvg.load(
        'ic_doc_profile.svg',
        width: size,
        height: size,
        colorFilter: color,
      );
}
