class BaseDataResponse {
  int? status;
  String? msg;
  dynamic data;

  BaseDataResponse({
    this.msg,
    this.status,
    this.data = const [],
  });

  factory BaseDataResponse.fromJson(Map<String, dynamic> json) => BaseDataResponse(
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
