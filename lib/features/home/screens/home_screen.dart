import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cursor_test_thread/features/home/providers/post_provider.dart';
import 'package:cursor_test_thread/features/home/widgets/post_card.dart';
import 'package:cursor_test_thread/features/home/widgets/post_card_shimmer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 화면이 처음 로드될 때만 게시글을 불러옵니다
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PostProvider>().loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<PostProvider>(
        builder: (context, provider, child) {
          if (provider.posts.isEmpty && provider.isLoading) {
            return ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) => const PostCardShimmer(),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await provider.loadPosts(refresh: true);
            },
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (!provider.isLoading &&
                    scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 200) {
                  provider.loadPosts();
                }
                return true;
              },
              child: ListView.builder(
                itemCount: provider.posts.length + 1,
                itemBuilder: (context, index) {
                  if (index == provider.posts.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  final post = provider.posts[index];
                  return PostCard(post: post);
                },
              ),
            ),
          );
        },
      ),
    );
  }
} 