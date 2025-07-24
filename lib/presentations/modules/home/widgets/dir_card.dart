import 'package:crm_gt/apps/app_assets.dart';
import 'package:flutter/material.dart';

import '../../../../domains/entities/dir/dir_entities.dart';

class DirCard extends StatelessWidget {
  const DirCard({super.key, required this.dirEntities, required this.onTap});
  final DirEntities dirEntities;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap?.call();
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(20)),
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.only(
          left: 10,
          right: 10,
          top: 10,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                AppImage.icFolder(height: 50, width: 50),
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 13),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dirEntities.name ?? '',
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: Text(
                          dirEntities.createdAt ?? '',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.grey,
            )
          ],
        ),
      ),
    );
  }
}
