import 'package:flutter/material.dart';

class HeaderBar extends SliverPersistentHeaderDelegate {
  final Widget widget;
  final double maxextent;
  final double minextent;
  HeaderBar(this.widget, this.maxextent, this.minextent);

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
