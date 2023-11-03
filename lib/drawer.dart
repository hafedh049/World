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
            children: <Widget>[
              for (final Map<String, dynamic> entry in menu)
                InkWell(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16, bottom: 16),
                    child: Column(
                      children: <Widget>[
                        Text(entry["item"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Container(height: .5, width: entry["item"].length * 7.0, color: blue),
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
