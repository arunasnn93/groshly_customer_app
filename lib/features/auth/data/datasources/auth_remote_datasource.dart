import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/user_model.dart';

/// Abstract interface for remote authentication data source
abstract class AuthRemoteDataSource {
  /// Get current user from Firebase
  Future<UserModel?> getCurrentUser();

  /// Sign in with Google
  Future<UserModel> signInWithGoogle();

  /// Sign in with email and password
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Sign up with email and password
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  });

  /// Sign out
  Future<void> signOut();

  /// Update user profile
  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  });

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email);

  /// Stream of authentication state changes
  Stream<UserModel?> get authStateChanges;
}

/// Implementation of remote authentication data source using Firebase
@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  AuthRemoteDataSourceImpl() {
    if (!AppConstants.useMockData) {
      _googleSignIn = GoogleSignIn();
    }
  }

  firebase_auth.FirebaseAuth? _firebaseAuth;
  GoogleSignIn? _googleSignIn;
  
  firebase_auth.FirebaseAuth get firebaseAuth {
    if (AppConstants.useMockData) {
      throw AuthException(
        message: 'Firebase not available in mock mode',
        code: 'MOCK_MODE',
      );
    }
    return _firebaseAuth ??= firebase_auth.FirebaseAuth.instance;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      if (AppConstants.useMockData) {
        return null; // No user in mock mode initially
      }
      
      final firebaseUser = firebaseAuth.currentUser;
      if (firebaseUser != null) {
        return UserModel.fromFirebaseUser(firebaseUser);
      }
      return null;
    } catch (e) {
      throw AuthException(
        message: 'Failed to get current user: $e',
        code: 'GET_CURRENT_USER_ERROR',
      );
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // Mock implementation for now
      if (AppConstants.useMockData) {
        // Simulate network delay
        await Future.delayed(const Duration(seconds: 1));
        
        return const UserModel(
          id: 'mock_user_id',
          email: 'user@groshly.com',
          name: 'Mock User',
          phoneNumber: '+91 98765 43210',
          profileImageUrl: 'https://via.placeholder.com/150',
          isEmailVerified: true,
          isPhoneVerified: true,
        );
      }

      // Real Google Sign-In implementation
      if (_googleSignIn == null) {
        throw AuthException(
          message: 'Google Sign-In not available',
          code: 'GOOGLE_SIGNIN_NOT_AVAILABLE',
        );
      }
      
      final GoogleSignInAccount? googleUser = await _googleSignIn!.signIn();
      if (googleUser == null) {
        throw AuthException(
          message: 'Google sign in was cancelled',
          code: 'GOOGLE_SIGNIN_CANCELLED',
        );
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final firebase_auth.UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user == null) {
        throw AuthException(
          message: 'Failed to sign in with Google',
          code: 'GOOGLE_SIGNIN_FAILED',
        );
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException(
        message: 'Failed to sign in with Google: $e',
        code: 'GOOGLE_SIGNIN_ERROR',
      );
    }
  }

  @override
  Future<UserModel> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // Mock implementation for now
      if (AppConstants.useMockData) {
        await Future.delayed(const Duration(seconds: 1));
        
        return UserModel(
          id: 'mock_email_user_id',
          email: email,
          name: 'Email User',
          isEmailVerified: true,
        );
      }

      final firebase_auth.UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException(
          message: 'Failed to sign in with email and password',
          code: 'EMAIL_SIGNIN_FAILED',
        );
      }

      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException(
        message: 'Failed to sign in with email and password: $e',
        code: 'EMAIL_SIGNIN_ERROR',
      );
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Mock implementation for now
      if (AppConstants.useMockData) {
        await Future.delayed(const Duration(seconds: 1));
        
        return UserModel(
          id: 'mock_signup_user_id',
          email: email,
          name: name,
          isEmailVerified: false,
        );
      }

      final firebase_auth.UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user == null) {
        throw AuthException(
          message: 'Failed to create account',
          code: 'EMAIL_SIGNUP_FAILED',
        );
      }

      // Update display name
      await userCredential.user!.updateDisplayName(name);

      return UserModel.fromFirebaseUser(userCredential.user!);
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException(
        message: 'Failed to sign up with email and password: $e',
        code: 'EMAIL_SIGNUP_ERROR',
      );
    }
  }

  @override
  Future<void> signOut() async {
    try {
      if (AppConstants.useMockData) {
        // Mock sign out - just return
        return;
      }
      
      final futures = <Future>[];
      if (_firebaseAuth != null) {
        futures.add(firebaseAuth.signOut());
      }
      if (_googleSignIn != null) {
        futures.add(_googleSignIn!.signOut());
      }
      
      if (futures.isNotEmpty) {
        await Future.wait(futures);
      }
    } catch (e) {
      throw AuthException(
        message: 'Failed to sign out: $e',
        code: 'SIGNOUT_ERROR',
      );
    }
  }

  @override
  Future<UserModel> updateProfile({
    required String userId,
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    try {
      if (AppConstants.useMockData) {
        // Mock update - return updated user
        return UserModel(
          id: userId,
          email: 'user@groshly.com',
          name: name ?? 'Mock User',
          phoneNumber: phoneNumber,
          profileImageUrl: profileImageUrl,
          isEmailVerified: true,
          isPhoneVerified: true,
        );
      }
      
      final user = firebaseAuth.currentUser;
      if (user == null) {
        throw AuthException(
          message: 'No authenticated user found',
          code: 'NO_USER_FOUND',
        );
      }

      if (name != null) {
        await user.updateDisplayName(name);
      }

      if (profileImageUrl != null) {
        await user.updatePhotoURL(profileImageUrl);
      }

      // Reload user to get updated data
      await user.reload();
      final updatedUser = firebaseAuth.currentUser!;

      return UserModel.fromFirebaseUser(updatedUser);
    } catch (e) {
      if (e is AuthException) {
        rethrow;
      }
      throw AuthException(
        message: 'Failed to update profile: $e',
        code: 'UPDATE_PROFILE_ERROR',
      );
    }
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      if (AppConstants.useMockData) {
        // Mock password reset - just return success
        return;
      }
      
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw AuthException(
        message: 'Failed to send password reset email: $e',
        code: 'PASSWORD_RESET_ERROR',
      );
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    if (AppConstants.useMockData) {
      // Return empty stream for mock mode
      return Stream.value(null);
    }
    
    return firebaseAuth.authStateChanges().map((firebaseUser) {
      if (firebaseUser != null) {
        return UserModel.fromFirebaseUser(firebaseUser);
      }
      return null;
    });
  }
}