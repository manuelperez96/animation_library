import 'package:animation_library/expandable_fab_page.dart';
import 'package:animation_library/expandable_searcher.dart';
import 'package:animation_library/shrinkable_card_page.dart';
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
        const Divider(),
        ListTile(
          title: const Text('Take a date'),
          onTap: () => _navigateTo(context, const CalendarPickerPage()),
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

class CalendarPickerPage extends StatelessWidget {
  const CalendarPickerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('Take a date')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.now().subtract(const Duration(days: 10)),
          lastDate: DateTime.now().add(const Duration(days: 100)),

        ),
        child: const Icon(Icons.calendar_today),
      ),
    );
  }
}
