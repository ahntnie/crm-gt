class LogoutDataResponse {
  int? status;
  String? msg;

  LogoutDataResponse({
    this.msg,
    this.status,
  });

  factory LogoutDataResponse.fromJson(Map<String, dynamic> json) => LogoutDataResponse(
        status: json["status"],
        msg: json["msg"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
      };

  LogoutDataResponse copyWith({int? status, String? msg}) {
    return LogoutDataResponse(
      status: status ?? this.status,
      msg: msg ?? this.msg,
    );
  }
}
