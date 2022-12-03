import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Timer? timer;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            child: const Text('Await'),
            onPressed: () async {
              timer =
                  Timer.periodic(const Duration(milliseconds: 1000), (timer) {
                print(timer.tick);
              });

              await compute(hugeTaskWithCompute, 1000000000);
              timer?.cancel();
              print('Here is Await');
            },
          ),
          ElevatedButton(
            child: const Text('Compute'),
            onPressed: () async {
              timer =
                  Timer.periodic(const Duration(milliseconds: 1000), (timer) {
                print(timer.tick);
              });

              compute(hugeTaskWithCompute, 1000000000)
                  .then((value) => timer?.cancel());
              print('Here is Compute');
            },
          ),
          ElevatedButton(
            child: const Text('Spawn'),
            onPressed: () async {
              timer =
                  Timer.periodic(const Duration(milliseconds: 1000), (timer) {
                print(timer.tick);
              });
              final receivePort = ReceivePort();
              Isolate.spawn(hugeTaskWithSpawn, receivePort.sendPort);
              receivePort.listen((sum) {
                timer?.cancel();
              });
              print('Here is Spawn');
            },
          )
        ],
      ),
    );
  }
}

int hugeTaskWithCompute(int value) {
  var sum = 0;
  for (var i = 0; i <= value; i++) {
    sum += i;
  }
  print('calculation finished');
  return sum;
}

void hugeTaskWithSpawn(SendPort sendPort) {
  print('calculation started');
  var sum = 0;
  for (var i = 0; i <= 1000000000; i++) {
    sum += i;
  }
  print('calculation finished');
  sendPort.send(sum);
}
