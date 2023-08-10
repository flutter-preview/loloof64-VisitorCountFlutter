import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simple_visit_counter/db/database.dart';
import 'package:simple_visit_counter/web.dart';

final databaseProvider = StateProvider((ref) => constructDb());

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple visitor count',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Simple visitor count'),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends ConsumerState<MyHomePage> {
  int? _visitorsCount;

  @override
  void initState() {
    super.initState();
    _addVisitorToDb().then((value) => null);
    _computeVisitor().then((value) => null);
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _addVisitorToDb() async {
    final database = ref.read(databaseProvider.notifier).state;
    await database.into(database.users).insert(UsersCompanion.insert());
  }

  Future<void> _computeVisitor() async {
    final database = ref.read(databaseProvider);
    final visitors = await database.select(database.users).get();
    setState(() {
      _visitorsCount = visitors.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('You are the visitor number'),
            if (_visitorsCount != null) Text("$_visitorsCount"),
          ],
        ),
      ),
    );
  }
}
