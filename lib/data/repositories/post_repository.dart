import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cursor_test_thread/data/models/post_model.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts({int page = 1, int limit = 10});
  Future<Post> createPost(String content, List<String>? images);
  Future<void> likePost(String postId);
  Future<void> unlikePost(String postId);
}

class MockPostRepository implements PostRepository {
  final List<Post> _mockPosts = [];
  final List<String> _mockAvatars = [
    'https://i.pravatar.cc/150?img=1',
    'https://i.pravatar.cc/150?img=2',
    'https://i.pravatar.cc/150?img=3',
  ];

  final List<String> _mockContents = [
    'Just had an amazing coffee! ☕️ #morningvibes',
    'Working on a new Flutter project. Loving the developer experience! 💙 #FlutterDev',
    'Beautiful sunset today! 🌅 Nature never fails to amaze me.',
    'Had a great workout session! 💪 #fitness #health',
    'Learning something new everyday! 📚 #neverstoplearning',
  ];

  final Random _random = Random();

  @override
  Future<List<Post>> getPosts({int page = 1, int limit = 3}) async {
    await Future.delayed(const Duration(milliseconds: 800));
    
    if (_mockPosts.isEmpty) {
      _generateInitialPosts();
    }
    
    final startIndex = (page - 1) * limit;
    final endIndex = startIndex + limit;
    
    if (startIndex >= _mockPosts.length) {
      return [];
    }
    
    return _mockPosts.sublist(
      startIndex,
      endIndex > _mockPosts.length ? _mockPosts.length : endIndex,
    );
  }

  void _generateInitialPosts() {
    final random = Random();
    for (int i = 0; i < 20; i++) {
      _mockPosts.add(
        Post(
          id: 'post_$i',
          userId: 'user_${random.nextInt(3)}',
          userName: 'User ${random.nextInt(100)}',
          userAvatar: 'https://i.pravatar.cc/150?img=${random.nextInt(70)}',
          content: _mockContents[random.nextInt(_mockContents.length)],
          createdAt: DateTime.now().subtract(Duration(hours: i)),
          likesCount: random.nextInt(1000),
          repliesCount: random.nextInt(50),
          images: random.nextBool()
              ? ['https://picsum.photos/500/300?random=$i']
              : null,
        ),
      );
    }
  }

  @override
  Future<Post> createPost(String content, List<String>? images) async {
    await Future.delayed(const Duration(milliseconds: 500));
    
    final newPost = Post(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      userId: 'user_me',
      userName: 'inhoit',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      content: content,
      images: images,
      createdAt: DateTime.now(),
      likesCount: 0,
      repliesCount: 0,
      isLiked: false,
    );

    debugPrint('Created new post: ${newPost.content}');
    _mockPosts.insert(0, newPost);
    return newPost;
  }

  @override
  Future<void> likePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final postIndex = _mockPosts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final updatedPost = _mockPosts[postIndex].copyWith(
        likesCount: _mockPosts[postIndex].likesCount + 1,
        isLiked: true,
      );
      _mockPosts[postIndex] = updatedPost;
    }
  }

  @override
  Future<void> unlikePost(String postId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    final postIndex = _mockPosts.indexWhere((post) => post.id == postId);
    if (postIndex != -1) {
      final updatedPost = _mockPosts[postIndex].copyWith(
        likesCount: _mockPosts[postIndex].likesCount - 1,
        isLiked: false,
      );
      _mockPosts[postIndex] = updatedPost;
    }
  }
} 