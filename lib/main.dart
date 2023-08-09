import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:simple_visit_counter/model/bdd/user.dart';

void main() {
  runApp(const MyApp());
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int? _visitorsCount;

  @override
  void initState() {
    super.initState();
    _computeVisitor().then((_) => ());
  }

  Future<void> _computeVisitor() async {
    var path = "/assets/db";
    if (!kIsWeb) {
      var appDocDir = await getApplicationDocumentsDirectory();
      path = appDocDir.path;
    }

    final isar = await Isar.open(
      [UserSchema],
      directory: path,
    );

    await isar.writeTxn(() async {
      await isar.users.put(User());
    });

    final count = await isar.users.count();
    setState(() {
      _visitorsCount = count;
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
