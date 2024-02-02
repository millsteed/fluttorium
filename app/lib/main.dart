import 'package:app/app.dart';
import 'package:app/core/client.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
  final preferences = await SharedPreferences.getInstance();
  const sessionKey = 'fluttorium.session';
  final client = Client(
    url: 'http://localhost:8080',
    onSessionLoad: () async => preferences.getString(sessionKey),
    onSessionSave: (data) => preferences.setString(sessionKey, data),
    onSessionClear: () => preferences.remove(sessionKey),
  );
  runApp(App(client: client));
}
