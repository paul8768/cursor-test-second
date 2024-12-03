import 'package:flutter/material.dart';
import 'package:cursor_test_thread/features/home/widgets/post_card.dart';
import 'package:cursor_test_thread/data/models/post_model.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('User Name'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue.shade200,
                      Colors.blue.shade50,
                    ],
                  ),
                ),
                child: const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1'),
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '@username',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Bio goes here. This is a sample bio text that describes the user.',
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Text('1,234 followers'),
                      SizedBox(width: 16),
                      Text('567 following'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // 임시 포스트 데이터
                final post = Post(
                  id: 'profile_post_$index',
                  userId: 'user_1',
                  userName: 'User Name',
                  userAvatar: 'https://i.pravatar.cc/150?img=1',
                  content: 'Sample post content $index',
                  createdAt: DateTime.now().subtract(Duration(days: index)),
                  likesCount: index * 10,
                  repliesCount: index * 2,
                );
                return PostCard(post: post);
              },
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }
} 