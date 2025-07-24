import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:crm_gt/domains/usecases/home/home_usecase.dart';
import 'package:crm_gt/domains/usecases/message/message_usecase.dart';
import 'package:equatable/equatable.dart';

import '../../../../domains/entities/message/message_entities.dart';

part 'message_state.dart';

class MessageCubit extends Cubit<MessageState> {
  final homeUsecase = getIt.get<HomeUsecase>();
  MessageCubit() : super(MessageInitial());
  final _useCase = getIt.get<MessageUseCase>();
  Future<void> getInit(String idDir) async {
    List<MessageEntities> listData = await _useCase.getChatThreadByIdDir(idDir);
    emit(state.copyWith(listMessage: listData, idDir: idDir));
  }
}
