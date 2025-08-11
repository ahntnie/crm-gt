// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'main_tab_cubit.dart';

class MainTabState extends Equatable {
  final int currentIndex;
  final bool isActiveFAB;
  final String? notiUnRead;
  final String deviceId;
  final String deviceToken;
  final String userId;
  const MainTabState({
    this.currentIndex = 0,
    this.isActiveFAB = false,
    this.notiUnRead,
    this.deviceId = '',
    this.deviceToken = '',
    this.userId = '',
  });

  @override
  List<Object?> get props => [currentIndex, isActiveFAB, notiUnRead, deviceId, deviceToken, userId];

  MainTabState copyWith({
    int? currentIndex,
    bool? isActiveFAB,
    String? notiUnRead,
    String? deviceId,
    String? deviceToken,
    String? userId,
  }) {
    return MainTabState(
      currentIndex: currentIndex ?? this.currentIndex,
      isActiveFAB: isActiveFAB ?? this.isActiveFAB,
      notiUnRead: notiUnRead ?? this.notiUnRead,
      deviceId: deviceId ?? this.deviceId,
      deviceToken: deviceToken ?? this.deviceToken,
      userId: userId ?? this.userId,
    );
  }
}

final class MainTabInitial extends MainTabState {}
