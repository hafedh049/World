import 'package:flutter/material.dart';

class EError extends StatelessWidget {
  const EError({super.key, required this.error});
  final String error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Flexible(child: Image.asset("assets/error.png")),
            const SizedBox(height: 20),
            Flexible(child: Text(error)),
          ],
        ),
      ),
    );
  }
}
