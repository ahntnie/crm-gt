import 'dart:ui';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> with SuperAppConn {
  AppCubit() : super(AppInitial());

  @override
  onEvent(MiniAppEvent event, [data]) async {
    switch (event) {
      default:
    }
  }
}
