// lib/main_dev.dart
import 'package:flutter/material.dart';
import 'core/config/env_config.dart';
import 'app.dart';

void main() {
  EnvConfig.setupEnv(Environment.dev);
  runApp(const MyApp());
}
