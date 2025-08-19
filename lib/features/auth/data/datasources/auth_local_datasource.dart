import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Abstract interface for local authentication data source
abstract class AuthLocalDataSource {
  /// Get cached user
  Future<UserModel?> getCachedUser();

  /// Cache user data
  Future<void> cacheUser(UserModel user);

  /// Clear cached user data
  Future<void> clearCachedUser();

  /// Get cached auth token
  Future<String?> getCachedToken();

  /// Cache auth token
  Future<void> cacheToken(String token);

  /// Clear cached token
  Future<void> clearCachedToken();

  /// Check if user data exists in cache
  Future<bool> hasUserData();
}

/// Implementation of local authentication data source
@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  const AuthLocalDataSourceImpl(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  @override
  Future<UserModel?> getCachedUser() async {
    try {
      final userJson = _sharedPreferences.getString(AppConstants.userKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromJson(userMap);
      }
      return null;
    } catch (e) {
      throw CacheException(
        message: 'Failed to get cached user: $e',
        code: 'CACHE_GET_USER_ERROR',
      );
    }
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    try {
      final userJson = json.encode(user.toJson());
      final success = await _sharedPreferences.setString(
        AppConstants.userKey,
        userJson,
      );
      if (!success) {
        throw CacheException(
          message: 'Failed to cache user data',
          code: 'CACHE_SAVE_USER_ERROR',
        );
      }
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache user: $e',
        code: 'CACHE_SAVE_USER_ERROR',
      );
    }
  }

  @override
  Future<void> clearCachedUser() async {
    try {
      final success = await _sharedPreferences.remove(AppConstants.userKey);
      if (!success) {
        throw CacheException(
          message: 'Failed to clear cached user data',
          code: 'CACHE_CLEAR_USER_ERROR',
        );
      }
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear cached user: $e',
        code: 'CACHE_CLEAR_USER_ERROR',
      );
    }
  }

  @override
  Future<String?> getCachedToken() async {
    try {
      return _sharedPreferences.getString(AppConstants.tokenKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get cached token: $e',
        code: 'CACHE_GET_TOKEN_ERROR',
      );
    }
  }

  @override
  Future<void> cacheToken(String token) async {
    try {
      final success = await _sharedPreferences.setString(
        AppConstants.tokenKey,
        token,
      );
      if (!success) {
        throw CacheException(
          message: 'Failed to cache token',
          code: 'CACHE_SAVE_TOKEN_ERROR',
        );
      }
    } catch (e) {
      throw CacheException(
        message: 'Failed to cache token: $e',
        code: 'CACHE_SAVE_TOKEN_ERROR',
      );
    }
  }

  @override
  Future<void> clearCachedToken() async {
    try {
      final success = await _sharedPreferences.remove(AppConstants.tokenKey);
      if (!success) {
        throw CacheException(
          message: 'Failed to clear cached token',
          code: 'CACHE_CLEAR_TOKEN_ERROR',
        );
      }
    } catch (e) {
      throw CacheException(
        message: 'Failed to clear cached token: $e',
        code: 'CACHE_CLEAR_TOKEN_ERROR',
      );
    }
  }

  @override
  Future<bool> hasUserData() async {
    try {
      return _sharedPreferences.containsKey(AppConstants.userKey);
    } catch (e) {
      throw CacheException(
        message: 'Failed to check user data existence: $e',
        code: 'CACHE_CHECK_USER_ERROR',
      );
    }
  }
}