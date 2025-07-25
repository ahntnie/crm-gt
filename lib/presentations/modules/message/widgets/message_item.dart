import 'package:core/core.dart';
import 'package:crm_gt/domains/entities/message/message_entities.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:flutter/material.dart';

class MessageItem extends BaseWidget {
  final MessageEntities mess;
  const MessageItem({super.key, required this.mess});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AppSP.get('account').toString() == mess.userId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (AppSP.get('account').toString() != mess.userId)
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(mess.userName ?? ''),
              ),
            Container(
              width: MediaQuery.of(context).size.width / 3 * 2,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppSP.get('account').toString() == mess.userId
                    ? Colors.amber
                    : Colors.grey[350],
                // border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.network(
                      fit: BoxFit.fill,
                      mess.fileUrl ?? '',
                      height: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      mess.message ?? '',
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
