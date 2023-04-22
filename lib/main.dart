import 'package:flutter/material.dart';
import 'package:profanity_filter_app/app/app.dart';
import 'package:profanity_filter_app/app/injecter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await init();
  runApp(SocialMedia());
}
