import 'dart:io';

import 'package:crm_gt/apps/app_colors.dart';
import 'package:crm_gt/core/services/current_screen_service.dart';
import 'package:crm_gt/features/modules/messege/widgets/messege_item.dart';
import 'package:crm_gt/features/routes.dart';
import 'package:crm_gt/widgets/base_widget.dart';
import 'package:crm_gt/widgets/swipe_back_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/messege_cubit.dart';

class MessegeView extends BaseWidget {
  const MessegeView({super.key, required this.idDir});
  final String idDir;

  @override
  void onInit(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MessegeCubit>().getInit(idDir);
      // Cập nhật trạng thái màn hình hiện tại
      CurrentScreenService().setCurrentScreen('messege');
      CurrentScreenService().setCurrentThread(idDir);
    });
    super.onInit(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessegeCubit, MessegeState>(
      listener: (context, state) {
        // Giữ nguyên listener nếu cần
      },
      builder: (context, state) {
        final cubit = context.read<MessegeCubit>();
        return _MessegeViewContent(
          state: state,
          cubit: cubit,
          idDir: idDir,
        );
      },
    );
  }
}

class _MessegeViewContent extends StatefulWidget {
  final MessegeState state;
  final MessegeCubit cubit;
  final String idDir;

  const _MessegeViewContent({
    required this.state,
    required this.cubit,
    required this.idDir,
  });

  @override
  State<_MessegeViewContent> createState() => _MessegeViewContentState();
}

