import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../datasources/auth_remote_datasource.dart';


/// Implementation of authentication repository
@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(
    this._remoteDataSource,
    this._localDataSource,
    this._networkInfo,
  );

  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;
  final NetworkInfo _networkInfo;

  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      // First try to get user from local cache
      final cachedUser = await _localDataSource.getCachedUser();
      if (cachedUser != null) {
        return Right(cachedUser.toEntity());
      }

      // If not in cache and connected, get from remote
      if (await _networkInfo.isConnected) {
        final remoteUser = await _remoteDataSource.getCurrentUser();
        if (remoteUser != null) {
          // Cache the user data
          await _localDataSource.cacheUser(remoteUser);
          return Right(remoteUser.toEntity());
        }
      }

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          code: 'NO_INTERNET',
        ));
      }

      final userModel = await _remoteDataSource.signInWithGoogle();
      
      // Cache user data locally
      await _localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      // Still return success even if caching fails
      print('Failed to cache user after sign in: ${e.message}');
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          code: 'NO_INTERNET',
        ));
      }

      final userModel = await _remoteDataSource.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Cache user data locally
      await _localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      print('Failed to cache user after sign in: ${e.message}');
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          code: 'NO_INTERNET',
        ));
      }

      final userModel = await _remoteDataSource.signUpWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
      );

      // Cache user data locally
      await _localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      print('Failed to cache user after sign up: ${e.message}');
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      // Clear local cache first
      await _localDataSource.clearCachedUser();
      await _localDataSource.clearCachedToken();

      // Then sign out from remote if connected
      if (await _networkInfo.isConnected) {
        await _remoteDataSource.signOut();
      }

      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          code: 'NO_INTERNET',
        ));
      }

      final userModel = await _remoteDataSource.updateProfile(
        userId: userId,
        name: name,
        phoneNumber: phoneNumber,
        profileImageUrl: profileImageUrl,
      );

      // Update cache
      await _localDataSource.cacheUser(userModel);

      return Right(userModel.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } on CacheException catch (e) {
      print('Failed to cache updated user: ${e.message}');
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          code: 'NO_INTERNET',
        ));
      }

      await _remoteDataSource.sendPasswordResetEmail(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message, code: e.code));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> verifyPhoneNumber({
    required String phoneNumber,
    required String otp,
  }) async {
    // Mock implementation for now
    try {
      await Future.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Phone verification failed: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> sendOTPToPhone(String phoneNumber) async {
    // Mock implementation for now
    try {
      await Future.delayed(const Duration(seconds: 1));
      return const Right(null);
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Failed to send OTP: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> checkUserExists(String email) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          code: 'NO_INTERNET',
        ));
      }

      // Mock implementation for now
      await Future.delayed(const Duration(seconds: 1));
      return const Right(false); // User doesn't exist
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Failed to check user existence: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String userId) async {
    try {
      if (!await _networkInfo.isConnected) {
        return const Left(NetworkFailure(
          message: 'No internet connection',
          code: 'NO_INTERNET',
        ));
      }

      // Clear local data first
      await _localDataSource.clearCachedUser();
      await _localDataSource.clearCachedToken();

      // Mock implementation for account deletion
      await Future.delayed(const Duration(seconds: 1));

      return const Right(null);
    } on CacheException catch (e) {
      return Left(CacheFailure(message: e.message, code: e.code));
    } catch (e) {
      return Left(UnexpectedFailure(message: 'Failed to delete account: $e'));
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return _remoteDataSource.authStateChanges.map((userModel) {
      if (userModel != null) {
        // Cache user when state changes
        _localDataSource.cacheUser(userModel);
        return userModel.toEntity();
      } else {
        // Clear cache when user signs out
        _localDataSource.clearCachedUser();
        return null;
      }
    });
  }
}