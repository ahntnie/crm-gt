import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'l10n_en.dart';
import 'l10n_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/l10n.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @languageCode.
  ///
  /// In en, this message translates to:
  /// **'en'**
  String get languageCode;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get edit;

  /// No description provided for @gifIndicator.
  ///
  /// In en, this message translates to:
  /// **'GIF'**
  String get gifIndicator;

  /// No description provided for @loadFailed.
  ///
  /// In en, this message translates to:
  /// **'Load failed'**
  String get loadFailed;

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'Origin'**
  String get original;

  /// No description provided for @preview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get preview;

  /// No description provided for @emptyList.
  ///
  /// In en, this message translates to:
  /// **'Empty list'**
  String get emptyList;

  /// No description provided for @unSupportedAssetType.
  ///
  /// In en, this message translates to:
  /// **'Unsupported HEIC asset type.'**
  String get unSupportedAssetType;

  /// No description provided for @unableToAccessAll.
  ///
  /// In en, this message translates to:
  /// **'Unable to access all assets on the device'**
  String get unableToAccessAll;

  /// No description provided for @viewingLimitedAssetsTip.
  ///
  /// In en, this message translates to:
  /// **'Only view assets and albums accessible to app'**
  String get viewingLimitedAssetsTip;

  /// No description provided for @changeAccessibleLimitedAssets.
  ///
  /// In en, this message translates to:
  /// **'Click to update accessible assets'**
  String get changeAccessibleLimitedAssets;

  /// No description provided for @accessAllTip.
  ///
  /// In en, this message translates to:
  /// **'App can only access some assets on the device. \nGo to system settings and allow app to access all assets on the device.'**
  String get accessAllTip;

  /// No description provided for @goToSystemSettings.
  ///
  /// In en, this message translates to:
  /// **'Go to system settings'**
  String get goToSystemSettings;

  /// No description provided for @accessLimitedAssets.
  ///
  /// In en, this message translates to:
  /// **'Continue with limited access'**
  String get accessLimitedAssets;

  /// No description provided for @accessiblePathName.
  ///
  /// In en, this message translates to:
  /// **'Accessible assets'**
  String get accessiblePathName;

  /// No description provided for @sTypeAudioLabel.
  ///
  /// In en, this message translates to:
  /// **'Audio'**
  String get sTypeAudioLabel;

  /// No description provided for @sTypeImageLabel.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get sTypeImageLabel;

  /// No description provided for @sTypeVideoLabel.
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get sTypeVideoLabel;

  /// No description provided for @sTypeOtherLabel.
  ///
  /// In en, this message translates to:
  /// **'Other asset'**
  String get sTypeOtherLabel;

  /// No description provided for @sActionPlayHint.
  ///
  /// In en, this message translates to:
  /// **'play'**
  String get sActionPlayHint;

  /// No description provided for @sActionPreviewHint.
  ///
  /// In en, this message translates to:
  /// **'preview'**
  String get sActionPreviewHint;

  /// No description provided for @sActionSelectHint.
  ///
  /// In en, this message translates to:
  /// **'select'**
  String get sActionSelectHint;

  /// No description provided for @sActionSwitchPathLabel.
  ///
  /// In en, this message translates to:
  /// **'Switch path'**
  String get sActionSwitchPathLabel;

  /// No description provided for @sActionUseCameraHint.
  ///
  /// In en, this message translates to:
  /// **'use camera'**
  String get sActionUseCameraHint;

  /// No description provided for @sNameDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get sNameDurationLabel;

  /// No description provided for @sUnitAssetCountLabel.
  ///
  /// In en, this message translates to:
  /// **'count'**
  String get sUnitAssetCountLabel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @validateImage.
  ///
  /// In en, this message translates to:
  /// **'Upload image size does not exceed 10MB'**
  String get validateImage;

  /// No description provided for @validateFileType.
  ///
  /// In en, this message translates to:
  /// **'Extension file is invalid'**
  String get validateFileType;

  /// No description provided for @connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get connectionTimeout;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register_success_note.
  ///
  /// In en, this message translates to:
  /// **'Account information has been registered. Please login to continue experiencing'**
  String get register_success_note;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successful account registration'**
  String get registerSuccess;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get full_name;

  /// No description provided for @phone_number.
  ///
  /// In en, this message translates to:
  /// **'Phone number'**
  String get phone_number;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @validate_name.
  ///
  /// In en, this message translates to:
  /// **'The name is not in the correct format'**
  String get validate_name;

  /// No description provided for @userName.
  ///
  /// In en, this message translates to:
  /// **'User name'**
  String get userName;

  /// No description provided for @validate_username.
  ///
  /// In en, this message translates to:
  /// **'Username is not formatted correctly'**
  String get validate_username;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @invalid_password.
  ///
  /// In en, this message translates to:
  /// **'Invalid password'**
  String get invalid_password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Enter the password'**
  String get confirm_password;

  /// No description provided for @suggest_pass_again.
  ///
  /// In en, this message translates to:
  /// **'Password must match the password above'**
  String get suggest_pass_again;

  /// No description provided for @suggest_password.
  ///
  /// In en, this message translates to:
  /// **'Password must contain 8-50 characters, must contain numeric characters, unsigned letters including lowercase and uppercase letters and other special characters'**
  String get suggest_password;

  /// No description provided for @title_terms_policies.
  ///
  /// In en, this message translates to:
  /// **'I have read and agree with the'**
  String get title_terms_policies;

  /// No description provided for @title_terms_policies_under_line.
  ///
  /// In en, this message translates to:
  /// **'terms and policies of use'**
  String get title_terms_policies_under_line;

  /// No description provided for @change_pw.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_pw;

  /// No description provided for @oldPassword.
  ///
  /// In en, this message translates to:
  /// **'Old password'**
  String get oldPassword;

  /// No description provided for @new_password.
  ///
  /// In en, this message translates to:
  /// **'A new password'**
  String get new_password;

  /// No description provided for @error_password.
  ///
  /// In en, this message translates to:
  /// **'Password is not in the correct format'**
  String get error_password;

  /// No description provided for @confirm_new_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm new password'**
  String get confirm_new_password;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @notify.
  ///
  /// In en, this message translates to:
  /// **'Notify'**
  String get notify;

  /// No description provided for @changePassSuccessMes.
  ///
  /// In en, this message translates to:
  /// **'Change password successfully'**
  String get changePassSuccessMes;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @forgot_password_title.
  ///
  /// In en, this message translates to:
  /// **'Forgot password'**
  String get forgot_password_title;

  /// No description provided for @forgot_password_page_content.
  ///
  /// In en, this message translates to:
  /// **'The link code will be sent to your email. Use the link code to verify your account'**
  String get forgot_password_page_content;

  /// No description provided for @send_request.
  ///
  /// In en, this message translates to:
  /// **'Send request'**
  String get send_request;

  /// No description provided for @title_create_password.
  ///
  /// In en, this message translates to:
  /// **'Create a new password'**
  String get title_create_password;

  /// No description provided for @validateConfirmPass.
  ///
  /// In en, this message translates to:
  /// **'Password must contain 8-50 characters, must contain numeric characters, accented letters including lowercase and uppercase letters and other special characters.'**
  String get validateConfirmPass;

  /// No description provided for @agree.
  ///
  /// In en, this message translates to:
  /// **'Agree'**
  String get agree;

  /// No description provided for @rememberPass.
  ///
  /// In en, this message translates to:
  /// **'Remember password'**
  String get rememberPass;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgot_password;

  /// No description provided for @log_in_to_another_account.
  ///
  /// In en, this message translates to:
  /// **'Log in to another account'**
  String get log_in_to_another_account;

  /// No description provided for @invalid_username.
  ///
  /// In en, this message translates to:
  /// **'Invalid username'**
  String get invalid_username;

  /// No description provided for @mess_notification_request_mail.
  ///
  /// In en, this message translates to:
  /// **'Submit request successfully, information has been sent to your Email'**
  String get mess_notification_request_mail;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// production order status
  ///
  /// In en, this message translates to:
  /// **'{section, select, APPROVED {Approved} WAIT_APPROVE {Wait approve} REJECTED {Rejected} other {All}}'**
  String production_order_status(String section);

  /// No description provided for @approve_order.
  ///
  /// In en, this message translates to:
  /// **'Phê duyệt lệnh'**
  String get approve_order;

  /// No description provided for @refuse.
  ///
  /// In en, this message translates to:
  /// **'Refuse'**
  String get refuse;

  /// No description provided for @approve.
  ///
  /// In en, this message translates to:
  /// **'Approve'**
  String get approve;

  /// No description provided for @unit_excute.
  ///
  /// In en, this message translates to:
  /// **'Đơn vị thực hiện'**
  String get unit_excute;

  /// No description provided for @unit_order_delivery.
  ///
  /// In en, this message translates to:
  /// **'Đơn vị giao lệnh'**
  String get unit_order_delivery;

  /// No description provided for @list_prod_order.
  ///
  /// In en, this message translates to:
  /// **'Danh sách lệnh sản xuất'**
  String get list_prod_order;

  /// No description provided for @general_info.
  ///
  /// In en, this message translates to:
  /// **'Thông tin chung'**
  String get general_info;

  /// No description provided for @direct_block.
  ///
  /// In en, this message translates to:
  /// **'Khối trực tiếp'**
  String get direct_block;

  /// No description provided for @indirect_block.
  ///
  /// In en, this message translates to:
  /// **'Khối gián tiếp'**
  String get indirect_block;

  /// No description provided for @number_signal.
  ///
  /// In en, this message translates to:
  /// **'Số hiệu'**
  String get number_signal;

  /// No description provided for @name_order.
  ///
  /// In en, this message translates to:
  /// **'Tên lệnh'**
  String get name_order;

  /// No description provided for @start_date.
  ///
  /// In en, this message translates to:
  /// **'Ngày bắt đầu'**
  String get start_date;

  /// No description provided for @end_date.
  ///
  /// In en, this message translates to:
  /// **'Ngày kết thúc'**
  String get end_date;

  /// No description provided for @base_order.
  ///
  /// In en, this message translates to:
  /// **'Căn cứ ra lệnh sản xuất'**
  String get base_order;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Ghi chú'**
  String get note;

  /// No description provided for @file_attach.
  ///
  /// In en, this message translates to:
  /// **'File đính kèm'**
  String get file_attach;

  /// No description provided for @stage_mission.
  ///
  /// In en, this message translates to:
  /// **'Chặng - nhiệm vụ'**
  String get stage_mission;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Số lượng'**
  String get quantity;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Ưu tiên'**
  String get priority;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Thời gian'**
  String get time;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Gửi'**
  String get send;

  /// No description provided for @input_reason_refuse.
  ///
  /// In en, this message translates to:
  /// **'Nhập lý do từ chối'**
  String get input_reason_refuse;

  /// No description provided for @reason.
  ///
  /// In en, this message translates to:
  /// **'Lý do từ chối'**
  String get reason;

  /// No description provided for @input_reason.
  ///
  /// In en, this message translates to:
  /// **'Nhập lý do'**
  String get input_reason;

  /// No description provided for @approve_success.
  ///
  /// In en, this message translates to:
  /// **'Phê duyệt thành công'**
  String get approve_success;

  /// No description provided for @refuse_success.
  ///
  /// In en, this message translates to:
  /// **'Từ chối thành công'**
  String get refuse_success;

  /// No description provided for @approve_fail.
  ///
  /// In en, this message translates to:
  /// **'Phê duyệt thất bại'**
  String get approve_fail;

  /// No description provided for @refuse_fail.
  ///
  /// In en, this message translates to:
  /// **'Từ chối thất bại'**
  String get refuse_fail;

  /// No description provided for @connection_timeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timeout'**
  String get connection_timeout;

  /// No description provided for @something_went_wrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get something_went_wrong;

  /// No description provided for @error_noti.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error_noti;

  /// No description provided for @you_are_offline.
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get you_are_offline;

  /// No description provided for @connection_lost_desc.
  ///
  /// In en, this message translates to:
  /// **'The connection to the system is temporarily interrupted. Please try again later.'**
  String get connection_lost_desc;

  /// No description provided for @updateAvailabe.
  ///
  /// In en, this message translates to:
  /// **'Update available'**
  String get updateAvailabe;

  /// No description provided for @updateContent.
  ///
  /// In en, this message translates to:
  /// **'A new version is available. Please update to the latest version to experience the best features.'**
  String get updateContent;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
