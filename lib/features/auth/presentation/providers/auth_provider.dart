import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/di/injection.dart';
import '../../domain/entities/auth_state.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/get_current_user.dart';
import '../../domain/usecases/sign_in_with_google.dart';
import '../../domain/usecases/sign_out.dart';

/// Simple auth status provider that doesn't cause rebuilds
final authStatusProvider = StateProvider<AuthStatus>((ref) {
  return AuthStatus.initial;
});

/// Simple current user provider
final currentUserProvider = StateProvider<User?>((ref) {
  return null;
});

/// Simple error message provider
final authErrorProvider = StateProvider<String?>((ref) {
  return null;
});

/// Authentication provider that doesn't cause circular dependencies
final authProvider = Provider<AuthService>((ref) {
  return AuthService(
    getCurrentUser: getIt<GetCurrentUser>(),
    signInWithGoogle: getIt<SignInWithGoogle>(),
    signOut: getIt<SignOut>(),
    authRepository: getIt<AuthRepository>(),
    ref: ref,
  );
});

/// Simple authentication service without StateNotifier
class AuthService {
  AuthService({
    required GetCurrentUser getCurrentUser,
    required SignInWithGoogle signInWithGoogle,
    required SignOut signOut,
    required AuthRepository authRepository,
    required this.ref,
  })  : _getCurrentUser = getCurrentUser,
        _signInWithGoogle = signInWithGoogle,
        _signOut = signOut,
        _authRepository = authRepository;

  final GetCurrentUser _getCurrentUser;
  final SignInWithGoogle _signInWithGoogle;
  final SignOut _signOut;
  final AuthRepository _authRepository;
  final ProviderRef ref;

  /// Check if user is currently authenticated
  Future<void> checkCurrentUser() async {
    // Don't set loading state to avoid rebuilds during initialization
    final result = await _getCurrentUser();
    result.fold(
      (failure) {
        ref.read(authStatusProvider.notifier).state = AuthStatus.unauthenticated;
        ref.read(currentUserProvider.notifier).state = null;
        ref.read(authErrorProvider.notifier).state = failure.message;
      },
      (user) {
        if (user != null) {
          ref.read(authStatusProvider.notifier).state = AuthStatus.authenticated;
          ref.read(currentUserProvider.notifier).state = user;
          ref.read(authErrorProvider.notifier).state = null;
        } else {
          ref.read(authStatusProvider.notifier).state = AuthStatus.unauthenticated;
          ref.read(currentUserProvider.notifier).state = null;
          ref.read(authErrorProvider.notifier).state = null;
        }
      },
    );
  }

  /// Sign in with Google
  Future<void> signInWithGoogleAccount() async {
    ref.read(authStatusProvider.notifier).state = AuthStatus.loading;
    ref.read(authErrorProvider.notifier).state = null;

    final result = await _signInWithGoogle();
    result.fold(
      (failure) {
        ref.read(authStatusProvider.notifier).state = AuthStatus.error;
        ref.read(authErrorProvider.notifier).state = failure.message;
      },
      (user) {
        ref.read(authStatusProvider.notifier).state = AuthStatus.authenticated;
        ref.read(currentUserProvider.notifier).state = user;
        ref.read(authErrorProvider.notifier).state = null;
      },
    );
  }

  /// Sign in with email and password
  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    ref.read(authStatusProvider.notifier).state = AuthStatus.loading;
    ref.read(authErrorProvider.notifier).state = null;

    final result = await _authRepository.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    result.fold(
      (failure) {
        ref.read(authStatusProvider.notifier).state = AuthStatus.error;
        ref.read(authErrorProvider.notifier).state = failure.message;
      },
      (user) {
        ref.read(authStatusProvider.notifier).state = AuthStatus.authenticated;
        ref.read(currentUserProvider.notifier).state = user;
        ref.read(authErrorProvider.notifier).state = null;
      },
    );
  }

  /// Sign up with email and password
  Future<void> signUpWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
  }) async {
    ref.read(authStatusProvider.notifier).state = AuthStatus.loading;
    ref.read(authErrorProvider.notifier).state = null;

    final result = await _authRepository.signUpWithEmailAndPassword(
      email: email,
      password: password,
      name: name,
    );

    result.fold(
      (failure) {
        ref.read(authStatusProvider.notifier).state = AuthStatus.error;
        ref.read(authErrorProvider.notifier).state = failure.message;
      },
      (user) {
        ref.read(authStatusProvider.notifier).state = AuthStatus.authenticated;
        ref.read(currentUserProvider.notifier).state = user;
        ref.read(authErrorProvider.notifier).state = null;
      },
    );
  }

  /// Sign out
  Future<void> signOutUser() async {
    ref.read(authErrorProvider.notifier).state = null;

    final result = await _signOut();
    result.fold(
      (failure) {
        ref.read(authErrorProvider.notifier).state = failure.message;
      },
      (_) {
        ref.read(authStatusProvider.notifier).state = AuthStatus.unauthenticated;
        ref.read(currentUserProvider.notifier).state = null;
        ref.read(authErrorProvider.notifier).state = null;
      },
    );
  }

  /// Update user profile
  Future<void> updateUserProfile({
    String? name,
    String? phoneNumber,
    String? profileImageUrl,
  }) async {
    final currentUser = ref.read(currentUserProvider);
    if (currentUser == null) return;

    ref.read(authErrorProvider.notifier).state = null;

    final result = await _authRepository.updateProfile(
      userId: currentUser.id,
      name: name,
      phoneNumber: phoneNumber,
      profileImageUrl: profileImageUrl,
    );

    result.fold(
      (failure) {
        ref.read(authErrorProvider.notifier).state = failure.message;
      },
      (user) {
        ref.read(currentUserProvider.notifier).state = user;
        ref.read(authErrorProvider.notifier).state = null;
      },
    );
  }

  /// Send password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    ref.read(authErrorProvider.notifier).state = null;

    final result = await _authRepository.sendPasswordResetEmail(email);
    result.fold(
      (failure) {
        ref.read(authErrorProvider.notifier).state = failure.message;
      },
      (_) {
        ref.read(authErrorProvider.notifier).state = null;
      },
    );
  }

  /// Clear error state
  void clearError() {
    ref.read(authErrorProvider.notifier).state = null;
  }
}

/// Provider for checking if user is authenticated
final isAuthenticatedProvider = Provider<bool>((ref) {
  final status = ref.watch(authStatusProvider);
  return status == AuthStatus.authenticated;
});

/// Provider for checking if authentication is loading
final authLoadingProvider = Provider<bool>((ref) {
  final status = ref.watch(authStatusProvider);
  return status == AuthStatus.loading;
});