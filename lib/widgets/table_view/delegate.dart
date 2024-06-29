import 'package:flutter/material.dart';

typedef RefreshInTable = Widget? Function(ListView listView);
typedef MarginInSection = EdgeInsets? Function(
  int section,
);
typedef DecorationInSection = BoxDecoration? Function(
  BuildContext context,
  int section,
);

class TableViewDelegate {
  RefreshInTable? refreshInTable;
  MarginInSection? marginInSection;
  DecorationInSection? decorationInSection;

  TableViewDelegate({
    this.refreshInTable,
    this.marginInSection,
    this.decorationInSection,
  });
}
