import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:world/utils/shared.dart';

class DDrawer extends StatefulWidget {
  const DDrawer({super.key});

  @override
  State<DDrawer> createState() => _DDrawerState();
}

class _DDrawerState extends State<DDrawer> {
  bool _cocktailShaker = false;
  final Widget _logo = Image.asset("assets/w.png", width: 150, height: 150);
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
              Center(
                child: StatefulBuilder(
                  builder: (BuildContext context, void Function(void Function()) _) {
                    return InkWell(
                      hoverColor: transparent,
                      splashColor: transparent,
                      highlightColor: transparent,
                      onTap: () => true,
                      onHover: (bool value) => _(() => _cocktailShaker = value),
                      child: _cocktailShaker ? _logo.animate().shakeX() : _logo,
                    );
                  },
                ),
              ),
              const SizedBox(height: 30),
              for (final Map<String, dynamic> entry in menu)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: StatefulBuilder(
                    builder: (BuildContext context, void Function(void Function()) _) {
                      return InkWell(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => entry["screen"])),
                        onHover: (bool value) => _(() => entry["state"] = value),
                        splashColor: transparent,
                        hoverColor: transparent,
                        highlightColor: transparent,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(entry["icon"], size: 15, color: entry["state"] ? blue : null),
                                const SizedBox(width: 10),
                                Text(entry["item"], style: TextStyle(fontSize: 16, color: entry["state"] ? blue : null)),
                              ],
                            ),
                            const SizedBox(height: 5),
                            AnimatedContainer(duration: 700.ms, height: .9, width: entry["state"] ? entry["item"].replaceAll(" ", "").length * 10.0 + 5 : 0, color: white),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              const Row(children: <Widget>[Icon(FontAwesomeIcons.themeco, size: 15), SizedBox(width: 10), Text("Themes", style: TextStyle(fontSize: 16))]),
              const SizedBox(height: 10),
              ToggleSwitch(
                customWidths: const <double>[90, 50],
                cornerRadius: 15.0,
                activeBgColors: <List<Color>>[
                  const <Color>[blue],
                  <Color>[yellow],
                ],
                animate: true,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                totalSwitches: 2,
                labels: const <String>['DARK', ''],
                icons: const <IconData>[FontAwesomeIcons.moon, FontAwesomeIcons.sun],
                onToggle: (int? index) {},
              ),
              const SizedBox(height: 20),
              const Row(children: <Widget>[Icon(FontAwesomeIcons.language, size: 15), SizedBox(width: 10), Text("Supported Languages", style: TextStyle(fontSize: 16))]),
              const SizedBox(height: 10),
              ToggleSwitch(
                labels: supportedLanguages,
                animate: true,
                minHeight: 40,
                initialLabelIndex: 0,
                cornerRadius: 15,
                activeFgColor: white,
                inactiveBgColor: dark.withOpacity(.3),
                inactiveFgColor: white,
                totalSwitches: 3,
                icons: const <IconData>[FontAwesomeIcons.earthAfrica, FontAwesomeIcons.earthAfrica, FontAwesomeIcons.earthAfrica],
                iconSize: 15,
                borderColor: const <Color>[Color(0xff3b5998), Color(0xff8b9dc3), Color(0xff00aeff), Color(0xff0077f2), Color(0xff962fbf), Color(0xff4f5bd5)],
                dividerColor: blue,
                onToggle: (int? index) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
