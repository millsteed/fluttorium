import 'package:app/core/client.dart';
import 'package:app/core/loading_page.dart';
import 'package:app/forums/posts_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class CreateThreadPage extends StatefulWidget {
  const CreateThreadPage({
    required this.client,
    required this.forumId,
    super.key,
  });

  static const route = 'CreateThread';

  final Client client;
  final String forumId;

  @override
  State<CreateThreadPage> createState() => _CreateThreadPageState();
}

class _CreateThreadPageState extends State<CreateThreadPage> {
  Forum? _forum;

  var _title = '';
  var _message = '';

  @override
  void initState() {
    super.initState();
    _fetchState();
  }

  Future<void> _fetchState() async {
    final forum = await widget.client.getForum(widget.forumId);
    setState(() => _forum = forum);
  }

  @override
  Widget build(BuildContext context) {
    final forum = _forum;
    if (forum == null) {
      return const LoadingPage();
    }
    return Scaffold(
      appBar: _buildAppBar(context, forum),
      body: _buildForm(context, forum),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Forum forum) {
    return AppBar(
      title: const Text('Create thread'),
      actions: [
        _buildSubmitButton(context, forum),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, Forum forum) {
    return AspectRatio(
      aspectRatio: 1,
      child: IconButton(
        icon: const Icon(Icons.check),
        onPressed: _title.isNotEmpty && _message.isNotEmpty
            ? () => _handleSubmitPressed(context, forum)
            : null,
      ),
    );
  }

  Widget _buildForm(BuildContext context, Forum forum) {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildForumField(context, forum),
        const SizedBox(height: 16),
        _buildTitleField(context),
        const SizedBox(height: 16),
        _buildMessageField(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildForumField(BuildContext context, Forum forum) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        enabled: false,
        decoration: const InputDecoration(labelText: 'Forum'),
        initialValue: forum.title,
      ),
    );
  }

  Widget _buildTitleField(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        decoration: const InputDecoration(labelText: 'Title'),
        onChanged: (title) => setState(() => _title = title),
        initialValue: _title,
      ),
    );
  }

  Widget _buildMessageField(BuildContext context) {
    return Expanded(
      child: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16),
        child: TextFormField(
          expands: true,
          decoration: const InputDecoration(
            alignLabelWithHint: true,
            labelText: 'Message',
          ),
          textAlignVertical: TextAlignVertical.top,
          maxLines: null,
          onChanged: (message) => setState(() => _message = message),
          initialValue: _message,
        ),
      ),
    );
  }

  Future<void> _handleSubmitPressed(BuildContext context, Forum forum) async {
    final thread = await widget.client.createThread(forum.id, _title);
    await widget.client.createPost(thread.id, _message);
    if (!context.mounted) {
      return;
    }
    context.goNamed(
      PostsPage.route,
      pathParameters: {'forumId': forum.id, 'threadId': thread.id},
    );
  }
}
