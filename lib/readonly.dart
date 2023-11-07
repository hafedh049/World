import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:world/utils/methods.dart';
import 'package:world/utils/shared.dart';

class ReadOnly extends StatefulWidget {
  const ReadOnly({super.key, required this.data});
  final Map<dynamic, dynamic> data;
  @override
  State<ReadOnly> createState() => _ReadOnlyState();
}

class _ReadOnlyState extends State<ReadOnly> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(FontAwesomeIcons.chevronLeft, size: 25)),
              const SizedBox(height: 10),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (int indexI = 0; indexI < 6; indexI++)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          for (int indexJ = 0; indexJ < cellsSize; indexJ++)
                            Padding(
                              padding: const EdgeInsets.only(left: 12, bottom: 12),
                              child: Tooltip(
                                waitDuration: 2.seconds,
                                message: widget.data["gameMatrix"][indexI][indexJ]["type"],
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: calculateColor(widget.data["gameMatrix"][indexI][indexJ]["type"]),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(width: .5, color: widget.data["gameMatrix"][indexI][indexJ]["key"] == "" ? white.withOpacity(.4) : white.withOpacity(.8)),
                                  ),
                                  child: Center(child: Text(widget.data["gameMatrix"][indexI][indexJ]["key"], style: const TextStyle(color: white, fontSize: 24, fontWeight: FontWeight.bold))),
                                ),
                              ),
                            ),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: blue.withOpacity(.8), borderRadius: BorderRadius.circular(5)),
                      child: Center(child: Text(widget.data["magicWord"]["word"])),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: green.withOpacity(.6), borderRadius: BorderRadius.circular(5)),
                        child: Center(child: Text(widget.data["magicWord"]["description"][0].toUpperCase() + widget.data["magicWord"]["description"].substring(1))),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
