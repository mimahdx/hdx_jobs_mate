
// lib/main_hotfix.dart
import 'package:flutter/material.dart';
import 'core/config/env_config.dart';
import 'app.dart';
import 'di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  EnvConfig.setupEnv(Environment.hotfix);
  await di.init();
  runApp(const MyApp());
}