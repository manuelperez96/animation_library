import 'package:animation_library/ui/page/expandable_fab_page.dart';
import 'package:animation_library/ui/page/expandable_searcher.dart';
import 'package:animation_library/ui/page/shrinkable_card_page.dart';
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
          title: const Text('ExpandableSearcher'),
          onTap: () => _navigateTo(context, const ExpandableSearcherPage()),
        ),
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

