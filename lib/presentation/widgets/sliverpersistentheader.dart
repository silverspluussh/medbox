import 'package:flutter/material.dart';

class HeaderBar extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final double maxextent;
  final double minextent;
  HeaderBar(
      {required this.widget, required this.maxextent, required this.minextent});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return widget;
  }

  @override
  double get maxExtent => maxextent;

  @override
  double get minExtent => minextent;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}
