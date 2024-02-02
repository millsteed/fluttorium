import 'package:app/core/client.dart';
import 'package:app/core/loading_page.dart';
import 'package:app/forums/threads_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class ForumsPage extends StatefulWidget {
  const ForumsPage({required this.client, super.key});

  static const route = 'Forums';

  final Client client;

  @override
  State<ForumsPage> createState() => _ForumsPageState();
}

class _ForumsPageState extends State<ForumsPage> {
  List<Category>? _categories;
  List<Forum>? _forums;

  @override
  void initState() {
    super.initState();
    _fetchState();
  }

  Future<void> _fetchState() async {
    final categories = await widget.client.getCategories();
    final forums = await widget.client.getForums();
    setState(() {
      _categories = categories;
      _forums = forums;
    });
  }

  @override
  Widget build(BuildContext context) {
    final categories = _categories;
    final forums = _forums;
    if (categories == null || forums == null) {
      return const LoadingPage();
    }
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildCategories(context, categories, forums),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Forums'),
    );
  }

  Widget _buildCategories(
    BuildContext context,
    List<Category> categories,
    List<Forum> forums,
  ) {
    return ListView(
      children: [
        for (final category in categories) ...[
          _buildCategory(
            context,
            category,
            forums.where((forum) => forum.categoryId == category.id).toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildCategory(
    BuildContext context,
    Category category,
    List<Forum> forums,
  ) {
    return Column(
      children: [
        _buildCategoryHeader(context, category),
        for (final forum in forums) ...[
          _buildForum(context, forum),
        ],
      ],
    );
  }

  Widget _buildCategoryHeader(BuildContext context, Category category) {
    return ListTile(
      selected: true,
      title: Text(category.title),
    );
  }

  Widget _buildForum(BuildContext context, Forum forum) {
    return ListTile(
      title: Text(forum.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.goNamed(
        ThreadsPage.route,
        pathParameters: {'forumId': forum.id},
      ),
    );
  }
}
