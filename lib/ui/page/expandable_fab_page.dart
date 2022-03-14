import 'package:animation_library/ui/widget/expandable_fab.dart';
import 'package:flutter/material.dart';

class ExpandableFabPage extends StatefulWidget {
  const ExpandableFabPage({Key? key}) : super(key: key);

  @override
  State<ExpandableFabPage> createState() => _ExpandableFabPageState();
}

class _ExpandableFabPageState extends State<ExpandableFabPage> {
  var _counter = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expandable FAB')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Counter value:',
              style: Theme.of(context).textTheme.headline5,
            ),
            Text(
              _counter.toString(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ],
        ),
      ),
      floatingActionButton: ExpandableFab(
        expandedStyle: ExpandableFabStyle(
            color: Theme.of(context).colorScheme.primary,
            icon: const Icon(Icons.add)),
        shrinkStyle: ExpandableFabStyle(
            color: Theme.of(context).colorScheme.secondary,
            icon: const Icon(Icons.close)),
        children:  <ExpandableFabItem>[
          ExpandableFabItem(
            icon: const Icon(Icons.remove),
            onTap: () => _updateCounter(-1),
          ),
          ExpandableFabItem(
            icon: const Icon(Icons.delete),
            onTap: () => _resetCounter(),
          ),

          ExpandableFabItem(
            icon: const Icon(Icons.add),
            onTap: () => _updateCounter(1),
          ),
        ],
      ),
    );
  }

  void _updateCounter(int value) {
    setState(() {
      _counter += value;
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
  }
}
