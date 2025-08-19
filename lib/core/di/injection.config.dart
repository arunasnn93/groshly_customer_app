// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:get_it/get_it.dart' as _i174;
import 'package:groshly_customer_app/core/network/dio_client.dart' as _i72;
import 'package:groshly_customer_app/core/network/network_info.dart' as _i525;
import 'package:groshly_customer_app/features/auth/data/datasources/auth_local_datasource.dart'
    as _i219;
import 'package:groshly_customer_app/features/auth/data/datasources/auth_remote_datasource.dart'
    as _i114;
import 'package:groshly_customer_app/features/auth/data/repositories/auth_repository_impl.dart'
    as _i642;
import 'package:groshly_customer_app/features/auth/domain/repositories/auth_repository.dart'
    as _i550;
import 'package:groshly_customer_app/features/auth/domain/usecases/get_current_user.dart'
    as _i334;
import 'package:groshly_customer_app/features/auth/domain/usecases/sign_in_with_google.dart'
    as _i195;
import 'package:groshly_customer_app/features/auth/domain/usecases/sign_out.dart'
    as _i541;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i72.DioClient>(() => _i72.DioClient());
    gh.lazySingleton<_i114.AuthRemoteDataSource>(
        () => _i114.AuthRemoteDataSourceImpl());
    gh.lazySingleton<_i219.AuthLocalDataSource>(
        () => _i219.AuthLocalDataSourceImpl(gh<_i460.SharedPreferences>()));
    gh.lazySingleton<_i525.NetworkInfo>(
        () => _i525.NetworkInfoImpl(gh<_i895.Connectivity>()));
    gh.lazySingleton<_i550.AuthRepository>(() => _i642.AuthRepositoryImpl(
          gh<_i114.AuthRemoteDataSource>(),
          gh<_i219.AuthLocalDataSource>(),
          gh<_i525.NetworkInfo>(),
        ));
    gh.factory<_i541.SignOut>(() => _i541.SignOut(gh<_i550.AuthRepository>()));
    gh.factory<_i195.SignInWithGoogle>(
        () => _i195.SignInWithGoogle(gh<_i550.AuthRepository>()));
    gh.factory<_i334.GetCurrentUser>(
        () => _i334.GetCurrentUser(gh<_i550.AuthRepository>()));
    return this;
  }
}
