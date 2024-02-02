import 'dart:convert';

import 'package:api/forums/repositories/forum_repository.dart';
import 'package:shelf/shelf.dart';

class ForumController {
  ForumController({required this.forumRepository});

  final ForumRepository forumRepository;

  Future<Response> getForums(Request request) async {
    final forums = await forumRepository.getForums();
    return Response.ok(jsonEncode(forums));
  }

  Future<Response> getForum(Request request, String forumId) async {
    final forum = await forumRepository.getForum(forumId);
    if (forum == null) {
      return Response.notFound(null);
    }
    return Response.ok(jsonEncode(forum));
  }
}
