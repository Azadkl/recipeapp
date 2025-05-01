import '../datasources/bookmark_remote_datasource.dart';
import '../models/bookmark_model.dart';

class BookmarkRepository {
  final BookmarkRemoteDataSource _remoteDataSource = BookmarkRemoteDataSource();

  Future<List<BookmarkModel>> getBookmarks(String userId, String token) {
    return _remoteDataSource.getBookmarks(userId, token);
  }

  Future<BookmarkModel> addBookmark(String userId, String recipeId, String token) {
    return _remoteDataSource.addBookmark(userId, recipeId, token);
  }

  Future<void> deleteBookmark(String bookmarkId, String token) {
    return _remoteDataSource.deleteBookmark(bookmarkId, token);
  }
}
