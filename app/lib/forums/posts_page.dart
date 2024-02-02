import 'package:app/core/client.dart';
import 'package:app/core/loading_page.dart';
import 'package:app/forums/post_reply_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class PostsPage extends StatefulWidget {
  const PostsPage({
    required this.client,
    required this.forumId,
    required this.threadId,
    super.key,
  });

  static const route = 'Posts';

  final Client client;
  final String forumId;
  final String threadId;

  @override
  State<PostsPage> createState() => _PostsPageState();
}

class _PostsPageState extends State<PostsPage> {
  Thread? _thread;
  List<Post>? _posts;

  @override
  void initState() {
    super.initState();
    _fetchState();
  }

  @override
  void didUpdateWidget(PostsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fetchState();
  }

  Future<void> _fetchState() async {
    final thread = await widget.client.getThread(widget.threadId);
    final posts = await widget.client.getPosts(widget.threadId);
    setState(() {
      _thread = thread;
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    final thread = _thread;
    final posts = _posts;
    if (thread == null || posts == null) {
      return const LoadingPage();
    }
    return Scaffold(
      appBar: _buildAppBar(context, thread),
      body: _buildPosts(context, posts),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Thread thread) {
    return AppBar(
      title: Text(thread.title),
      actions: [
        _buildReplyButton(context, thread),
      ],
    );
  }

  Widget _buildReplyButton(BuildContext context, Thread thread) {
    return AspectRatio(
      aspectRatio: 1,
      child: IconButton(
        icon: const Icon(Icons.reply),
        onPressed: () => context.goNamed(
          PostReplyPage.route,
          pathParameters: {'forumId': thread.forumId, 'threadId': thread.id},
        ),
      ),
    );
  }

  Widget _buildPosts(BuildContext context, List<Post> posts) {
    if (posts.isEmpty) {
      return _buildEmpty(context);
    }
    return ListView(
      children: [
        for (final post in posts) ...[
          if (post != posts.first) ...[
            const Divider(height: 1),
          ],
          _buildPost(context, post),
        ],
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Text(
        'No posts yet.',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildPost(BuildContext context, Post post) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          leading: Icon(
            Icons.account_circle,
            size: 40,
            color: theme.colorScheme.outlineVariant,
          ),
          title: Text(post.username),
          subtitle: Text(post.createdAt.toString().substring(0, 16)),
        ),
        SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            post.message,
            style: theme.textTheme.bodyLarge,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
