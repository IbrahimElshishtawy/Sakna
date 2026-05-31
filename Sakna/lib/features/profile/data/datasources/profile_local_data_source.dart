import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<void> saveUserProfile(UserProfileModel model);
  Future<void> clear();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const _profileKey = 'cached_user_profile';

  ProfileLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<UserProfileModel> getUserProfile() async {
    final jsonString = sharedPreferences.getString(_profileKey);
    if (jsonString != null) {
      try {
        final decoded = json.decode(jsonString) as Map<String, dynamic>;
        return UserProfileModel.fromJson(decoded);
      } catch (_) {
        // Fallback to default mock if JSON is corrupted
        return _getDefaultProfile();
      }
    } else {
      // Create and save default mock profile on first launch
      final defaultProfile = _getDefaultProfile();
      await saveUserProfile(defaultProfile);
      return defaultProfile;
    }
  }

  @override
  Future<void> saveUserProfile(UserProfileModel model) async {
    final jsonString = json.encode(model.toJson());
    await sharedPreferences.setString(_profileKey, jsonString);
  }

  @override
  Future<void> clear() async {
    await sharedPreferences.remove(_profileKey);
  }

  UserProfileModel _getDefaultProfile() {
    return const UserProfileModel(
      id: 'user_123',
      name: 'أحمد محمد',
      avatarUrl: '', // Will default to a beautiful local UI placeholder
      userType: 'عميل',
      memberTier: 'بريميوم',
      walletBalance: 250.00,
    );
  }
}
