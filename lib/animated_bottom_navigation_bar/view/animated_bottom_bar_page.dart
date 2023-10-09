import 'package:flutter/material.dart';

class AnimatedBounceBottomBarPage extends StatefulWidget {
  const AnimatedBounceBottomBarPage({super.key});

  @override
  State<AnimatedBounceBottomBarPage> createState() =>
      _AnimatedBounceBottomBarPageState();
}

class _AnimatedBounceBottomBarPageState
    extends State<AnimatedBounceBottomBarPage> {
  var _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text('Animated Bounce Bottom Bar'),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: const [
          ColoredBox(
            color: Colors.red,
            child: SizedBox.expand(
              child: Center(
                child: Text('Home'),
              ),
            ),
          ),
          ColoredBox(
            color: Colors.blue,
            child: SizedBox.expand(
              child: Center(
                child: Text('Search'),
              ),
            ),
          ),
          ColoredBox(
            color: Colors.yellow,
            child: SizedBox.expand(
              child: Center(
                child: Text('Profile'),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BounceBottomBar(
        selectedIndex: _selectedIndex,
        onIndexChanged: (index) => setState(() => _selectedIndex = index),
        children: const [
          Icon(Icons.home),
          Icon(Icons.search),
          Icon(Icons.person),
        ],
      ),
    );
  }
}

class BounceBottomBar extends StatefulWidget {
  const BounceBottomBar({
    super.key,
    required this.children,
    required this.onIndexChanged,
    required this.selectedIndex,
  });

  final List<Widget> children;
  final ValueChanged<int> onIndexChanged;
  final int selectedIndex;

  @override
  State<BounceBottomBar> createState() => _BounceBottomBarState();
}

class _BounceBottomBarState extends State<BounceBottomBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  late final Animation<double> _decreaseBarAnimation;
  late final Animation<double> _increaseBarAnimation;
  late final Animation<double> _radialCircleAnimation;
  late final Animation<double> _itemElevationAnimation;
  late final Animation<double> _itemDropAnimation;

  static const _maxBarReduction = 75;
  static const _maxElevationItem = 60;
  static const _itemElevationOnSelected = kBottomNavigationBarHeight / 4;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _decreaseBarAnimation = CurveTween(
      curve: const Interval(
        .0,
        .5,
        curve: Curves.decelerate,
      ),
    ).animate(_controller);
    _increaseBarAnimation = CurveTween(
      curve: const Interval(
        .5,
        1,
        curve: Curves.bounceOut,
      ),
    ).animate(_controller);
    _radialCircleAnimation = CurveTween(
      curve: const Interval(
        .0,
        .5,
      ),
    ).animate(_controller);
    _itemElevationAnimation = CurveTween(
      curve: const Interval(
        .0,
        .5,
        curve: Curves.fastLinearToSlowEaseIn,
      ),
    ).animate(_controller);
    _itemDropAnimation = CurveTween(
      curve: const Interval(
        .5,
        1,
        curve: Curves.bounceOut,
      ),
    ).animate(_controller);
    _controller.value = 1;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BounceBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex != widget.selectedIndex) {
      _startAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return Align(
      heightFactor: 1,
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: kBottomNavigationBarHeight + bottomPadding,
          maxWidth: 600,
        ),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final itemPosition =
                (-_maxElevationItem * _itemElevationAnimation.value) +
                    ((_maxElevationItem - _itemElevationOnSelected) *
                        _itemDropAnimation.value);
            return SizedBox(
              width: screenWidth -
                  (_maxBarReduction * _decreaseBarAnimation.value) +
                  (_maxBarReduction * _increaseBarAnimation.value),
              child: DecoratedBox(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomPadding),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(
                      widget.children.length,
                      (index) {
                        if (widget.selectedIndex == index) {
                          return _buildSelectedItem(index, itemPosition);
                        } else {
                          return _buildUnselectedItem(index);
                        }
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _startAnimation() {
    _controller.forward(from: 0);
  }

  Widget _buildSelectedItem(int index, double itemPosition) {
    return CustomPaint(
      foregroundPainter: _RadialCirclePainter(
        progress: _radialCircleAnimation.value,
      ),
      child: Transform.translate(
        offset: Offset(0, itemPosition),
        child: CircleAvatar(
          radius: 30,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          child: widget.children[index],
        ),
      ),
    );
  }

  Widget _buildUnselectedItem(int index) {
    return GestureDetector(
      onTap: () => widget.onIndexChanged(index),
      child: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        child: widget.children[index],
      ),
    );
  }
}

class _RadialCirclePainter extends CustomPainter {
  final double progress;

  _RadialCirclePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 1) return;
    final center = Offset(size.width / 2, size.height / 2);
    const radius = 25.0;
    const strokeWidth = 10.0;
    canvas.drawCircle(
      center,
      radius * progress,
      Paint()
        ..color = Colors.black
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth * (1 - progress),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
