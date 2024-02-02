import 'dart:convert';

import 'package:api/users/repositories/session_repository.dart';
import 'package:api/users/repositories/user_repository.dart';
import 'package:shared/shared.dart';
import 'package:shelf/shelf.dart';

class AccountController {
  AccountController({
    required this.userRepository,
    required this.sessionRepository,
  });

  final UserRepository userRepository;
  final SessionRepository sessionRepository;

  Future<Response> signIn(Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body) as Json;
    final username = json['username'] as String?;
    if (username == null || username.isEmpty) {
      return Response.badRequest(body: 'Username cannot be empty.');
    }
    final password = json['password'] as String?;
    if (password == null || password.isEmpty) {
      return Response.badRequest(body: 'Password cannot be empty.');
    }
    final user = await userRepository.getUserWithCredentials(
      username,
      password,
    );
    if (user == null) {
      return Response.badRequest(body: 'Invalid username or password.');
    }
    final session = await sessionRepository.createSession(user);
    return Response.ok(jsonEncode(session));
  }

  Future<Response> signUp(Request request) async {
    final body = await request.readAsString();
    final json = jsonDecode(body) as Json;
    final username = json['username'] as String?;
    if (username == null || username.isEmpty) {
      return Response.badRequest(body: 'Username cannot be empty.');
    }
    final password = json['password'] as String?;
    if (password == null || password.isEmpty) {
      return Response.badRequest(body: 'Password cannot be empty.');
    }
    final existingUser = await userRepository.getUserWithUsername(username);
    if (existingUser != null) {
      return Response.badRequest(body: 'Username is already taken.');
    }
    final user = await userRepository.createUser(username, password);
    final session = await sessionRepository.createSession(user);
    return Response.ok(jsonEncode(session));
  }

  Future<Response> signOut(Request request) async {
    final session = request.context['session'] as Session?;
    if (session == null) {
      return Response.unauthorized(null);
    }
    await sessionRepository.deleteSession(session);
    return Response.ok(null);
  }
}
