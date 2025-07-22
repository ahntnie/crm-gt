part of '../core.dart';

@immutable
class TransportationObject {
  final String accessToken;
  final String? refreshToken;

  const TransportationObject({
    required this.accessToken,
    this.refreshToken,
  });
}
