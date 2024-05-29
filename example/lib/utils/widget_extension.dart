import 'package:flutter/widgets.dart';

extension WidgetExtension on Widget {
  Widget get toSliver => SliverToBoxAdapter(
        child: this,
      );
}

extension IterableWidgetExtension on Iterable<Widget> {
  Iterable<Widget> get toSlivers => map((e) => e.toSliver);
}
