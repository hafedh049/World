import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:world/utils/shared.dart';

class DDrawer extends StatefulWidget {
  const DDrawer({super.key});

  @override
  State<DDrawer> createState() => _DDrawerState();
}

class _DDrawerState extends State<DDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Center(child: Image.asset("assets/w.png", width: 100, height: 100).animate(onComplete: (AnimationController controller) => controller.repeat()).rotate(duration: 5.seconds)),
              const SizedBox(height: 30),
              for (final Map<String, dynamic> entry in menu)
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16),
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return InkWell(
                        onTap: () => true,
                        onHover: (bool value) => _(() => entry["state"] = value),
                        splashColor: transparent,
                        hoverColor: transparent,
                        highlightColor: transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(mainAxisSize: MainAxisSize.min, children: <Widget>[Icon(entry["icon"], size: 15, color: entry["state"] ? blue : null), const SizedBox(width: 10), Text(entry["item"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: entry["state"] ? blue : null))]),
                            const SizedBox(height: 5),
                            AnimatedContainer(duration: 700.ms, height: .9, width: entry["state"] ? entry["item"].length * 12.0 + 5 : 0, color: white),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
