import 'package:app/core/client.dart';
import 'package:app/core/loading_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class PostReplyPage extends StatefulWidget {
  const PostReplyPage({
    required this.client,
    required this.forumId,
    required this.threadId,
    super.key,
  });

  static const route = 'PostReply';

  final Client client;
  final String forumId;
  final String threadId;

  @override
  State<PostReplyPage> createState() => _PostReplyPageState();
}

class _PostReplyPageState extends State<PostReplyPage> {
  Thread? _thread;

  var _message = '';

  @override
  void initState() {
    super.initState();
    _fetchState();
  }

  Future<void> _fetchState() async {
    final thread = await widget.client.getThread(widget.threadId);
    setState(() => _thread = thread);
  }

  @override
  Widget build(BuildContext context) {
    final thread = _thread;
    if (thread == null) {
      return const LoadingPage();
    }
    return Scaffold(
      appBar: _buildAppBar(context, thread),
      body: _buildForm(context, thread),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context, Thread thread) {
    return AppBar(
      title: const Text('Post reply'),
      actions: [
        _buildSubmitButton(context, thread),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context, Thread thread) {
    return AspectRatio(
      aspectRatio: 1,
      child: IconButton(
        icon: const Icon(Icons.check),
        onPressed: _message.isNotEmpty
            ? () => _handleSubmitPressed(context, thread)
            : null,
      ),
    );
  }

  Widget _buildForm(BuildContext context, Thread thread) {
    return Column(
      children: [
        const SizedBox(height: 16),
        _buildThreadField(context, thread),
        const SizedBox(height: 16),
        _buildMessageField(context),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildThreadField(BuildContext context, Thread thread) {
    return SafeArea(
      minimum: const EdgeInsets.symmetric(horizontal: 16),
      child: TextFormField(
        enabled: false,
        decoration: const InputDecoration(labelText: 'Thread'),
        initialValue: thread.title,
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

  Future<void> _handleSubmitPressed(BuildContext context, Thread thread) async {
    await widget.client.createPost(thread.id, _message);
    if (!context.mounted) {
      return;
    }
    context.pop();
  }
}
