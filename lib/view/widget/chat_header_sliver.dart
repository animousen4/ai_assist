import 'package:flutter/material.dart';

class ChatHeaderSliverDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final double collapsedHeight;

  ChatHeaderSliverDelegate(
      {required this.expandedHeight, this.collapsedHeight = kToolbarHeight});
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return AppBar(
      surfaceTintColor: Colors.transparent,
      flexibleSpace: Center(
          child: Text(
        "Chat",
        style: Theme.of(context).textTheme.bodyLarge,
      )),
      //backgroundColor: Colors.grey.shade900,
    );
  }

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => collapsedHeight;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate != this;
  }
}
