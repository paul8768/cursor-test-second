import 'package:flutter_test/flutter_test.dart';
import 'package:cursor_test_thread/data/repositories/post_repository.dart';
import 'package:cursor_test_thread/features/home/providers/post_provider.dart';

void main() {
  group('PostProvider', () {
    late PostProvider provider;
    late MockPostRepository repository;

    setUp(() {
      repository = MockPostRepository();
      provider = PostProvider(repository);
    });

    test('initial state is correct', () {
      expect(provider.posts, isEmpty);
      expect(provider.isLoading, isFalse);
      expect(provider.hasMore, isTrue);
    });

    test('loadPosts updates state correctly', () async {
      await provider.loadPosts();
      
      expect(provider.posts, isNotEmpty);
      expect(provider.isLoading, isFalse);
    });

    test('refresh clears existing posts', () async {
      await provider.loadPosts();
      final initialPosts = provider.posts.length;
      
      await provider.loadPosts(refresh: true);
      
      expect(provider.posts.length, equals(initialPosts));
    });
  });
} 