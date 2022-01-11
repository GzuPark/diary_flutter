import 'package:flutter/material.dart';

import 'data/diary.dart';

class DiaryWritePage extends StatefulWidget {
  final Diary diary;

  const DiaryWritePage({Key? key, required this.diary}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _DiaryWritePageState();
  }
}

class _DiaryWritePageState extends State<DiaryWritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            child: const Text('저장', style: TextStyle(color: Colors.white)),
            onPressed: () {},
          )
        ],
      ),
    );
  }
}
