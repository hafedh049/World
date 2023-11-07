import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:world/utils/shared.dart';

class AboutMe extends StatelessWidget {
  const AboutMe({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.sizeOf(context).height,
        width: MediaQuery.sizeOf(context).width,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                IconButton(onPressed: () => Navigator.of(context).pop(), icon: const Icon(FontAwesomeIcons.chevronLeft, size: 15)),
                const Spacer(),
                const Text("H, I'm", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                ShaderMask(
                  shaderCallback: (Rect bounds) => const LinearGradient(colors: <Color>[Colors.red, Colors.blue, Colors.pink], stops: <double>[0.3, 0.7, .7]).createShader(bounds),
                  child: Text('Hafedh Gunichi', style: TextStyle(fontSize: MediaQuery.sizeOf(context).width * .06, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 20),
                const Text(description, style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
