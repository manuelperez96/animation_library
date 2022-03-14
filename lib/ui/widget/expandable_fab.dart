import 'package:flutter/material.dart';
import 'dart:math' as math;

const _expandedDuration = Duration(milliseconds: 250);

class ExpandableFabStyle {
  ExpandableFabStyle({
    required this.color,
    required this.icon,
  });

  final Color color;
  final Widget icon;
}

class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    required this.expandedStyle,
    required this.shrinkStyle,
    required this.children,
    this.initialOpened = false,
    this.distance = 100,
  }) : super(key: key);

  final ExpandableFabStyle expandedStyle;
  final ExpandableFabStyle shrinkStyle;
  final bool initialOpened;
  final double distance;
  final List<ExpandableFabItem> children;

  @override
  State<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late bool _isOpened;

  @override
  void initState() {
    super.initState();
    _isOpened = widget.initialOpened;
    _controller = AnimationController(
      vsync: this,
      duration: _expandedDuration,
      value: _isOpened ? 1 : 0,
    );
  }

  void _toggle() {
    setState(() {
      if (_isOpened) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
      _isOpened = !_isOpened;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          ..._buildInnerItems(),
          _AnimatedFab(
            expandedStyle: widget.expandedStyle,
            shrinkStyle: widget.shrinkStyle,
            isOpened: _isOpened,
            onTap: _toggle,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildInnerItems() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90 / (count - 1);

    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandableFabItemAnimationBuilder(
          directionInDegrees: angleInDegrees,
          progress: _controller,
          maxDistance: widget.distance,
          child: widget.children[i],
        ),
      );
    }

    return children;
  }
}

class ExpandableFabItem extends StatelessWidget {
  const ExpandableFabItem({
    Key? key,
    required this.icon,
    this.onTap,
    this.color,
  }) : super(key: key);

  final VoidCallback? onTap;
  final Color? color;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = color ?? theme.primaryColor;

    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: effectiveColor,
      elevation: 4.0,
      child: IconTheme.merge(
        data: theme.iconTheme.copyWith(color: Colors.white),
        child: IconButton(
          onPressed: onTap,
          icon: icon,
        ),
      ),
    );
  }
}

class _AnimatedFab extends StatelessWidget {
  const _AnimatedFab({
    Key? key,
    required this.expandedStyle,
    required this.shrinkStyle,
    required this.isOpened,
    this.onTap,
  }) : super(key: key);

  final ExpandableFabStyle expandedStyle;
  final ExpandableFabStyle shrinkStyle;
  final bool isOpened;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: _expandedDuration,
      transformAlignment: Alignment.center,
      transform: Matrix4.diagonal3Values(
        isOpened ? .7 : 1,
        isOpened ? .7 : 1,
        1,
      ),
      child: FloatingActionButton(
        onPressed: onTap,
        backgroundColor: isOpened ? shrinkStyle.color : expandedStyle.color,
        child: isOpened ? shrinkStyle.icon : expandedStyle.icon,
      ),
    );
  }
}

class _ExpandableFabItemAnimationBuilder extends StatelessWidget {
  const _ExpandableFabItemAnimationBuilder({
    Key? key,
    required this.directionInDegrees,
    required this.child,
    required this.progress,
    required this.maxDistance,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Widget child;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      child: child,
      builder: (context, child) {
        final position = Offset.fromDirection(
          directionInDegrees * math.pi / 180,
          maxDistance,
        );

        return Positioned(
          right: position.dx * progress.value,
          bottom: position.dy * progress.value,
          child: Transform.rotate(
            // angle take radians values. In this case I want 45º of rotation,
            // so I applied 3.14 / 2 = 45º.
            angle: (1 - progress.value) * math.pi / 2,
            child: FadeTransition(
              opacity: progress,
              child: child!,
            ),
          ),
        );
      },
    );
  }
}
