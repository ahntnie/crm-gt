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
  void onInit(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessageCubit>().getInit(idDir);
    });
    super.onInit(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessageCubit, MessageState>(
      listener: (context, state) {
        // if (state.isConnected) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text('Đã kết nối đến WebSocket'),
        //       backgroundColor: Theme.of(context).colorScheme.primary,
        //       duration: Duration(seconds: 2),
        //     ),
        //   );
        // } else if (state.error != null && !state.isConnected) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(
        //       content: Text(state.error!),
        //       backgroundColor: Theme.of(context).colorScheme.error,
        //       duration: Duration(seconds: 3),
        //     ),
        //   );
        // }
      },
      builder: (context, state) {
        final cubit = context.read<MessageCubit>();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Text(
              'Trò chuyện', // Có thể thay bằng tên người nhận hoặc nhóm dựa trên idDir
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            centerTitle: true,
            leading: IconButton(
              onPressed: () async {
                AppNavigator.pop();
              },
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            elevation: 0,
          ),
          body: Column(
            children: [
              // Hiển thị lỗi nếu có
              if (state.error != null)
                Container(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.error!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.error,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              // Chat messages area
              Expanded(
                child: state.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: () => cubit.getInit(idDir),
                        child: ListView.builder(
                          reverse: true,
                          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                          itemCount: state.listMessage.length,
                          itemBuilder: (context, index) {
                            final mess = state.listMessage[state.listMessage.length - 1 - index];
                            return MessageItem(mess: mess);
                          },
                        ),
                      ),
              ),
              // Input area
              _buildInputArea(context, cubit),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputArea(BuildContext context, MessageCubit cubit) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                child: TextField(
                  controller: cubit.messageController,
                  onChanged: cubit.messageChanged,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: 'Nhập tin nhắn...',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surfaceVariant,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => cubit.onTapSendMessage(),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: cubit.onTapSendMessage,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Icon(
                    Icons.send,
                    color: Theme.of(context).colorScheme.onPrimary,
                    size: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
