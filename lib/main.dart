import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>(
  (ref) => 0,
);

extension CacheForExtension on AutoDisposeRef<Object?> {
  void cacheFor(Duration duration) {
    final link = keepAlive();
    final timer = Timer(duration, link.close);
    onDispose(timer.cancel);
  }
}

final lifecycleProvider = StateProvider.autoDispose((ref) {
  ref.cacheFor(Duration(seconds: 5));
  // Timer? timer;
  // final link = ref.keepAlive();
  ref.onAddListener(() {
    print('[lifecycleProvider] onAddListener()');
  });

  ref.onRemoveListener(() {
    print('[lifecycleProvider] onRemoveListener()');
  });

  ref.onResume(() {
    print('[lifecycleProvider] onResume()');
    // timer?.cancel();
  });

  ref.onCancel(() {
    print('[lifecycleProvider] onCancel()');
    // timer = Timer(Duration(seconds: 5), () {
    //   link.close();
    // });
  });

  ref.onDispose(() {
    print('[lifecycleProvider] onDispose()');
    // timer?.cancel();
    // timer = null;
  });

  // ref.keepAlive();

  return 0;
});

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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return SecondPage();
                    },
                  ),
                );
              },
              child: Text(
                '2번째 페이지로 이동',
              ),
            ),
            Divider(),
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
      ),
    );
  }
}

class SecondPage extends ConsumerWidget {
  const SecondPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counter = ref.watch(lifecycleProvider);
    // ref.listen(
    //   lifecycleProvider,
    //   (previous, next) {
    //     print('$previous $next');
    //   },
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Page'),
      ),
      body: Column(
        children: [
          Text('Count: $counter'),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(lifecycleProvider.notifier)
                  .update((state) => state += 1);
            },
            child: Text('카운트 증가'),
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
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
      ),
    );
  }
}
