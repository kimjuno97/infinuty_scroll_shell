import 'package:flutter/material.dart';
import 'package:infinity_scroll_shell/infinity_scroll_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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
  bool _isLoading = false;

  final List<String> _list = List.generate(
    50,
    (index) => "$index",
  ).toList();

  Future<void> _maxScrollExtentObserverFn() async {
    if (_isLoading) return;
    _isLoading = true;
    setState(() {});
    final addList =
        List.generate(10, (index) => "${_list.length + index}").toList();
    _list.addAll(addList);
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 100));
    _isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: InfinityScrollShell(
        maxScrollExtentObserverFn: _maxScrollExtentObserverFn,
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _list.length,
          itemBuilder: (context, index) {
            final text = _list[index];
            return Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                text,
                style: const TextStyle(fontSize: 20),
              ),
            );
          },
        ),
      ),
    );
  }
}
