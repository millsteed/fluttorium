import 'dart:convert';

import 'package:api/forums/repositories/thread_repository.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

class ThreadController {
  ThreadController({required this.threadRepository});

  final ThreadRepository threadRepository;

  Future<Response> getThreads(Request request, String forumId) async {
    final threads = await threadRepository.getThreads(forumId);
    return Response.ok(jsonEncode(threads));
  }

  Future<Response> getThread(Request request, String threadId) async {
    final thread = await threadRepository.getThread(threadId);
    if (thread == null) {
      return Response.notFound(null);
    }
    return Response.ok(jsonEncode(thread));
  }

  Future<Response> createThread(Request request, String forumId) async {
    final session = request.context['session'] as Session?;
    if (session == null) {
      return Response.unauthorized(null);
    }
    final body = await request.readAsString();
    final json = jsonDecode(body) as Json;
    final title = json['title'] as String?;
    if (title == null || title.isEmpty) {
      return Response.badRequest(body: 'Title cannot be empty.');
    }
    final thread = await threadRepository.createThread(
      forumId,
      session.user.id,
      title,
    );
    return Response.ok(jsonEncode(thread));
  }
}
