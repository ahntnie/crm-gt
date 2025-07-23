import 'package:crm_gt/data/models/response/authentication/login_data_response.dart';
import 'package:equatable/equatable.dart';

class Login extends Equatable {
  final LoginDataResponse? data;

  const Login({
    this.data,
  });

  @override
  List<Object?> get props => [
        data,
      ];
}
