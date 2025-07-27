import 'package:core/core.dart';
import 'package:crm_gt/domains/entities/message/message_entities.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageItem extends BaseWidget {
  final MessageEntities mess;
  final bool showTime;
  final bool showDate;
  final bool showName;

  const MessageItem({
    super.key,
    required this.mess,
    this.showTime = true,
    this.showDate = false,
    this.showName = true,
  });

  @override
  Widget build(BuildContext context) {
    print('showName: $showName');
    print('showTime: $showTime');
    print('showDate: $showDate');
    print(mess.userName);
    print('--------------');

    final isMyMessage = AppSP.get('account').toString() == mess.userId;
    final hasFile = mess.fileUrl != null && mess.fileUrl!.isNotEmpty;
    final isImage = hasFile && (mess.fileType == 'image/jpeg' || mess.fileType == 'image/png');
    final sentAt = mess.sentAt != null ? DateTime.parse(mess.sentAt!).toLocal() : null;
    final timeFormatter = DateFormat('HH:mm');

    String formatDate(DateTime? date) {
      if (date == null) return '';
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final messageDate = DateTime(date.year, date.month, date.day);
      final difference = today.difference(messageDate).inDays;

      if (difference == 0) {
        return 'Hôm nay';
      } else if (difference == 1) {
        return 'Hôm qua';
      } else {
        return DateFormat('EEEE, dd/MM/yyyy', 'vi_VN').format(date);
      }
    }

    return Column(
      children: [
        if (showDate && sentAt != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              formatDate(sentAt),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        Align(
          alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: isMyMessage ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (!isMyMessage && mess.userName != null && showName)
                  Padding(
                    padding: const EdgeInsets.only(left: 20, bottom: 4),
                    child: Text(
                      mess.userName!,
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                  ),
                Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width / 3 * 2,
                  ),
                  decoration: BoxDecoration(
                    color: isMyMessage ? Colors.amber : Colors.grey[350],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (hasFile && isImage)
                        ClipRRect(
                          borderRadius: BorderRadius.vertical(
                            top: const Radius.circular(15),
                            bottom: mess.message!.isEmpty ? const Radius.circular(15) : Radius.zero,
                          ),
                          child: Image.network(
                            mess.fileUrl!,
                            fit: BoxFit.cover,
                            width: MediaQuery.of(context).size.width / 3 * 2,
                            height: MediaQuery.of(context).size.width / 3,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      if (hasFile && !isImage)
                        GestureDetector(
                          onTap: () {
                            // TODO: Thêm hành động mở/tải file, ví dụ: mở URL hoặc tải file
                            print('Nhấn vào file: ${mess.fileName}');
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.vertical(
                                top: const Radius.circular(15),
                                bottom:
                                    mess.message!.isEmpty ? const Radius.circular(15) : Radius.zero,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.insert_drive_file,
                                  size: 24,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    mess.fileName ?? 'File không xác định',
                                    style: const TextStyle(fontSize: 14),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      if (hasFile && mess.message != null && mess.message!.isNotEmpty)
                        const Padding(
                          padding: EdgeInsets.all(8),
                          child: SizedBox(height: 1),
                        ),
                      if (mess.message != null && mess.message!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            mess.message!,
                            style: const TextStyle(fontSize: 17),
                          ),
                        ),
                      if (showTime && sentAt != null)
                        Padding(
                          padding: const EdgeInsets.only(right: 8, bottom: 4, left: 8),
                          child: Text(
                            timeFormatter.format(sentAt),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                            textAlign: isMyMessage ? TextAlign.right : TextAlign.left,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
