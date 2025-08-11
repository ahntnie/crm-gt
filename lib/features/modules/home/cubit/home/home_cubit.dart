import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:crm_gt/data/models/request/authentication/logout_request.dart';
import 'package:crm_gt/domains/entities/dir/dir_entities.dart';
import 'package:crm_gt/domains/usecases/authentication/logout_usecase.dart';
import 'package:crm_gt/domains/usecases/home/home_usecase.dart';
import 'package:crm_gt/features/routes.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../domains/entities/user/user_entities.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final homeUsecase = getIt.get<HomeUsecase>();
  HomeCubit() : super(const HomeInitial());
  final logoutUseCase = getIt.get<LogoutUsecase>();

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameDirController = TextEditingController();
  getRole() {
    UserEntities userInfo =
        UserEntities.fromJson(jsonDecode(AppSP.get('user_info')) as Map<String, dynamic>);
    emit(state.copyWith(userInfo: userInfo));
    final role = userInfo.role.toString();
    print('Role: $role');
    return role;
  }

  Future<List<DirEntities>> getAllDir() async {
    final listDir = await homeUsecase.getAllDir();
    return listDir;
  }

  Future<List<DirEntities>> getDirByLevel(String level) async {
    emit(state.copyWith(isLoading: true)); // Bắt đầu loading
    try {
      final listDir = await homeUsecase.getDirByLevel(level);
      emit(state.copyWith(listDir: listDir, isLoading: false)); // Kết thúc loading
      print('List listDir fetched successfully: ${listDir.length}');

      return listDir;
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      rethrow;
    }
  }

  Future<List<DirEntities>> getDirByParentId(String parentId) async {
    final listDir = await homeUsecase.getDirByParentId(parentId);
    emit(state.copyWith(listDir: listDir, currentDir: state.currentDir));
    return listDir;
  }

  void changeCurrentDir(DirEntities? dir) {
    print('Vào change: ${dir?.name}');
    emit(state.copyWith(currentDir: dir));
  }

  Future<void> getCurrentDir(String? id) async {
    if (id != null) {
      print('Current Dir: ${id}');
      DirEntities currentDir = await homeUsecase.getDirById(id);

      emit(state.copyWith(currentDir: currentDir));
    } else {
      print('Vô elseee');
      emit(state.copyWith(currentDir: null));
    }
  }

  void changePhone(String value) {
    emit(state.copyWith(phone: value, currentDir: state.currentDir));
  }

  void changeDirName(String value) {
    emit(state.copyWith(nameDir: value, currentDir: state.currentDir));
  }

  Future<void> getInit() async {
    getRole(); //
    emit(state.copyWith(isLoading: true)); // Bắt đầu loading
    try {
      final listDir = await getDirByLevel(
        state.currentDir == null ? '0' : state.currentDir!.level.toString(),
      );
      UserEntities userInfo = UserEntities.fromJson(
        jsonDecode(AppSP.get('user_info')) as Map<String, dynamic>,
      );
      emit(state.copyWith(
        listDir: listDir,
        userInfo: userInfo,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(isLoading: false));
      rethrow;
    }
  }

  Future<String> invatedToChat(String id, String phone) async {
    String msg = await homeUsecase.invatedToChat(id, phone);
    print('Mời xong là: $msg');
    return msg; // Trả về message để UI có thể hiển thị
  }

  Future<void> createDir() async {
    UserEntities userInfo =
        UserEntities.fromJson(jsonDecode(AppSP.get('user_info')) as Map<String, dynamic>);
    print('nameee: ${state.nameDir}');
    await homeUsecase.createDir(state.nameDir ?? '', userInfo.id.toString());
  }

  Future<void> onTapLogout() async {
    try {
      final logoutRequest = LogoutRequest(fcmToken: AppSP.get('fcm_token') ?? '');
      await logoutUseCase.requestLogout(logoutRequest);
    } catch (_) {
      // Có thể log lỗi nếu muốn
    }
    // Luôn xóa token và user info local
    await AppSecureStorage.clearToken();
    await AppSP.remove('account');
    await AppSP.remove('user_info');
    AppNavigator.go(Routes.login);
  }
}
