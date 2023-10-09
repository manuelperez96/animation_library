import 'package:animation_library/animated_bounce_bottom_navigation_bar/animated_bounce_bottom_navigation_bar.dart';
import 'package:animation_library/awoseme_app_bar/awoseme_app_bar.dart';
import 'package:animation_library/expandable_fab/expandable_fab.dart';
import 'package:animation_library/expandable_searcher/expandable_searcher.dart';
import 'package:animation_library/skrinkable_card/skrinkable_card.dart';
import 'package:animation_library/three_d_flipped_card/three_d_flipped_card.dart';
import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animation library',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Animation library'),
        ),
        body: const Home(),
      ),
    );
  }
}

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        ListTile(
          title: const Text('Expandable Fav'),
          onTap: () => _navigateTo(context, const ExpandableFabPage()),
        ),
        const Divider(),
        ListTile(
          title: const Text('Shrinkable Card Page'),
          onTap: () => _navigateTo(context, const ShrinkableCardPage()),
        ),
        const Divider(),
        ListTile(
          title: const Text('Expandable Searcher'),
          onTap: () => _navigateTo(context, const ExpandableSearcherPage()),
        ),
        const Divider(),
        ListTile(
          title: const Text('Awesome AppBar'),
          onTap: () => _navigateTo(context, const AwesomeAppBarPage()),
        ),
        const Divider(),
        ListTile(
          title: const Text('3D Flipped Card'),
          onTap: () => _navigateTo(context, const AlbumPage()),
        ),
        const Divider(),
         ListTile(
          title: const Text('Animated Bounce Bottom Bar'),
          onTap: () => _navigateTo(context, const AnimatedBounceBottomBarPage()),
        ),
        const Divider(),
      ],
    );
  }

  void _navigateTo(BuildContext context, Widget page) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => page,
        ),
      );
}

