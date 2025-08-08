import 'package:crm_gt/data/models/response/authentication/Logout_data_response.dart';
import 'package:equatable/equatable.dart';

class Logout extends Equatable {
  final LogoutDataResponse? data;

  const Logout({
    this.data,
  });

  @override
  List<Object?> get props => [
        data,
      ];
}
