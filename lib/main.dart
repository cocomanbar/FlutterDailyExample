import 'package:daily_example/core/item.dart';
import 'package:daily_example/timer_center/page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: <String, WidgetBuilder>{
        Path.timerPage: (context) => const TimerCenterPage(),
      },
      home: const MyHomePage(title: 'Flutter Daily Examples'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<Item> list = [];

  @override
  void initState() {
    super.initState();

    list.add(
      Item(
        title: "定时管理中心",
        detailText: "基于任务插拔式开启和关闭定时，归类相同频率的定时任务，减少定时开销",
        path: Path.timerPage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      extendBodyBehindAppBar: false,
      body: ListView.separated(
        padding: EdgeInsets.fromLTRB(
            16, 0, 16, MediaQuery.of(context).padding.bottom),
        itemBuilder: (context, index) {
          Item item = list[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(item.path);
            },
            child: MyHomeItemWidget(item: item),
          );
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 2);
        },
        itemCount: list.length,
      ),
    );
  }
}

class MyHomeItemWidget extends StatelessWidget {
  final Item item;
  const MyHomeItemWidget({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: const BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.all(Radius.circular(8)),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 18,
                    height: 1.0,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.detailText,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.3,
                    color: Colors.black38,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
