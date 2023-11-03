import 'package:flutter/material.dart';
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
              for (final Map<String, dynamic> entry in menu)
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 16),
                  child: InkWell(
                    onTap: () => true,
                    splashColor: transparent,
                    hoverColor: transparent,
                    highlightColor: transparent,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[Icon(entry["icon"], size: 15), const SizedBox(width: 10), Text(entry["item"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))]),
                        const SizedBox(height: 5),
                        Container(height: .9, width: entry["item"].length * 12.0, color: white),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
