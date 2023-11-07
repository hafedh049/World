import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:world/utils/shared.dart';

class GameCard extends StatefulWidget {
  const GameCard({super.key, required this.data, required this.image});
  final Map<dynamic, dynamic> data;
  final int image;
  @override
  State<GameCard> createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: transparent,
      highlightColor: transparent,
      hoverColor: transparent,
      onTap: () {},
      onHover: (bool value) => setState(() => _hover = value),
      child: AnimatedScale(
        duration: 500.ms,
        scale: _hover ? 1.1 : 1,
        child: AnimatedContainer(
          duration: 500.ms,
          width: 400,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(image: DecorationImage(image: AssetImage("assets/${widget.image}.png"), fit: BoxFit.cover), borderRadius: BorderRadius.circular(15)),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: widget.data["state"] == "WIN"
                              ? green.withOpacity(.8)
                              : widget.data["state"] == "LOSS"
                                  ? red.withOpacity(.8)
                                  : yellow.withOpacity(.8),
                          borderRadius: BorderRadius.circular(5)),
                      child: Center(child: Text(widget.data["state"])),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: blue.withOpacity(.8), borderRadius: BorderRadius.circular(5)),
                      child: Center(child: Text(widget.data["magicWord"]["word"])),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(color: dark.withOpacity(.6), borderRadius: BorderRadius.circular(5)),
                        child: Center(child: Text(widget.data["magicWord"]["description"][0].toUpperCase() + widget.data["magicWord"]["description"].substring(1))),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(color: dark.withOpacity(.6), borderRadius: BorderRadius.circular(5)),
                      child: Center(child: Text(widget.data["creationDate"].toString().split(' ')[0])),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
