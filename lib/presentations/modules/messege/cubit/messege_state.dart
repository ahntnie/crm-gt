part of 'messege_cubit.dart';

class MessegeState extends Equatable {
  final List<MessegeEntities> listMessege;
  final String? idDir;
  final String? messege;
  final bool isLoading;
  final String? error;
  final bool isConnected;
  final List<File> selectedFiles; // Thay đổi từ selectedFile thành selectedFiles
  final List<UserEntities> listUsers;
  const MessegeState({
    this.listMessege = const [],
    this.idDir,
    this.messege,
    this.isLoading = false,
    this.error,
    this.isConnected = false,
    this.selectedFiles = const [], // Mặc định là danh sách rỗng
    this.listUsers = const [],
  });

  @override
  List<Object?> get props =>
      [listMessege, idDir, messege, isLoading, error, isConnected, selectedFiles, listUsers];

  MessegeState copyWith({
    List<MessegeEntities>? listMessege,
    String? idDir,
    String? messege,
    bool? isLoading,
    String? error,
    bool? isConnected,
    List<File>? selectedFiles,
    List<UserEntities>? listUsers,
  }) {
    return MessegeState(
      listMessege: listMessege ?? this.listMessege,
      idDir: idDir ?? this.idDir,
      messege: messege ?? this.messege,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isConnected: isConnected ?? this.isConnected,
      selectedFiles: selectedFiles ?? this.selectedFiles,
      listUsers: listUsers ?? this.listUsers,
    );
  }
}

final class MessegeInitial extends MessegeState {}
