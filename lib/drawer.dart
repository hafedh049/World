import 'package:flutter/material.dart';

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
            children: <Widget>[
              InkWell(
                child: Column(
                  children: <Widget>[],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
