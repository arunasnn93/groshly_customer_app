import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for Google Sign-In
@injectable
class SignInWithGoogle {
  const SignInWithGoogle(this._authRepository);

  final AuthRepository _authRepository;

  /// Execute Google Sign-In
  Future<Either<Failure, User>> call() async {
    return await _authRepository.signInWithGoogle();
  }
}