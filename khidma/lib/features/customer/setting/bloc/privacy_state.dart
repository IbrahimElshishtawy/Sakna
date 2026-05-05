part of 'privacy_bloc.dart';

class PrivacyState extends Equatable {
  final bool isLocationSharingEnabled;
  final bool isDataUsageEnabled;
  final bool isMarketingSMSEnabled;

  const PrivacyState({
    this.isLocationSharingEnabled = false,
    this.isDataUsageEnabled = true,
    this.isMarketingSMSEnabled = false,
  });

  PrivacyState copyWith({
    bool? isLocationSharingEnabled,
    bool? isDataUsageEnabled,
    bool? isMarketingSMSEnabled,
  }) {
    return PrivacyState(
      isLocationSharingEnabled: isLocationSharingEnabled ?? this.isLocationSharingEnabled,
      isDataUsageEnabled: isDataUsageEnabled ?? this.isDataUsageEnabled,
      isMarketingSMSEnabled: isMarketingSMSEnabled ?? this.isMarketingSMSEnabled,
    );
  }

  @override
  List<Object> get props => [isLocationSharingEnabled, isDataUsageEnabled, isMarketingSMSEnabled];
}
