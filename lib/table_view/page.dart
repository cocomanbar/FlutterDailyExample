import 'package:daily_example/widgets/table_view/datasource.dart';
import 'package:daily_example/widgets/table_view/delegate.dart';
import 'package:daily_example/widgets/table_view/indexpath.dart';
import 'package:daily_example/widgets/table_view/tableview.dart';
import 'package:flutter/material.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class TableViewDemo extends StatefulWidget {
  const TableViewDemo({super.key});

  @override
  State<TableViewDemo> createState() => _TableViewDemoState();
}

class _TableViewDemoState extends State<TableViewDemo> {
  late AutoScrollController scrollController = AutoScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(),
    //   body: ListView.builder(
    //     padding: EdgeInsets.zero,
    //     controller: scrollController,
    //     itemBuilder: (context, index) {
    //       return AutoScrollTag(
    //         key: ValueKey(index),
    //         controller: scrollController,
    //         index: index,
    //         child: Container(
    //           color: Colors.amber,
    //           child: Text("$index"),
    //           height: 50,
    //         ),
    //       );
    //     },
    //     itemCount: 50,
    //   ),
    //   floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       scrollController
    //           .scrollToIndex(25, preferPosition: AutoScrollPosition.middle);
    //     },
    //     child: const Icon(Icons.refresh),
    //   ),
    // );

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 50, right: 50),
        child: TableView(
          controller: scrollController,
          delegate: TableViewDelegate(
            marginInSection: (section) {
              return const EdgeInsets.only(left: 20, right: 20);
            },
            decorationInSection: (context, section) {
              return const BoxDecoration(
                color: Colors.black12,
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.black12],
                ),
              );
            },
          ),
          dataSource: TableViewDataSource(
            numberOfSectionsInTableView: () => 100,
            numberOfRowsInSection: (section) => (section + 1),
            cellForRowAtIndexPath: (context, indexPath) {
              debugPrint("来了 111");
              return AutoScrollTag(
                key: ValueKey(indexPath),
                index: indexPath.hashCode,
                controller: scrollController,
                child: Container(
                  height: 60,
                  child: Text("sec=${indexPath.section}, row=${indexPath.row}"),
                ),
              );
            },
            dividerInTableView: (context, indexPath) {
              return Container(
                height: 0,
                child: Text("sec=${indexPath.section}, row=${indexPath.row}"),
              );
            },
            headerInSection: (context, section) {
              return Container(
                color: Colors.pink,
                height: 20,
              );
            },
            footerInSection: (context, section) {
              return Container(
                color: Colors.purple,
                height: 20,
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          scrollController
              .scrollToIndex(IndexPath(section: 2, row: 1).hashCode);
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
