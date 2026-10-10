import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Goro's poses on the About screen, just for fun: the designer's idle and
/// the poses of tools/characters/gen_goro.py.
const kGoroPoses = [
  'assets/goro/goro_idle_v2.svg',
  'assets/goro/goro_pose_one_arm_handstand.svg',
  'assets/goro/goro_pose_flag.svg',
  'assets/goro/goro_pose_one_arm_pullup.svg',
  'assets/goro/goro_pose_barbell.svg',
  'assets/goro/goro_pose_lotus.svg',
  'assets/goro/goro_pose_banana.svg',
];

/// Goro in one of [kGoroPoses], a random one each time the screen opens; a
/// tap shows the next. The order is shuffled once, so every pose comes up
/// before any repeats.
class GoroPoses extends StatefulWidget {
  const GoroPoses({super.key, this.height = 120, this.random});

  final double height;

  /// For tests; a new [Random] by default.
  final Random? random;

  @override
  State<GoroPoses> createState() => _GoroPosesState();
}

class _GoroPosesState extends State<GoroPoses> {
  late final List<String> _order =
      List.of(kGoroPoses)..shuffle(widget.random ?? Random());
  int _index = 0;

  void _next() {
    HapticFeedback.selectionClick();
    setState(() => _index = (_index + 1) % _order.length);
  }

  @override
  Widget build(BuildContext context) {
    final asset = _order[_index];
    return GestureDetector(
      onTap: _next,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: Tween(begin: 0.85, end: 1.0).animate(
              CurvedAnimation(parent: animation, curve: Curves.easeOutBack)),
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: SvgPicture.asset(
          asset,
          key: ValueKey(asset),
          height: widget.height,
        ),
      ),
    );
  }
}
