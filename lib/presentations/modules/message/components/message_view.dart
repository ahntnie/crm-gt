import 'package:crm_gt/domains/entities/message/message_entities.dart';
import 'package:crm_gt/presentations/modules/message/widgets/message_item.dart';
import 'package:crm_gt/presentations/routes.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/message_cubit.dart';

class MessageView extends BaseWidget {
  const MessageView({super.key, required this.idDir});
  final String idDir;
  @override
  onInit(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessageCubit>().getInit(idDir);
    });
    return super.onInit(context);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<MessageCubit>();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.amber,
          title: const Text(
            'Trò chuyện',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              AppNavigator.pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          )),
      body: RefreshIndicator(
        onRefresh: () => cubit.getInit(idDir),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: cubit.state.listMessage.length,
            itemBuilder: (context, index) {
              MessageEntities mess = cubit.state.listMessage[index];
              return MessageItem(mess: mess);
            },
          ),
        ),
      ),
    );
  }
}
