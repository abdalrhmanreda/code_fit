import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/vocabulary/logic/vocabulary_cubit.dart';
import 'features/vocabulary/ui/screens/vocabulary_screen.dart';

void main() {
  runApp(const VocabularyApp());
}

class VocabularyApp extends StatelessWidget {
  const VocabularyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vocabulary Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF0F0F14),
        brightness: Brightness.dark,
      ),
      home: BlocProvider(
        create: (context) => VocabularyCubit(),
        child: const VocabularyScreen(),
      ),
    );
  }
}
