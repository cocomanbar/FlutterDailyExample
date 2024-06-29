import 'package:daily_example/widgets/table_view/indexpath.dart';
import 'package:flutter/material.dart';

typedef NumberOfSectionsInTableView = int Function();
typedef NumberOfRowsInSection = int Function(int section);
typedef DividerInTableView = Widget Function(
  BuildContext context,
  IndexPath indexPath,
);
typedef WidgetAtIndexPath = Widget Function(
  BuildContext context,
  IndexPath indexPath,
);
typedef WidgetInSection = Widget? Function(
  BuildContext context,
  int section,
);

class TableViewDataSource {
  NumberOfSectionsInTableView numberOfSectionsInTableView;
  NumberOfRowsInSection? numberOfRowsInSection;
  WidgetAtIndexPath cellForRowAtIndexPath;
  WidgetInSection? headerInSection;
  WidgetInSection? footerInSection;
  DividerInTableView? dividerInTableView;

  TableViewDataSource({
    required this.numberOfSectionsInTableView,
    required this.cellForRowAtIndexPath,
    this.numberOfRowsInSection,
    this.headerInSection,
    this.footerInSection,
    this.dividerInTableView,
  });
}
