import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:crm_gt/domains/entities/dir/dir_entities.dart';
import 'package:crm_gt/domains/usecases/home/home_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../domains/entities/user/user_entities.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final homeUsecase = getIt.get<HomeUsecase>();
  HomeCubit() : super(const HomeInitial());

  TextEditingController phoneController = TextEditingController();
  TextEditingController nameDirController = TextEditingController();

  Future<List<DirEntities>> getAllDir() async {
    final listDir = await homeUsecase.getAllDir();
    return listDir;
  }

  Future<List<DirEntities>> getDirByLevel(String level) async {
    final listDir = await homeUsecase.getDirByLevel(level);
    emit(state.copyWith(listDir: listDir));
    return listDir;
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
    final listDir =
        await getDirByLevel(state.currentDir == null ? '0' : state.currentDir!.level.toString());
    UserEntities userInfo =
        UserEntities.fromJson(jsonDecode(AppSP.get('user_info')) as Map<String, dynamic>);
    emit(state.copyWith(listDir: listDir, userInfo: userInfo));
  }

  Future<void> invatedToChat(String id, String phone) async {
    String msg = await homeUsecase.invatedToChat(id, phone);
    print('Mời xong là: $msg');
  }

  Future<void> createDir() async {
    UserEntities userInfo =
        UserEntities.fromJson(jsonDecode(AppSP.get('user_info')) as Map<String, dynamic>);
    print('nameee: ${state.nameDir}');
    await homeUsecase.createDir(state.nameDir ?? '', userInfo.id.toString());
    
  }
}
