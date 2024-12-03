import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cursor_test_thread/data/repositories/post_repository.dart';
import 'package:cursor_test_thread/features/home/providers/post_provider.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';

class PostCreateProvider extends ChangeNotifier {
  final PostRepository _repository;
  final List<String> _selectedImages = [];
  bool _isLoading = false;
  final TextEditingController contentController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final BuildContext context;

  PostCreateProvider(this._repository, this.context);

  List<String> get selectedImages => _selectedImages;
  bool get isLoading => _isLoading;
  bool get canPost => contentController.text.isNotEmpty || _selectedImages.isNotEmpty;

  Future<void> pickImage(ImageSource source) async {
    try {
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (status.isDenied) return;
      } else {
        final status = await Permission.photos.request();
        if (status.isDenied) return;
      }

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
        maxWidth: 1080,
        maxHeight: 1080,
      );
      
      if (pickedFile != null) {
        debugPrint('Picked image path: ${pickedFile.path}');
        _selectedImages.add(pickedFile.path);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  void removeImage(int index) {
    if (index >= 0 && index < _selectedImages.length) {
      _selectedImages.removeAt(index);
      notifyListeners();
    }
  }

  Future<bool> createPost() async {
    if (!canPost) return false;

    _isLoading = true;
    notifyListeners();

    try {
      List<String>? uploadedImages;
      if (_selectedImages.isNotEmpty) {
        uploadedImages = List<String>.from(_selectedImages);
      }

      final newPost = await _repository.createPost(
        contentController.text.trim(),
        uploadedImages,
      );

      if (context.mounted) {
        context.read<PostProvider>().addPost(newPost);
      }

      contentController.clear();
      _selectedImages.clear();
      
      return true;
    } catch (e) {
      debugPrint('Error creating post: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateContent() {
    notifyListeners();
  }

  @override
  void dispose() {
    contentController.dispose();
    super.dispose();
  }
} 