import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cursor_test_thread/data/repositories/post_repository.dart';
import 'package:cursor_test_thread/features/post/providers/post_create_provider.dart';
import 'package:cursor_test_thread/features/home/providers/post_provider.dart';
import 'package:go_router/go_router.dart';
import 'dart:io';

class PostScreen extends StatelessWidget {
  const PostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = context.read<PostProvider>().repository;
    
    return ChangeNotifierProvider(
      create: (context) => PostCreateProvider(repository, context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('New Post'),
          actions: [
            Consumer<PostCreateProvider>(
              builder: (context, provider, child) {
                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: FilledButton(
                    onPressed: provider.canPost && !provider.isLoading
                        ? () async {
                            if (await provider.createPost()) {
                              if (context.mounted) {
                                await context.read<PostProvider>().loadPosts(refresh: true);
                                context.go('/');
                              }
                            }
                          }
                        : null,
                    child: provider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                        : const Text('Post'),
                  ),
                );
              },
            ),
          ],
        ),
        body: const _PostForm(),
      ),
    );
  }
}

class _PostForm extends StatelessWidget {
  const _PostForm();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 사용자 닉네임
          const Text(
            'inhoit',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          // 게시글 작성 영역
          Consumer<PostCreateProvider>(
            builder: (context, provider, child) {
              return TextField(
                controller: provider.contentController,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  hintText: "What's happening?",
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.5,
                ),
                onChanged: (_) => provider.updateContent(),
              );
            },
          ),
          const SizedBox(height: 16),
          // 이미지 관련 버튼들을 가로로 배치
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Consumer<PostCreateProvider>(
                builder: (context, provider, child) {
                  return IconButton.filled(
                    icon: const Icon(Icons.photo_library),
                    onPressed: () => provider.pickImage(ImageSource.gallery),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.white,
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
              Consumer<PostCreateProvider>(
                builder: (context, provider, child) {
                  return IconButton.filled(
                    icon: const Icon(Icons.camera_alt),
                    onPressed: () => provider.pickImage(ImageSource.camera),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey[900],
                      foregroundColor: Colors.white,
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 선택된 이미지 표시
          Consumer<PostCreateProvider>(
            builder: (context, provider, child) {
              if (provider.selectedImages.isEmpty) {
                return const SizedBox.shrink();
              }
              
              return Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: provider.selectedImages.length,
                  itemBuilder: (context, index) {
                    return _buildImagePreview(
                      context,
                      provider.selectedImages[index],
                      index,
                      provider,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview(
    BuildContext context,
    String imagePath,
    int index,
    PostCreateProvider provider,
  ) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              File(imagePath),
              height: 100,
              width: 100,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                debugPrint('Error loading image: $error');
                debugPrint('Image path: $imagePath');
                return Container(
                  height: 100,
                  width: 100,
                  color: Colors.grey[900],
                  child: const Icon(Icons.error, color: Colors.white),
                );
              },
            ),
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
              padding: const EdgeInsets.all(4),
            ),
            onPressed: () => provider.removeImage(index),
          ),
        ),
      ],
    );
  }
} 