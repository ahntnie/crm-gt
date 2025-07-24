import 'package:core/core.dart';
import 'package:crm_gt/presentations/modules/home/cubit/home_cubit.dart';
import 'package:crm_gt/presentations/modules/home/widgets/dir_card.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:flutter/material.dart';
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
                //AppNavigator.pushNamed(Routes.message.path, cubit.state.currentDir!.id);
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
                  // cubit.getDirByParentId(cubit.state.listDir[index].id ?? '');
                  // cubit.changeCurrentDir(cubit.state.listDir[index]);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        print('hahaha: ${AppSP.get('account')}');
        // print('Thư mục current: ${cubit.state.currentDir?.toJson() ?? 'Không có'}');
        //cubit.getDirByLevel('0');
      }),
    );
  }
}
