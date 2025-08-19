import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting current authenticated user
@injectable
class GetCurrentUser {
  const GetCurrentUser(this._authRepository);

  final AuthRepository _authRepository;

  /// Execute get current user
  Future<Either<Failure, User?>> call() async {
    return await _authRepository.getCurrentUser();
  }
}