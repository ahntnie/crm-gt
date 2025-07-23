class DirDataResponse {
  int? status;
  String? msg;
  dynamic data;

  DirDataResponse({
    this.msg,
    this.status,
    this.data = const [],
  });

  factory DirDataResponse.fromJson(Map<String, dynamic> json) => DirDataResponse(
        status: json["status"],
        msg: json["msg"],
        data: json["data"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data,
      };
}
