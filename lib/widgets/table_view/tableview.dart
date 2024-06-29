import 'package:daily_example/widgets/table_view/datasource.dart';
import 'package:daily_example/widgets/table_view/delegate.dart';
import 'package:daily_example/widgets/table_view/indexpath.dart';
import 'package:flutter/material.dart';

/// 显示可以，定位很难？
class TableView extends StatefulWidget {
  final bool shrinkWrap;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final ScrollPhysics? physics;
  final Color? backgroundColor;
  final TableViewDelegate delegate;
  final TableViewDataSource dataSource;
  final ScrollController? controller;

  const TableView({
    Key? key,
    this.shrinkWrap = false,
    this.padding,
    this.margin,
    this.physics,
    this.controller,
    this.backgroundColor,
    required this.delegate,
    required this.dataSource,
  }) : super(key: key);

  @override
  State<TableView> createState() => _TableViewState();
}

class _TableViewState extends State<TableView> {
  TableViewDelegate get delegate => widget.delegate;
  TableViewDataSource get dataSource => widget.dataSource;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      debugPrint("来了 addPostFrameCallback");
    });
  }

  @override
  void didUpdateWidget(covariant TableView oldWidget) {
    super.didUpdateWidget(oldWidget);

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      debugPrint("来了 addPostFrameCallback");
    });
  }

  @override
  Widget build(BuildContext context) {
    ListView listView = _buildListView();

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: widget.backgroundColor,
          margin: widget.margin,
          child: delegate.refreshInTable?.call(listView) ?? listView,
        );
      },
    );
  }

  /// 构建列表
  ListView _buildListView() {
    return ListView.builder(
      padding: widget.padding,
      physics: widget.physics,
      shrinkWrap: widget.shrinkWrap,
      controller: widget.controller,
      itemCount: dataSource.numberOfSectionsInTableView(),
      itemBuilder: _buildSection,
    );
  }

  /// 构建section
  Widget _buildSection(BuildContext context, int section) {
    int numberOfRowsInSection =
        dataSource.numberOfRowsInSection?.call(section) ?? 0;
    if (numberOfRowsInSection == 0) return const SizedBox.shrink();

    Decoration? decoration =
        delegate.decorationInSection?.call(context, section);

    return Column(
      children: [
        dataSource.headerInSection?.call(context, section) ??
            const SizedBox.shrink(),
        Container(
          clipBehavior: decoration == null ? Clip.none : Clip.hardEdge,
          margin: delegate.marginInSection?.call(section),
          decoration: decoration,
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              IndexPath indexPath = IndexPath(section: section, row: index);
              return dataSource.cellForRowAtIndexPath.call(context, indexPath);
            },
            separatorBuilder: (context, index) {
              IndexPath indexPath = IndexPath(section: section, row: index);
              return dataSource.dividerInTableView?.call(context, indexPath) ??
                  const SizedBox.shrink();
            },
            itemCount: numberOfRowsInSection,
          ),
        ),
        dataSource.footerInSection?.call(context, section) ??
            const SizedBox.shrink(),
      ],
    );
  }
}
