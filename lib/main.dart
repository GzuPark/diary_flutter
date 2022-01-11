import 'package:diary_flutter/data/database.dart';
import 'package:diary_flutter/write.dart';
import 'package:flutter/material.dart';

import 'data/diary.dart';
import 'data/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final dbHelper = DatabaseHelper.instance;
  int selectIndex = 0;

  Diary? todayDiary;

  List<String> statusImg = [
    'assets/img/ico-weather.png',
    'assets/img/ico-weather_2.png',
    'assets/img/ico-weather_3.png',
  ];

  void getTodayDiary() async {
    List<Diary> diary = await dbHelper.getDiaryByDate(Utils.getFormatTime(DateTime.now()));
    if (diary.isNotEmpty) {
      todayDiary = diary.first;
    }

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getTodayDiary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(child: getPage()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext ctx) => DiaryWritePage(
                diary: Diary(
                  title: '',
                  memo: '',
                  image: 'assets/img/b1.jpg',
                  date: Utils.getFormatTime(DateTime.now()),
                  status: 0,
                ),
              ),
            ),
          );

          getTodayDiary();
        },
        tooltip: '',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.today), label: '오늘'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today_rounded), label: '기록'),
            BottomNavigationBarItem(icon: Icon(Icons.insert_chart), label: '통계'),
          ],
          onTap: (idx) {
            setState(() {
              selectIndex = idx;
            });
          }),
    );
  }

  Widget getPage() {
    if (selectIndex == 0) {
      return getTodayPage();
    } else if (selectIndex == 1) {
      return getHistoryPage();
    } else {
      return getChartPage();
    }
  }

  Widget getTodayPage() {
    if (todayDiary == null) {
      return const Text('일기 작성 해주세요!');
    }
    return Stack(
      // widget 위에 widget 을 표현함으로써 배경 이미지를 적용가능
      children: [
        Positioned.fill(
          child: Image.asset(
            todayDiary!.image.toString(),
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${DateTime.now().month}.${DateTime.now().day}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Image.asset(statusImg[int.parse(todayDiary!.status.toString())], fit: BoxFit.contain),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget getHistoryPage() {
    return Container();
  }

  Widget getChartPage() {
    return Container();
  }
}
