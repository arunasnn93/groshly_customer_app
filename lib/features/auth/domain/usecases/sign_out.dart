import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing out
@injectable
class SignOut {
  const SignOut(this._authRepository);

  final AuthRepository _authRepository;

  /// Execute sign out
  Future<Either<Failure, void>> call() async {
    return await _authRepository.signOut();
  }
}