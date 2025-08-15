final class ApiEndpoints {
  // Authentications
  static const String logout = "logout";
  static const String login = "login";
  static const String getDirFromProductModel = "GetDir_FromProductModel";
  static const String getDirByLevel = "GetDir_ByLevel/{level}";
  static const String getDirById = "GetDirById/{id}";
  static const String getInfoCustomerFromToken = "GetInfoCustomer_FromToken";
  static const String getChatThread = "GetChatThread/{id_dir}";
  static const String invatedToChat = "InvatedToChat";
  static const String createFullDirStructureAPI = "CreateFullDirStructureAPI";
  static const String getUnreadNotification = "GetUnreadNotification/{id}";
  static const String changeUserName = "changeUserName";
  static const String changePassWord = "changePassWord";
  static const String getAttachmentByDirId = "GetAttachmentsByThreadId/{id}";
  static const String uploadAttachment = "UploadAttachments";
  static const String getUserFromChatThread = "GetUserFromChatThread/{id}";


  
  static const String createProgress = "CreateProgress";
  static const String updateProgress = "UpdateProgress";
  static const String getProgressById = "GetProgressById/{id}";
  static const String getProgressByDirId = "GetProgressByDirId/{id}";
}
