import 'dart:convert';

import 'package:api/forums/repositories/post_repository.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

class PostController {
  PostController({required this.postRepository});

  final PostRepository postRepository;

  Future<Response> getPosts(Request request, String threadId) async {
    final posts = await postRepository.getPosts(threadId);
    return Response.ok(jsonEncode(posts));
  }

  Future<Response> createPost(Request request, String threadId) async {
    final session = request.context['session'] as Session?;
    if (session == null) {
      return Response.unauthorized(null);
    }
    final body = await request.readAsString();
    final json = jsonDecode(body) as Json;
    final message = json['message'] as String?;
    if (message == null || message.isEmpty) {
      return Response.badRequest(body: 'Message cannot be empty.');
    }
    final post = await postRepository.createPost(
      threadId,
      session.user,
      message,
    );
    return Response.ok(jsonEncode(post));
  }
}
