

import 'package:recipeapp/datasources/islike_remote_datasource.dart';
import 'package:recipeapp/models/islike_toggle_model.dart';

class LikeRepository {
  final LikeRemoteDataSource _remoteDataSource = LikeRemoteDataSource();

  // Beğenme işlemi
  Future<IsLikeResponse> toggleLike(String recipeId, String token) async {
    return await _remoteDataSource.toggleLike(recipeId, token);
  }
}
