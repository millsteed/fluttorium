import 'dart:convert';

import 'package:http/http.dart';
import 'package:shared/shared.dart';

class Client {
  Client({
    required this.url,
    required this.onSessionLoad,
    required this.onSessionSave,
    required this.onSessionClear,
  }) {
    onSessionLoad().then((data) {
      if (data != null) {
        _session = Session.fromJson(jsonDecode(data) as Json);
      }
    });
  }

  final String url;

  final Future<String?> Function() onSessionLoad;
  final Future<void> Function(String data) onSessionSave;
  final Future<void> Function() onSessionClear;

  Session? _session;

  Session? get session => _session;

  Map<String, String> get _headers {
    final session = _session;
    return {if (session != null) 'Authorization': 'Bearer ${session.token}'};
  }

  Future<Session> signIn(String username, String password) async {
    final response = await post(
      Uri.parse('$url/account/signin'),
      headers: _headers,
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode != 200) {
      throw ClientException(error: response.body);
    }
    final session = Session.fromJson(jsonDecode(response.body) as Json);
    await onSessionSave(response.body);
    _session = session;
    return session;
  }

  Future<Session> signUp(String username, String password) async {
    final response = await post(
      Uri.parse('$url/account/signup'),
      headers: _headers,
      body: jsonEncode({'username': username, 'password': password}),
    );
    if (response.statusCode != 200) {
      throw ClientException(error: response.body);
    }
    final session = Session.fromJson(jsonDecode(response.body) as Json);
    await onSessionSave(response.body);
    _session = session;
    return session;
  }

  Future<void> signOut() async {
    final response = await post(
      Uri.parse('$url/account/signout'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw ClientException(error: response.body);
    }
    await onSessionClear();
    _session = null;
  }

  Future<List<Category>> getCategories() async {
    final response = await get(
      Uri.parse('$url/categories'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw ClientException(error: response.body);
    }
    return (jsonDecode(response.body) as List<dynamic>)
        .whereType<Json>()
        .map(Category.fromJson)
        .toList();
  }

  Future<List<Forum>> getForums() async {
    final response = await get(
      Uri.parse('$url/forums'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw ClientException(error: response.body);
    }
    return (jsonDecode(response.body) as List<dynamic>)
        .whereType<Json>()
        .map(Forum.fromJson)
        .toList();
  }

  Future<Forum> getForum(String forumId) async {
    final response = await get(
      Uri.parse('$url/forums/$forumId'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw ClientException(error: response.body);
    }
    return Forum.fromJson(jsonDecode(response.body) as Json);
  }

  Future<List<Thread>> getThreads(String forumId) async {
    final response = await get(
      Uri.parse('$url/forums/$forumId/threads'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw ClientException(error: response.body);
    }
    return (jsonDecode(response.body) as List<dynamic>)
        .whereType<Json>()
        .map(Thread.fromJson)
        .toList();
  }

  Future<Thread> getThread(String threadId) async {
    final response = await get(
      Uri.parse('$url/threads/$threadId'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw ClientException(error: response.body);
    }
    return Thread.fromJson(jsonDecode(response.body) as Json);
  }

  Future<Thread> createThread(String forumId, String title) async {
    final response = await post(
      Uri.parse('$url/forums/$forumId/threads'),
      headers: _headers,
      body: jsonEncode({'title': title}),
    );
    if (response.statusCode != 200) {
      throw ClientException(error: response.body);
    }
    return Thread.fromJson(jsonDecode(response.body) as Json);
  }

  Future<List<Post>> getPosts(String threadId) async {
    final response = await get(
      Uri.parse('$url/threads/$threadId/posts'),
      headers: _headers,
    );
    if (response.statusCode != 200) {
      throw ClientException(error: response.body);
    }
    return (jsonDecode(response.body) as List<dynamic>)
        .whereType<Json>()
        .map(Post.fromJson)
        .toList();
  }

  Future<Post> createPost(String threadId, String message) async {
    final response = await post(
      Uri.parse('$url/threads/$threadId/posts'),
      headers: _headers,
      body: jsonEncode({'message': message}),
    );
    if (response.statusCode != 200) {
      throw ClientException(error: response.body);
    }
    return Post.fromJson(jsonDecode(response.body) as Json);
  }
}

class ClientException implements Exception {
  ClientException({required this.error});

  final String error;
}
