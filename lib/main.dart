import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>(
  (ref) => 0,
);

void main() {
  runApp(
    ProviderScope(
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scope&Lifecyles'),
      ),
      body: Column(
        children: [
          CounterWidget(),
          ProviderScope(
            overrides: [
              counterProvider,
            ],
            child: Column(
              children: [
                CounterWidget(),
              ],
            ),
          ),
          ProviderScope(
            overrides: [
              counterProvider.overrideWith((ref) => 10),
            ],
            child: Column(
              children: [
                CounterWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CounterWidget extends ConsumerWidget {
  const CounterWidget({super.key});

  @override
  Widget build(BuildContext context, ref) {
    final count = ref.watch(counterProvider);
    return Column(
      children: [
        Text('$count'),
        ElevatedButton(
          onPressed: () {
            ref.read(counterProvider.notifier).update((state) => state += 1);
          },
          child: Text(
            '카운트 증가',
          ),
        ),
      ],
    );
  }
}
