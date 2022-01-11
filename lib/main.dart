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
      body: Container(child: getPage()),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          Diary _d;

          if (todayDiary != null) {
            _d = todayDiary!;
          } else {
            _d = Diary(
              title: '',
              memo: '',
              image: 'assets/img/b1.jpg',
              date: Utils.getFormatTime(DateTime.now()),
              status: 0,
            );
          }

          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext ctx) => DiaryWritePage(
                diary: _d,
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
              Container(
                // container 로 항상 감쌀 경우 margin, padding option 을 사용할 수 있음, 개발 완료 후 무의미한 container 는 삭제
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
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
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      todayDiary!.title.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(height: 12),
                    Text(todayDiary!.memo.toString(), style: const TextStyle(fontSize: 18)),
                  ],
                ),
              ),
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
