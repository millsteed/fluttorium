import 'package:api/users/repositories/session_repository.dart';
import 'package:shelf/shelf.dart';

Middleware authorize(SessionRepository sessionRepository) {
  return (handler) {
    return (request) async {
      final authorizationHeader = request.headers['Authorization'];
      if (authorizationHeader == null) {
        return handler(request);
      }
      final token = authorizationHeader.replaceFirst('Bearer ', '');
      final session = await sessionRepository.getSessionWithToken(token);
      if (session == null) {
        return Response.unauthorized(null);
      }
      return handler(request.change(context: {'session': session}));
    };
  };
}
