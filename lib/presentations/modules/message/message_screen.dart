import 'package:crm_gt/presentations/modules/message/components/message_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/message_cubit.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key, required this.idDir});
  final String idDir;
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MessageCubit(),
      child: MessageView(
        idDir: idDir,
      ),
    );
  }
}
