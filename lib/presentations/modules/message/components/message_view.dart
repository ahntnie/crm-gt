import 'package:crm_gt/presentations/modules/message/widgets/message_item.dart';
import 'package:crm_gt/presentations/routes.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

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
        // Giữ nguyên listener nếu cần
      },
      builder: (context, state) {
        final cubit = context.read<MessageCubit>();

        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amber,
            title: Text(
              'Trò chuyện',
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
                            final sentAt =
                                mess.sentAt != null ? DateTime.parse(mess.sentAt!).toLocal() : null;

                            bool showTime = true;
                            bool showUserName = true;
                            if (index > 0) {
                              final prevMess = state.listMessage[state.listMessage.length - index];
                              final prevSentAt = prevMess.sentAt != null
                                  ? DateTime.parse(prevMess.sentAt!).toLocal()
                                  : null;
                              if (sentAt != null &&
                                  prevSentAt != null &&
                                  prevMess.userId == mess.userId &&
                                  sentAt.difference(prevSentAt).inSeconds.abs() < 60) {
                                showTime = false;
                                showUserName = false;
                              }
                            }

                            bool showDate = false;
                            if (index == state.listMessage.length - 1) {
                              showDate = true;
                            } else {
                              final nextMess =
                                  state.listMessage[state.listMessage.length - 2 - index];
                              final nextSentAt = nextMess.sentAt != null
                                  ? DateTime.parse(nextMess.sentAt!).toLocal()
                                  : null;
                              if (sentAt != null &&
                                  nextSentAt != null &&
                                  !isSameDay(sentAt, nextSentAt)) {
                                showDate = true;
                              }
                            }

                            return MessageItem(
                              mess: mess,
                              showTime: showTime,
                              showDate: showDate,
                              showName: showUserName,
                            );
                          },
                        ),
                      ),
              ),
              _buildInputArea(context, cubit),
            ],
          ),
        );
      },
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  Widget _buildInputArea(BuildContext context, MessageCubit cubit) {
    return BlocBuilder<MessageCubit, MessageState>(
      builder: (context, state) {
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
            child: Column(
              children: [
                if (state.selectedFiles.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: state.selectedFiles.map((file) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (file.path.endsWith('.jpg') ||
                                file.path.endsWith('.jpeg') ||
                                file.path.endsWith('.png'))
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  file,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                ),
                              )
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  file.path.split('/').last,
                                  style: const TextStyle(fontSize: 14),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            IconButton(
                              icon: const Icon(Icons.close, size: 20),
                              onPressed: () {
                                final updatedFiles = List<File>.from(state.selectedFiles)
                                  ..remove(file);
                                cubit.emit(state.copyWith(selectedFiles: updatedFiles));
                              },
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () async {
                        cubit.selectFile();
                      },
                      icon: const Icon(Icons.add_circle_outline),
                    ),
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
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              ],
            ),
          ),
        );
      },
    );
  }
}
