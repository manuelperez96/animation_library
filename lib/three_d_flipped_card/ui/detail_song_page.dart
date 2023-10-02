import 'dart:math';
import 'dart:ui';

import 'package:animation_library/three_d_flipped_card/three_d_flipped_card.dart';
import 'package:flutter/material.dart';

class DetailSongPage extends StatelessWidget {
  const DetailSongPage({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(song.name),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          SizedBox(height: size.height * .1),
          Align(
            child: SizedBox(
              height: 200,
              child: Hero(
                tag: song.name,
                flightShuttleBuilder: _animateOnNavigation,
                child: SongCard(song: song),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Align(
            child: Text(
              song.name,
              style: Theme.of(context).textTheme.displaySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _animateOnNavigation(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    Widget child;

    if (flightDirection == HeroFlightDirection.push) {
      child = toHeroContext.widget;
    } else {
      child = fromHeroContext.widget;
    }

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateX(
              lerpDouble(0, 2 * pi, animation.value)!,
            ),
          child: child,
        );
      },
    );
  }
}
