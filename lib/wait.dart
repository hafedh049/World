import 'package:flutter/material.dart';

class Wait extends StatelessWidget {
  const Wait({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset("assets/error.png", width: MediaQuery.sizeOf(context).width * .5));
  }
}
