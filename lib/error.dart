import 'package:flutter/material.dart';

class EError extends StatelessWidget {
  const EError({super.key, required this.error});
  final String error;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Image.asset("assets/error.png", width: MediaQuery.sizeOf(context).width * .5, height: MediaQuery.sizeOf(context).width * .5),
          const SizedBox(height: 20),
          Text(error),
        ],
      ),
    );
  }
}
