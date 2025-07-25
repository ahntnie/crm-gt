import 'package:crm_gt/presentations/modules/home/cubit/home_cubit.dart';
import 'package:crm_gt/presentations/modules/home/widgets/dir_card.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../routes.dart';

class HomeView extends BaseWidget {
  const HomeView({super.key});

  @override
  onInit(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeCubit>().getInit();
    });
    return super.onInit(context);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.watch<HomeCubit>();
    return Scaffold(
      appBar: AppBar(
        leading: cubit.state.currentDir != null
            ? IconButton(
                onPressed: () async {
                  await cubit.getCurrentDir(cubit.state.currentDir?.parentId);
                  if (cubit.state.currentDir?.id == null) {
                    cubit.getDirByLevel('0');
                  } else {
                    cubit.getDirByParentId(cubit.state.currentDir!.id!);
                  }
                },
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ))
            : null,
        centerTitle: true,
        backgroundColor: Colors.amber,
        title: Text(
          cubit.state.currentDir == null
              ? 'CRM GT'
              : cubit.state.currentDir!.level == '1'
                  ? '${cubit.state.currentDir!.parentName ?? ''} > ${cubit.state.currentDir!.name!}'
                  : cubit.state.currentDir!.name!,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        actions: [
          if (cubit.state.currentDir?.level == '1')
            IconButton(
              onPressed: () {
                _showAddMemberDialog(context);
              },
              icon: const Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          if (cubit.state.currentDir?.level == '1')
            IconButton(
              onPressed: () {
                AppNavigator.pushNamed(Routes.message.path, cubit.state.currentDir!.id);
              },
              icon: const Icon(
                Icons.message,
                color: Colors.white,
              ),
            )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => cubit.state.currentDir == null
            ? cubit.getDirByLevel('0')
            : cubit.getDirByParentId(cubit.state.currentDir!.id.toString()),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView.builder(
            itemCount: cubit.state.listDir.length,
            itemBuilder: (context, index) {
              return DirCard(
                dirEntities: cubit.state.listDir[index],
                onTap: () {
                  cubit.changeCurrentDir(cubit.state.listDir[index]);
                  cubit.getDirByParentId(cubit.state.listDir[index].id ?? '');
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: cubit.state.currentDir == null
          ? FloatingActionButton(
              onPressed: () {
                _showAddDirDialog(context);
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  void _showAddMemberDialog(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm thành viên'),
        content: TextField(
          controller: cubit.phoneController,
          onChanged: cubit.changePhone,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Số điện thoại',
            hintText: 'Nhập số điện thoại',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly, // Chỉ cho phép nhập số
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Đóng dialog
              //cubit.phoneController.dispose(); // Dispose controller
            },
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final phoneNumber = cubit.phoneController.text.trim();
              if (phoneNumber.isNotEmpty) {
                print('Thêm thành viên với số: $phoneNumber');
                print(cubit.state.currentDir?.id);
                cubit.invatedToChat(cubit.state.currentDir!.id!, phoneNumber);
                Navigator.of(context).pop();
                // cubit.phoneController.dispose();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Vui lòng nhập số điện thoại'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            child: const Text('Thêm vào'),
          ),
        ],
      ),
    );
  }

  void _showAddDirDialog(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm thư mục'),
        content: TextField(
          controller: cubit.nameDirController,
          onChanged: cubit.changeDirName,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Tên thư mục',
            hintText: 'Nhập tên thư mục',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              final dirName = cubit.nameDirController.text.trim();
              if (dirName.isNotEmpty) {
                print('Thêm thư mục tên: $dirName');
                cubit.createDir();
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Vui lòng nhập tên thư mục'),
                    backgroundColor: Theme.of(context).colorScheme.error,
                  ),
                );
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }
}
