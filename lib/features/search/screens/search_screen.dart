import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cursor_test_thread/data/repositories/post_repository.dart';
import 'package:cursor_test_thread/features/search/providers/search_provider.dart';
import 'package:cursor_test_thread/features/home/widgets/post_card.dart';
import 'package:cursor_test_thread/features/home/widgets/post_card_shimmer.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchProvider(MockPostRepository()),
      child: Scaffold(
        appBar: AppBar(
          title: const _SearchBar(),
        ),
        body: const _SearchResults(),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        prefixIcon: const Icon(Icons.search),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      onChanged: (value) {
        context.read<SearchProvider>().search(value);
      },
    );
  }
}

class _SearchResults extends StatelessWidget {
  const _SearchResults();

  @override
  Widget build(BuildContext context) {
    return Consumer<SearchProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return ListView.builder(
            itemCount: 3,
            itemBuilder: (context, index) => const PostCardShimmer(),
          );
        }

        if (provider.query.isEmpty) {
          return const Center(
            child: Text('Search for posts or users'),
          );
        }

        if (provider.searchResults.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.search_off,
                  size: 48,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  'No results found for "${provider.query}"',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: provider.searchResults.length,
          itemBuilder: (context, index) {
            final post = provider.searchResults[index];
            return PostCard(post: post);
          },
        );
      },
    );
  }
} 