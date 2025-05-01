import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';

class AuthRepository {
  final AuthRemoteDataSource _remoteDataSource = AuthRemoteDataSource();

  Future<UserModel> login(String username, String password) {
    return _remoteDataSource.login(username, password);
  }
  
  Future<UserModel> signup(String username, String email, String password) {
    return _remoteDataSource.signup(username, email, password);
  }
}
