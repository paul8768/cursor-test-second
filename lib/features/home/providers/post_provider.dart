import 'package:flutter/material.dart';
import 'package:cursor_test_thread/data/models/post_model.dart';
import 'package:cursor_test_thread/data/repositories/post_repository.dart';

class PostProvider extends ChangeNotifier {
  final PostRepository _repository;
  final List<Post> _posts = [];
  bool _isLoading = false;
  int _currentPage = 1;

  PostProvider(this._repository);

  PostRepository get repository => _repository;
  List<Post> get posts => _posts;
  bool get isLoading => _isLoading;
  bool get hasMore => true;

  Future<void> loadPosts({bool refresh = false}) async {
    if (_isLoading) return;

    if (refresh) {
      _posts.clear();
      _currentPage = 1;
      _isLoading = true;
      notifyListeners();

      try {
        final newPosts = await _repository.getPosts(page: 1, limit: 20);
        _posts.clear();
        _posts.addAll(newPosts);
      } catch (e) {
        debugPrint('Error loading posts: $e');
      } finally {
        _isLoading = false;
        notifyListeners();
      }
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final newPosts = await _repository.getPosts(
        page: _currentPage,
        limit: 3,
      );
      
      _posts.addAll(newPosts);
      _currentPage++;
    } catch (e) {
      debugPrint('Error loading posts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLike(String postId) async {
    final postIndex = _posts.indexWhere((post) => post.id == postId);
    if (postIndex == -1) return;

    final post = _posts[postIndex];
    final isLiked = post.isLiked;

    try {
      if (isLiked) {
        await _repository.unlikePost(postId);
      } else {
        await _repository.likePost(postId);
      }
      
      _posts[postIndex] = post.copyWith(
        isLiked: !isLiked,
        likesCount: isLiked ? post.likesCount - 1 : post.likesCount + 1,
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling like: $e');
    }
  }

  Future<void> addPost(Post post) async {
    debugPrint('Adding new post: ${post.content}');
    _posts.insert(0, post);
    notifyListeners();
  }
} 