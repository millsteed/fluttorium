import 'package:app/core/client.dart';
import 'package:app/core/loading_page.dart';
import 'package:app/forums/create_thread_page.dart';
import 'package:app/forums/posts_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class ThreadsPage extends StatefulWidget {
  const ThreadsPage({required this.client, required this.forumId, super.key});

  static const route = 'Threads';

  final Client client;
  final String forumId;

  @override
  State<ThreadsPage> createState() => _ThreadsPageState();
}

class _ThreadsPageState extends State<ThreadsPage> {
  Forum? _forum;
  List<Thread>? _threads;

  @override
  void initState() {
    super.initState();
    _fetchState();
  }

  @override
  void didUpdateWidget(ThreadsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _fetchState();
  }

  Future<void> _fetchState() async {
    final forum = await widget.client.getForum(widget.forumId);
    final threads = await widget.client.getThreads(widget.forumId);
    setState(() {
      _forum = forum;
      _threads = threads;
    });
  }

  @override
  Widget build(BuildContext context) {
    final forum = _forum;
    final threads = _threads;
    if (forum == null || threads == null) {
      return const LoadingPage();
    }
    return Scaffold(
      appBar: _buildAppBar(context, forum),
      body: _buildThreads(context, forum, threads),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Forum forum) {
    return AppBar(
      title: Text(forum.title),
      actions: [
        _buildCreateThreadButton(context, forum),
      ],
    );
  }

  Widget _buildCreateThreadButton(BuildContext context, Forum forum) {
    return AspectRatio(
      aspectRatio: 1,
      child: IconButton(
        icon: const Icon(Icons.post_add),
        onPressed: () => context.goNamed(
          CreateThreadPage.route,
          pathParameters: {'forumId': forum.id},
        ),
      ),
    );
  }

  Widget _buildThreads(
    BuildContext context,
    Forum forum,
    List<Thread> threads,
  ) {
    if (threads.isEmpty) {
      return _buildEmpty(context);
    }
    return ListView(
      children: [
        for (final thread in threads) ...[
          _buildThread(context, forum, thread),
        ],
      ],
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Text(
        'No threads yet.',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }

  Widget _buildThread(BuildContext context, Forum forum, Thread thread) {
    return ListTile(
      title: Text(thread.title),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => context.goNamed(
        PostsPage.route,
        pathParameters: {'forumId': forum.id, 'threadId': thread.id},
      ),
    );
  }
}
