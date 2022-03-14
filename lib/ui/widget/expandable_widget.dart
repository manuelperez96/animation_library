import 'dart:ui';
import 'package:flutter/material.dart';

class ExpandedWidget extends StatefulWidget {
  const ExpandedWidget({
    Key? key,
    required this.closeIcon,
    required this.openIcon,
    this.isOpen = false,
    this.child,
    this.onChanged,
  }) : super(key: key);

  final Widget closeIcon;
  final Widget openIcon;
  final bool isOpen;
  final Widget? child;
  final ValueChanged<bool>? onChanged;

  @override
  State<ExpandedWidget> createState() => _ExpandedWidgetState();
}

class _ExpandedWidgetState extends State<ExpandedWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant ExpandedWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOpen != widget.isOpen) {
      if (widget.isOpen) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, constraints) => Stack(
        children: <Widget>[
          Positioned(
            height: 48,
            width: lerpDouble(48, constraints.maxWidth, _controller.value),
            top: constraints.maxHeight / 2 - 23,
            child: Container(
              decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(50)),
              child: Row(
                children: <Widget>[
                  IconTheme(
                    data: Theme.of(context).iconTheme.copyWith(
                          color: Colors.white,
                        ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: widget.isOpen
                          ? IconButton(
                              onPressed: _toggleIsOpen,
                              icon: widget.openIcon,
                              padding: EdgeInsets.zero,
                            )
                          : IconButton(
                              onPressed: _toggleIsOpen,
                              icon: widget.closeIcon,
                              padding: EdgeInsets.zero,
                            ),
                    ),
                  ),
                  if (_controller.isCompleted && widget.child != null)
                    Expanded(child: widget.child!)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void _toggleIsOpen() {
    widget.onChanged?.call(!widget.isOpen);
  }
}
