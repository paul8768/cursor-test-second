import 'package:flutter/material.dart';
import 'package:cursor_test_thread/data/models/post_model.dart';
import 'package:cursor_test_thread/data/repositories/post_repository.dart';

class SearchProvider extends ChangeNotifier {
  final PostRepository _repository;
  final List<Post> _searchResults = [];
  bool _isLoading = false;
  String _query = '';

  SearchProvider(this._repository);

  List<Post> get searchResults => _searchResults;
  bool get isLoading => _isLoading;
  String get query => _query;

  Future<void> search(String query) async {
    if (query == _query) return;
    _query = query;
    
    if (query.isEmpty) {
      _searchResults.clear();
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      // 실제로는 검색 API를 호출해야 하지만, 
      // 여기서는 모든 포스트를 가져와서 필터링하는 방식으로 구현
      final posts = await _repository.getPosts(limit: 50);
      _searchResults.clear();
      _searchResults.addAll(
        posts.where((post) =>
          post.content.toLowerCase().contains(query.toLowerCase()) ||
          post.userName.toLowerCase().contains(query.toLowerCase())
        ),
      );
    } catch (e) {
      debugPrint('Error searching posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
} 