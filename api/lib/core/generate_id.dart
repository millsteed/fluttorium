import 'dart:math';

String generateId([int length = 16]) {
  const all = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random();
  return List.generate(length, (_) => all[random.nextInt(all.length)]).join();
}
