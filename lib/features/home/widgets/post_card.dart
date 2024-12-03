import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cursor_test_thread/data/models/post_model.dart';
import 'package:provider/provider.dart';
import 'package:cursor_test_thread/features/home/providers/post_provider.dart';
import 'dart:io';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 12),
            _buildContent(),
            if (post.images != null && post.images!.isNotEmpty) ...[
              const SizedBox(height: 12),
              _buildImage(),
            ],
            const SizedBox(height: 12),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: CachedNetworkImageProvider(post.userAvatar),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.userName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _getTimeAgo(post.createdAt),
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContent() {
    return Text(post.content);
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Builder(
        builder: (context) {
          final imageUrl = post.images!.first;
          // URL이 http로 시작하면 네트워크 이미지로 처리
          if (imageUrl.startsWith('http')) {
            return CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(),
              ),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            );
          } else {
            // 로컬 파일 경로인 경우
            return Image.file(
              File(imageUrl),
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
            );
          }
        },
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(
            post.isLiked ? Icons.favorite : Icons.favorite_border,
            color: post.isLiked ? Colors.red : null,
          ),
          onPressed: () {
            context.read<PostProvider>().toggleLike(post.id);
          },
        ),
        Text('${post.likesCount}'),
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.chat_bubble_outline),
          onPressed: () {
            // TODO: Implement reply functionality
          },
        ),
        Text('${post.repliesCount}'),
      ],
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    
    if (difference.inDays > 0) {
      return '${difference.inDays}d';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m';
    } else {
      return 'now';
    }
  }
} 