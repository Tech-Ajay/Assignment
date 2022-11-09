import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class QListBuilder<T> extends StatelessWidget {
  const QListBuilder({
    Key? key,
    required this.pageingController,
    required this.itemBuilder,
    this.padding,
    this.emptyBuilder,
  }) : super(key: key);

  final PagingController<int, T> pageingController;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final EdgeInsetsGeometry? padding;
  final Widget Function(BuildContext)? emptyBuilder;

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, T>(
      padding: padding,
      pagingController: pageingController,
      builderDelegate: PagedChildBuilderDelegate<T>(
        itemBuilder: itemBuilder,
        noItemsFoundIndicatorBuilder: emptyBuilder,
      ),
    );
  }
}
