import 'package:flutter/material.dart';
import 'package:world/utils/methods.dart';
import 'package:world/utils/shared.dart';
import 'package:world/welcome.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  world = await openHiveBox();
  await load();
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const Welcome(),
    );
  }
}
