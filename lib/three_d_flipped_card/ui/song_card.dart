import 'package:animation_library/three_d_flipped_card/three_d_flipped_card.dart';
import 'package:flutter/material.dart';

class SongCard extends StatelessWidget {
  const SongCard({super.key, required this.song});

  final Song song;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(15);

    return PhysicalModel(
      color: Colors.black,
      borderRadius: borderRadius,
      elevation: 10,
      shadowColor: Colors.black,
      child: AspectRatio(
        aspectRatio: 1,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Image.asset(
            song.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
