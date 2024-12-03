import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:cursor_test_thread/app/theme/app_theme.dart';
import 'package:cursor_test_thread/features/home/screens/home_screen.dart';
import 'package:cursor_test_thread/features/search/screens/search_screen.dart';
import 'package:cursor_test_thread/features/post/screens/post_screen.dart';
import 'package:cursor_test_thread/features/activity/screens/activity_screen.dart';
import 'package:cursor_test_thread/features/profile/screens/profile_screen.dart';
import 'package:cursor_test_thread/shared/widgets/app_scaffold.dart';
import 'package:cursor_test_thread/features/home/providers/post_provider.dart';
import 'package:cursor_test_thread/data/repositories/post_repository.dart';

class ThreadApp extends StatelessWidget {
  ThreadApp({super.key});

  final _repository = MockPostRepository();
  late final _router = GoRouter(
    initialLocation: '/',
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          int index = 0;
          switch (state.uri.path) {
            case '/':
              index = 0;
              break;
            case '/search':
              index = 1;
              break;
            case '/post':
              index = 2;
              break;
            case '/activity':
              index = 3;
              break;
            case '/profile':
              index = 4;
              break;
          }
          return AppScaffold(
            currentIndex: index,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/post',
            builder: (context, state) => const PostScreen(),
          ),
          GoRoute(
            path: '/activity',
            builder: (context, state) => const ActivityScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<PostProvider>(
          create: (context) => PostProvider(_repository)..loadPosts(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Thread App',
        theme: AppTheme.darkTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        routerConfig: _router,
      ),
    );
  }
} 