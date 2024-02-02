import 'dart:io';

import 'package:api/core/authorize.dart';
import 'package:api/forums/controllers/category_controller.dart';
import 'package:api/forums/controllers/forum_controller.dart';
import 'package:api/forums/controllers/post_controller.dart';
import 'package:api/forums/controllers/thread_controller.dart';
import 'package:api/forums/repositories/category_repository.dart';
import 'package:api/forums/repositories/forum_repository.dart';
import 'package:api/forums/repositories/post_repository.dart';
import 'package:api/forums/repositories/thread_repository.dart';
import 'package:api/users/controllers/account_controller.dart';
import 'package:api/users/repositories/session_repository.dart';
import 'package:api/users/repositories/user_repository.dart';
import 'package:postgres/postgres.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

Future<void> main() async {
  final database = await Connection.open(
    Endpoint(
      host: 'localhost',
      database: 'postgres',
      username: 'postgres',
      password: 'postgres',
    ),
    settings: const ConnectionSettings(sslMode: SslMode.disable),
  );

  final userRepository = UserRepository(database: database);
  final sessionRepository = SessionRepository(database: database);
  final accountController = AccountController(
    userRepository: userRepository,
    sessionRepository: sessionRepository,
  );

  final categoryRepository = CategoryRepository(database: database);
  final categoryController = CategoryController(
    categoryRepository: categoryRepository,
  );

  final forumRepository = ForumRepository(database: database);
  final forumController = ForumController(forumRepository: forumRepository);

  final threadRepository = ThreadRepository(database: database);
  final threadController = ThreadController(threadRepository: threadRepository);

  final postRepository = PostRepository(database: database);
  final postController = PostController(postRepository: postRepository);

  final router = Router()
    ..post('/account/signin', accountController.signIn)
    ..post('/account/signup', accountController.signUp)
    ..post('/account/signout', accountController.signOut)
    ..get('/categories', categoryController.getCategories)
    ..get('/forums', forumController.getForums)
    ..get('/forums/<forumId>', forumController.getForum)
    ..get('/forums/<forumId>/threads', threadController.getThreads)
    ..get('/threads/<threadId>', threadController.getThread)
    ..post('/forums/<forumId>/threads', threadController.createThread)
    ..get('/threads/<threadId>/posts', postController.getPosts)
    ..post('/threads/<threadId>/posts', postController.createPost);

  final pipeline = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(corsHeaders())
      .addMiddleware(authorize(sessionRepository));
  final handler = pipeline.addHandler(router.call);
  final server = await serve(handler, InternetAddress.anyIPv4, 8080);
  stdout.writeln('Server is listening on port ${server.port}');
}
