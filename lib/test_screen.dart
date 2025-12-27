import 'package:flutter/material.dart';

class TestScreen extends StatelessWidget {
  TestScreen({super.key});
  final ValueNotifier<int> count = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test Screen')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ValueListenableBuilder<int>(
              valueListenable: count,
              builder: (context, value, child) {
                return Text(value.toString());
              },
            ),
            ElevatedButton(
              onPressed: () {
                count.value++;
              },
              child: const Text('Increment'),
            ),
          ],
        ),
      ),
    );
  }
}