class _MessegeViewContentState extends State<_MessegeViewContent> with WidgetsBindingObserver {
  bool _showAllTimestamps = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Xóa trạng thái khi rời khỏi màn hình
    CurrentScreenService().clearCurrentThread();
    CurrentScreenService().clearCurrentScreen();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // Khi app quay lại foreground, cập nhật lại trạng thái
        CurrentScreenService().setCurrentScreen('messege');
        CurrentScreenService().setCurrentThread(widget.idDir);
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        // Khi app vào background, xóa trạng thái để nhận thông báo
        CurrentScreenService().clearCurrentThread();
        CurrentScreenService().clearCurrentScreen();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _toggleTimestamps() {
    setState(() {
      _showAllTimestamps = !_showAllTimestamps;
    });

    // Auto hide after 3 seconds
    if (_showAllTimestamps) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showAllTimestamps = false;
          });
        }
      });
    }
  }

  void _hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    FocusScope.of(context).unfocus();
  }

  void _showFilePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              // Title
              const Text(
                'Chọn tệp đính kèm',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),

              // Options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // Option 1: Thư viện ảnh
                    _buildOptionTile(
                      context: context,
                      icon: Icons.photo_library,
                      title: 'Thư viện ảnh',
                      subtitle: 'Chọn ảnh từ thư viện',
                      onTap: () {
                        Navigator.pop(context);
                        widget.cubit.selectImagesFromGallery();
                      },
                    ),
                    const SizedBox(height: 12),

                    // Option 2: Tệp
                    _buildOptionTile(
                      context: context,
                      icon: Icons.folder_open,
                      title: 'Chọn tệp',
                      subtitle: 'Chọn tệp từ thiết bị',
                      onTap: () {
                        Navigator.pop(context);
                        widget.cubit.selectFiles();
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cempedak101.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: AppColors.cempedak101,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey[400],
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SwipeBackWrapper(
        onSwipeBack: () => AppNavigator.pop(),
        child: GestureDetector(
          onTap: _hideKeyboard,
          child: BlocListener<MessegeCubit, MessegeState>(
            listenWhen: (previous, current) => previous.error != current.error,
            listener: (context, state) {
              if (state.error != null) {
                if (state.error == 'connected_success') {
                  _showSuccessSnackBar(context, 'Đã kết nối lại thành công');
                } else {
                  _showErrorSnackBar(context, state.error!);
                }
              }
            },
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: AppColors.cempedak101,
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
                    Icons.arrow_back_ios_new,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
                elevation: 0,
                actions: [
                  // Connection status indicator
                  BlocBuilder<MessegeCubit, MessegeState>(
                    buildWhen: (previous, current) => previous.isConnected != current.isConnected,
                    builder: (context, state) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8, top: 12, bottom: 12),
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: state.isConnected
                              ? Colors.green.withOpacity(0.2)
                              : Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: state.isConnected ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              state.isConnected ? 'Online' : 'Offline',
                              style: TextStyle(
                                color: AppColors.mono0,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  IconButton(
                    onPressed: () async {
                      // Lấy tên group chat (DirEntities) theo idDir
                      final dir = await widget.cubit.homeUsecase.getDirById(widget.idDir);
                      await widget.cubit.getUserFromChatThread(widget.idDir);
                      if (mounted) {
                        AppNavigator.router.push(
                          Routes.groupChatDetail.path,
                          extra: {
                            'users': widget.cubit.state.listUsers,
                            'messages': widget.cubit.state.listMessege,
                            'groupName': (dir.level == '0' ? dir.name : null) ?? 'Tên Nhóm',
                          },
                        );
                      }
                    },
                    icon: const Icon(
                      Icons.info_outline,
                      color: AppColors.mono0,
                    ),
                  ),
                ],
              ),
              body: Column(
                children: [
                  Expanded(
                    child: widget.state.isLoading && widget.state.listMessege.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.cempedak101),
                            ),
                          )
                        : widget.state.listMessege.isEmpty
                            ? _buildEmptyState()
                            : RefreshIndicator(
                                onRefresh: () => widget.cubit.getInit(widget.idDir),
                                color: AppColors.cempedak101,
                                child: ListView.builder(
                                  reverse: true,
                                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                                  itemCount: widget.state.listMessege.length,
                                  itemBuilder: (context, index) {
                                    final mess = widget.state
                                        .listMessege[widget.state.listMessege.length - 1 - index];
                                    final sentAt = mess.sentAt != null
                                        ? DateTime.parse(mess.sentAt!).toLocal()
                                        : null;

                                    bool showTime = true;
                                    bool showUserName = true;
                                    bool isFirstInGroup = true;

                                    // Logic sửa lại: So sánh với tin nhắn TIẾP THEO (về phía cuối danh sách)
                                    if (index < widget.state.listMessege.length - 1) {
                                      final nextMess = widget.state
                                          .listMessege[widget.state.listMessege.length - 2 - index];
                                      final nextSentAt = nextMess.sentAt != null
                                          ? DateTime.parse(nextMess.sentAt!).toLocal()
                                          : null;

                                      // Nếu tin nhắn tiếp theo cùng người gửi và trong vòng 60 giây
                                      if (sentAt != null &&
                                          nextSentAt != null &&
                                          nextMess.userId == mess.userId &&
                                          nextSentAt.difference(sentAt).inSeconds.abs() < 60) {
                                        showTime = false;
                                        showUserName = false;
                                        isFirstInGroup = false; // Không phải tin nhắn đầu tiên
                                      }
                                    }

                                    bool showDate = false;
                                    if (index == widget.state.listMessege.length - 1) {
                                      showDate = true;
                                    } else {
                                      final nextMess = widget.state
                                          .listMessege[widget.state.listMessege.length - 2 - index];
                                      final nextSentAt = nextMess.sentAt != null
                                          ? DateTime.parse(nextMess.sentAt!).toLocal()
                                          : null;
                                      if (sentAt != null &&
                                          nextSentAt != null &&
                                          !isSameDay(sentAt, nextSentAt)) {
                                        showDate = true;
                                      }
                                    }

                                    return MessegeItem(
                                      mess: mess,
                                      showTime: showTime,
                                      showDate: showDate,
                                      showName: showUserName,
                                      forceShowTime: _showAllTimestamps,
                                      onLongPress: _toggleTimestamps,
                                      isFirstInGroup: isFirstInGroup,
                                    );
                                  },
                                ),
                              ),
                  ),
                  _buildInputArea(context, widget.cubit, widget.state),
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có tin nhắn nào',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy bắt đầu cuộc trò chuyện',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(BuildContext context, MessegeCubit cubit, MessegeState state) {
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
              Container(
                height: 80,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.selectedFiles.length,
                  itemBuilder: (context, index) {
                    final file = state.selectedFiles[index];
                    final isImage = _isImageFile(file);
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[300]!),
                      ),
                      child: Stack(
                        children: [
                          if (isImage)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                file,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[200],
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            )
                          else
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.insert_drive_file,
                                    size: 32,
                                    color: Colors.grey[600],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _getFileExtension(file.path).replaceAll('.', '').toUpperCase(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                cubit.removeSelectedFile(file);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: AppColors.mono0,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cempedak101.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    onPressed: state.isLoading
                        ? null
                        : () {
                            _showFilePickerOptions(context);
                          },
                    icon: state.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.cempedak101),
                            ),
                          )
                        : const Icon(
                            Icons.add_circle_outline,
                            color: AppColors.cempedak101,
                            size: 28,
                          ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 120),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: TextField(
                      controller: cubit.messegeController,
                      onChanged: cubit.messegeChanged,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.newline,
                      enabled: !state.isLoading,
                      decoration: InputDecoration(
                        hintText: state.isLoading ? 'Đang xử lý...' : 'Nhập tin nhắn...',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        filled: true,
                        fillColor: AppColors.mono0,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: state.isLoading ? null : (_) => cubit.onTapSendMessege(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                if ((cubit.messegeController.text.isNotEmpty ||
                        cubit.state.selectedFiles.isNotEmpty) &&
                    !state.isLoading)
                  Material(
                    color: AppColors.cempedak101,
                    borderRadius: BorderRadius.circular(24),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(24),
                      onTap: cubit.onTapSendMessege,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        child: const Icon(
                          Icons.send,
                          color: AppColors.mono0,
                          size: 24,
                        ),
                      ),
                    ),
                  )
                else if (state.isLoading)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.grey,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  message.contains('kết nối')
                      ? Icons.signal_wifi_connected_no_internet_4
                      : Icons.error_outline,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      message.contains('kết nối') ? 'Mất kết nối' : 'Thông báo',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        backgroundColor: message.contains('kết nối')
            ? const Color(0xFFFF8C00) // Orange
            : const Color(0xFFE53E3E), // Red
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        duration: Duration(
          seconds: message.contains('kết nối lại')
              ? 3
              : message.contains('kết nối')
                  ? 4
                  : 5,
        ),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  void _showSuccessSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: const Color(0xFF22C55E), // Green
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        duration: const Duration(seconds: 2),
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  bool _isImageFile(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(extension);
  }

  String _getFileExtension(String filePath) {
    final parts = filePath.split('.');
    return parts.length > 1 ? '.${parts.last.toLowerCase()}' : '';
  }
}
