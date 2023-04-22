import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/injecter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  runApp(SocialMedia());
}
