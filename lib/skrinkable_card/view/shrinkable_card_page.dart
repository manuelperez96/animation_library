import 'package:flutter/material.dart';

class ShrinkableCardPage extends StatelessWidget {
  const ShrinkableCardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Shrinkable Card Page')),
      body: const ShrinkableCardView(),
    );
  }
}

class ShrinkableCardView extends StatefulWidget {
  const ShrinkableCardView({Key? key}) : super(key: key);

  @override
  State<ShrinkableCardView> createState() => _ShrinkableCardViewState();
}

class _ShrinkableCardViewState extends State<ShrinkableCardView> {
  late final ScrollController _controller;

  void _updateOnScroll() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _controller.addListener(_updateOnScroll);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: CustomScrollView(
        controller: _controller,
        slivers: [
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 150,
              child: Placeholder(),
            ),
          ),
          SliverPersistentHeader(
            delegate: PinnedTitle(),
            pinned: true,
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                var value = 1.0;
                const heightFactor = .7;
                const realHeight = 150 * heightFactor;
                final minRange = index * realHeight + 150;
                final maxRange = (index + 1) * realHeight + 150;

                if (_controller.offset > maxRange) {
                  value = 0;
                } else if (_controller.offset > minRange &&
                    _controller.offset < maxRange) {
                  final itemOffsetPosition = minRange;
                  final difference = _controller.offset - itemOffsetPosition;
                  value = (1 - (difference / realHeight).clamp(0, 1));
                }

                return Align(
                  heightFactor: heightFactor,
                  alignment: Alignment.topCenter,
                  child: Opacity(
                    opacity: value,
                    child: Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.identity()..scale(value, 1),
                      child: Card(
                        color:
                            Colors.primaries[index % Colors.primaries.length],
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: const SizedBox(
                          height: 150,
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: FlutterLogo(
                                  size: 50,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class PinnedTitle extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      alignment: Alignment.centerLeft,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: const Text('Title'),
    );
  }

  @override
  double get maxExtent => 50;

  @override
  double get minExtent => 50;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
