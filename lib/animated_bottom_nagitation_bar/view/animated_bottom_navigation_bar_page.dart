import 'package:flutter/material.dart';

const _lightBottomNavigationTheme = BottomNavigationBarThemeData(
  backgroundColor: Color(0xffFCF5FF),
  selectedItemColor: Colors.white,
  unselectedItemColor: Color(0xff7C399F),
  selectedLabelStyle: TextStyle(
    fontWeight: FontWeight.bold,
    color: Color(0xff7C399F),
  ),
  unselectedLabelStyle: TextStyle(
    color: Color(0xff7C399F),
  ),
);

const _darkBottomNavigationTheme = BottomNavigationBarThemeData(
  backgroundColor: Color(0xff141218),
  selectedItemColor: Color(0xff141218),
  unselectedItemColor: Color(0xffC0BCC3),
  selectedLabelStyle: TextStyle(
    fontWeight: FontWeight.bold,
    color: Color(0xff7C399F),
  ),
  unselectedLabelStyle: TextStyle(
    color: Color(0xffC0BCC3),
  ),
);

class AnimatedBottomNavigationBarPage extends StatefulWidget {
  const AnimatedBottomNavigationBarPage({super.key});

  @override
  State<AnimatedBottomNavigationBarPage> createState() =>
      _AnimatedBottomNavigationBarPageState();
}

class _AnimatedBottomNavigationBarPageState
    extends State<AnimatedBottomNavigationBarPage> {
  var _selectedIndex = 0;
  var _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode
          ? ThemeData.dark().copyWith(
              bottomNavigationBarTheme: _darkBottomNavigationTheme,
            )
          : ThemeData.light().copyWith(
              bottomNavigationBarTheme: _lightBottomNavigationTheme,
            ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Animated Bottom Navigation Bar'),
        ),
        body: SwitchListTile(
          title: const Text('Dark mode'),
          value: _isDarkMode,
          onChanged: _updateIsDarkMode,
        ),
        bottomNavigationBar: AnimatedBottomNavigationBar(
          selectedIndex: _selectedIndex,
          onIndexChanged: (value) {
            setState(() {
              _selectedIndex = value;
            });
          },
          items: const [
            AnimatedBottomBarItem(
              icon: Icon(Icons.home),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            AnimatedBottomBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(Icons.search),
              label: 'Search',
            ),
            AnimatedBottomBarItem(
              icon: Icon(Icons.person),
              activeIcon: Icon(Icons.person),
              label: 'Profile',
            ),
            AnimatedBottomBarItem(
              icon: Icon(Icons.menu),
              activeIcon: Icon(Icons.menu),
              label: 'Menu',
            ),
            AnimatedBottomBarItem(
              icon: Icon(Icons.disc_full),
              activeIcon: Icon(Icons.disc_full),
              label: 'Disc',
            ),
          ],
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   items: [
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.home),
        //       label: 'Home',
        //       backgroundColor: Colors.red,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.search),
        //       label: 'Search',
        //       backgroundColor: Colors.blue,
        //     ),
        //     BottomNavigationBarItem(
        //       icon: Icon(Icons.person),
        //       label: 'Profile',
        //       backgroundColor: Colors.yellow,
        //     ),
        //   ],
        // ),
      ),
    );
  }

  void _updateIsDarkMode(bool value) {
    setState(() {
      _isDarkMode = value;
    });
  }
}

class AnimatedBottomNavigationBar extends StatefulWidget {
  const AnimatedBottomNavigationBar({
    required this.items,
    required this.selectedIndex,
    required this.onIndexChanged,
    super.key,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.globalCircleColor,
  })  : assert(items.length >= 2 && items.length <= 5),
        assert(selectedIndex >= 0 && selectedIndex < items.length);

  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final List<AnimatedBottomBarItem> items;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final Color? globalCircleColor;

  static const bottomNavigationBarHeight = 88;

  @override
  State<AnimatedBottomNavigationBar> createState() =>
      _AnimatedBottomNavigationBarState();
}

class _AnimatedBottomNavigationBarState
    extends State<AnimatedBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomBarTheme = theme.bottomNavigationBarTheme;
    final bottomPadding = MediaQuery.paddingOf(context).bottom;
    final effectiveGlobalCircleColor = widget.globalCircleColor ??
        bottomBarTheme.selectedLabelStyle?.color ??
        theme.colorScheme.primary;

    return ConstrainedBox(
      constraints: BoxConstraints(
        minHeight: AnimatedBottomNavigationBar.bottomNavigationBarHeight +
            bottomPadding,
      ),
      child: Material(
        color: widget.backgroundColor ?? bottomBarTheme.backgroundColor,
        elevation: 20,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                  widget.items.length,
                  (index) {
                    final item = widget.items[index];
                    final isSelected = widget.selectedIndex == index;
                    final selectedCircleColor =
                        item.selectedCircleColor ?? effectiveGlobalCircleColor;

                    return Expanded(
                      child: TweenAnimationBuilder<double>(
                        tween: Tween(end: isSelected ? 1 : 0),
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, child) {
                          return Transform.translate(
                            offset: Offset(
                                0, -20 * Curves.bounceOut.transform(value)),
                            child: SizedBox.square(
                              dimension: 50,
                              child: CustomPaint(
                                painter: CircleBackgroundPainter(
                                  progress: Curves.decelerate.transform(value),
                                  color: selectedCircleColor,
                                  radius: 25,
                                ),
                                child: IconTheme(
                                  data: isSelected
                                      ? theme.iconTheme.copyWith(
                                          color: widget.selectedItemColor ??
                                              bottomBarTheme.selectedItemColor,
                                        )
                                      : theme.iconTheme.copyWith(
                                          color: widget.unselectedItemColor ??
                                              bottomBarTheme
                                                  .unselectedItemColor,
                                        ),
                                  child: InkResponse(
                                    onTap: isSelected
                                        ? null
                                        : () => widget.onIndexChanged(index),
                                    child: item.icon,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              Row(
                children: List.generate(
                  widget.items.length,
                  (index) {
                    final item = widget.items[index];
                    if (widget.selectedIndex == index) {
                      return Expanded(
                        child: Text(
                          item.label,
                          textAlign: TextAlign.center,
                          style: bottomBarTheme.selectedLabelStyle,
                        ),
                      );
                    } else {
                      return Expanded(
                        child: Text(
                          item.label,
                          textAlign: TextAlign.center,
                          style: bottomBarTheme.unselectedLabelStyle,
                        ),
                      );
                    }
                  },
                ),
              ),
              //SizedBox(height: 8,)
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedBottomBarItem {
  final Widget icon;
  final Widget activeIcon;
  final String label;
  final Color? selectedCircleColor;

  const AnimatedBottomBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.selectedCircleColor,
  });
}

class CircleBackgroundPainter extends CustomPainter {
  final double progress;
  final Color color;
  final double radius;

  CircleBackgroundPainter({
    super.repaint,
    required this.progress,
    required this.color,
    required this.radius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(center, radius * progress, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
