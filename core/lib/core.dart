library core;

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:fast_rsa/fast_rsa.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'locales/generated/l10n.dart';

export 'locales/generated/l10n.dart';

part 'configs/app_config_environments.dart';
part 'connections/standard_connection.dart';
part 'connections/transportation_object.dart';
part 'cubit/core_state.dart';
part 'di.dart';
part 'entities/token_data.dart';
part 'locales/app_language.dart';
part 'remote/app_base_repo.dart';
part 'routing/transition.dart';
part 'storage/app_caching.dart';
part 'storage/app_secure_storage.dart';
part 'storage/app_shared_preferences.dart';
part 'theme/app_colors.dart';
part 'theme/app_text_style.dart';
part 'theme/app_theme.dart';
part 'utils/assets_utils.dart';
part 'utils/datetime_utils.dart';
part 'utils/device_utils.dart';
part 'utils/file_utils.dart';
part 'utils/log.dart';
part 'utils/regex_utils.dart';
part 'utils/result_utils.dart';
part 'utils/string_utils.dart';
part 'utils/utils.dart';
part 'utils/validate_utils.dart';
part 'utils/widget_utils.dart';
part 'widgets/core_widget.dart';
part 'widgets/snack_bar.dart';
