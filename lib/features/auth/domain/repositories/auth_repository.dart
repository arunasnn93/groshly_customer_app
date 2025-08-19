import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';

/// Abstract authentication repository interface
abstract class AuthRepository {
  /// Get current authenticated user
  Future<Either<Failure, User?>> getCurrentUser();

  /// Sign in with Google
  Future<Either<Failure, User>> signInWithGoogle();

  /// Sign in with email and password
  Future<Either<Failure, User>> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<Either<Failure, User>> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  });

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  /// Verify phone number with OTP
  Future<Either<Failure, void>> verifyPhoneNumber({
    required String phoneNumber,
    required String otp,
  });

  /// Send OTP to phone number
  Future<Either<Failure, void>> sendOTPToPhone(String phoneNumber);

  /// Check if user exists with email
  Future<Either<Failure, bool>> checkUserExists(String email);

  /// Delete user account
  Future<Either<Failure, void>> deleteAccount(String userId);

  /// Stream of authentication state changes
  Stream<User?> get authStateChanges;
}