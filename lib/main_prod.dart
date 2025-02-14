// lib/main_prod.dart
import 'package:flutter/material.dart';
import 'core/config/env_config.dart';
import 'app.dart';

void main() {
  EnvConfig.setupEnv(Environment.prod);
  runApp(const MyApp());
}
