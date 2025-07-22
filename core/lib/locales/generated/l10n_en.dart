import 'package:intl/intl.dart' as intl;

import 'l10n.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get languageCode => 'en';

  @override
  String get edit => 'Confirm';

  @override
  String get gifIndicator => 'GIF';

  @override
  String get loadFailed => 'Load failed';

  @override
  String get original => 'Origin';

  @override
  String get preview => 'Preview';

  @override
  String get emptyList => 'Empty list';

  @override
  String get unSupportedAssetType => 'Unsupported HEIC asset type.';

  @override
  String get unableToAccessAll => 'Unable to access all assets on the device';

  @override
  String get viewingLimitedAssetsTip => 'Only view assets and albums accessible to app';

  @override
  String get changeAccessibleLimitedAssets => 'Click to update accessible assets';

  @override
  String get accessAllTip => 'App can only access some assets on the device. \nGo to system settings and allow app to access all assets on the device.';

  @override
  String get goToSystemSettings => 'Go to system settings';

  @override
  String get accessLimitedAssets => 'Continue with limited access';

  @override
  String get accessiblePathName => 'Accessible assets';

  @override
  String get sTypeAudioLabel => 'Audio';

  @override
  String get sTypeImageLabel => 'Image';

  @override
  String get sTypeVideoLabel => 'Video';

  @override
  String get sTypeOtherLabel => 'Other asset';

  @override
  String get sActionPlayHint => 'play';

  @override
  String get sActionPreviewHint => 'preview';

  @override
  String get sActionSelectHint => 'select';

  @override
  String get sActionSwitchPathLabel => 'Switch path';

  @override
  String get sActionUseCameraHint => 'use camera';

  @override
  String get sNameDurationLabel => 'Duration';

  @override
  String get sUnitAssetCountLabel => 'count';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get select => 'Select';

  @override
  String get validateImage => 'Upload image size does not exceed 10MB';

  @override
  String get validateFileType => 'Extension file is invalid';

  @override
  String get connectionTimeout => 'Connection timeout';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get login => 'Login';

  @override
  String get register_success_note => 'Account information has been registered. Please login to continue experiencing';

  @override
  String get registerSuccess => 'Successful account registration';

  @override
  String get register => 'Register';

  @override
  String get full_name => 'Full name';

  @override
  String get phone_number => 'Phone number';

  @override
  String get email => 'Email';

  @override
  String get validate_name => 'The name is not in the correct format';

  @override
  String get userName => 'User name';

  @override
  String get validate_username => 'Username is not formatted correctly';

  @override
  String get password => 'Password';

  @override
  String get invalid_password => 'Invalid password';

  @override
  String get confirm_password => 'Enter the password';

  @override
  String get suggest_pass_again => 'Password must match the password above';

  @override
  String get suggest_password => 'Password must contain 8-50 characters, must contain numeric characters, unsigned letters including lowercase and uppercase letters and other special characters';

  @override
  String get title_terms_policies => 'I have read and agree with the';

  @override
  String get title_terms_policies_under_line => 'terms and policies of use';

  @override
  String get change_pw => 'Change password';

  @override
  String get oldPassword => 'Old password';

  @override
  String get new_password => 'A new password';

  @override
  String get error_password => 'Password is not in the correct format';

  @override
  String get confirm_new_password => 'Confirm new password';

  @override
  String get update => 'Update';

  @override
  String get notify => 'Notify';

  @override
  String get changePassSuccessMes => 'Change password successfully';

  @override
  String get close => 'Close';

  @override
  String get forgot_password_title => 'Forgot password';

  @override
  String get forgot_password_page_content => 'The link code will be sent to your email. Use the link code to verify your account';

  @override
  String get send_request => 'Send request';

  @override
  String get title_create_password => 'Create a new password';

  @override
  String get validateConfirmPass => 'Password must contain 8-50 characters, must contain numeric characters, accented letters including lowercase and uppercase letters and other special characters.';

  @override
  String get agree => 'Agree';

  @override
  String get rememberPass => 'Remember password';

  @override
  String get forgot_password => 'Forgot password?';

  @override
  String get log_in_to_another_account => 'Log in to another account';

  @override
  String get invalid_username => 'Invalid username';

  @override
  String get mess_notification_request_mail => 'Submit request successfully, information has been sent to your Email';

  @override
  String get noData => 'No data';

  @override
  String production_order_status(String section) {
    String _temp0 = intl.Intl.selectLogic(
      section,
      {
        'APPROVED': 'Approved',
        'WAIT_APPROVE': 'Wait approve',
        'REJECTED': 'Rejected',
        'other': 'All',
      },
    );
    return '$_temp0';
  }

  @override
  String get approve_order => 'Phê duyệt lệnh';

  @override
  String get refuse => 'Refuse';

  @override
  String get approve => 'Approve';

  @override
  String get unit_excute => 'Đơn vị thực hiện';

  @override
  String get unit_order_delivery => 'Đơn vị giao lệnh';

  @override
  String get list_prod_order => 'Danh sách lệnh sản xuất';

  @override
  String get general_info => 'Thông tin chung';

  @override
  String get direct_block => 'Khối trực tiếp';

  @override
  String get indirect_block => 'Khối gián tiếp';

  @override
  String get number_signal => 'Số hiệu';

  @override
  String get name_order => 'Tên lệnh';

  @override
  String get start_date => 'Ngày bắt đầu';

  @override
  String get end_date => 'Ngày kết thúc';

  @override
  String get base_order => 'Căn cứ ra lệnh sản xuất';

  @override
  String get note => 'Ghi chú';

  @override
  String get file_attach => 'File đính kèm';

  @override
  String get stage_mission => 'Chặng - nhiệm vụ';

  @override
  String get quantity => 'Số lượng';

  @override
  String get priority => 'Ưu tiên';

  @override
  String get time => 'Thời gian';

  @override
  String get send => 'Gửi';

  @override
  String get input_reason_refuse => 'Nhập lý do từ chối';

  @override
  String get reason => 'Lý do từ chối';

  @override
  String get input_reason => 'Nhập lý do';

  @override
  String get approve_success => 'Phê duyệt thành công';

  @override
  String get refuse_success => 'Từ chối thành công';

  @override
  String get approve_fail => 'Phê duyệt thất bại';

  @override
  String get refuse_fail => 'Từ chối thất bại';

  @override
  String get connection_timeout => 'Connection timeout';

  @override
  String get something_went_wrong => 'Something went wrong';

  @override
  String get error_noti => 'Error';

  @override
  String get you_are_offline => 'You are offline';

  @override
  String get connection_lost_desc => 'The connection to the system is temporarily interrupted. Please try again later.';

  @override
  String get updateAvailabe => 'Update available';

  @override
  String get updateContent => 'A new version is available. Please update to the latest version to experience the best features.';
}
