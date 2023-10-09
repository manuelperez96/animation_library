import 'package:animation_library/expandable_searcher/widget/expandable_widget.dart';
import 'package:flutter/material.dart';

class ExpandableSearcherPage extends StatelessWidget {
  const ExpandableSearcherPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text('Expandable Searcher')),
        body: const ExpandableSearcherView());
  }
}

class ExpandableSearcherView extends StatefulWidget {
  const ExpandableSearcherView({Key? key}) : super(key: key);

  @override
  State<ExpandableSearcherView> createState() => _ExpandableSearcherViewState();
}

class _ExpandableSearcherViewState extends State<ExpandableSearcherView> {

  var _isOpen = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Flexible(
            child: Row(
              children: <Widget>[
                const Text('Introduzca criterio'),
                const SizedBox(width: 16),
                Expanded(
                  child: ExpandedWidget(
                    isOpen: _isOpen,
                    closeIcon: const Icon(Icons.remove),
                    openIcon: const Icon(Icons.add),
                    onChanged: _updateSearcher,
                    child:  const TextField(
                      maxLines: 1,
                      cursorColor: Colors.white,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 9.5, vertical: 7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(22)),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _updateSearcher(bool value) {
    setState(() {
      _isOpen = value;
    });
  }
}

class ExpandableSearcher extends StatefulWidget {
  const ExpandableSearcher({
    Key? key,
    required this.isExpanded,
  }) : super(key: key);

  final bool isExpanded;

  @override
  State<ExpandableSearcher> createState() => _ExpandableSearcherState();
}

class _ExpandableSearcherState extends State<ExpandableSearcher> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  void didUpdateWidget(covariant ExpandableSearcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: 60,
      child: Stack(
        children: <Widget>[
          AnimatedPositioned(
            duration: const Duration(milliseconds: 150),
            left: 0,
            height: 60,
            width: _isExpanded ? size.width : 32,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.brown,
                  borderRadius: BorderRadius.circular(50)
              ),
              child: const TextField(),
            ),
          )
        ],
      ),
    );
  }
}
