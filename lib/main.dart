import 'package:diary_flutter/data/database.dart';
import 'package:diary_flutter/write.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

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
  Diary? historyDiary;
  List<Diary> allDiaries = [];

  List<String> statusImg = [
    'assets/img/ico-weather.png',
    'assets/img/ico-weather_2.png',
    'assets/img/ico-weather_3.png',
  ];

  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  CalendarFormat _calendarFormat = CalendarFormat.month;

  void getTodayDiary() async {
    List<Diary> diary = await dbHelper.getDiaryByDate(Utils.getFormatTime(DateTime.now()));
    if (diary.isNotEmpty) {
      todayDiary = diary.first;
    }

    setState(() {});
  }

  void getAllDiary() async {
    allDiaries = await dbHelper.getAllDiary();
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
          if (selectIndex == 0) {
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
          } else {
            Diary _d;

            if (historyDiary != null) {
              _d = historyDiary!;
            } else {
              _d = Diary(
                title: '',
                memo: '',
                image: 'assets/img/b1.jpg',
                date: Utils.getFormatTime(_selectedDay),
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

            getDiaryByDate(_selectedDay);
          }
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
        currentIndex: selectIndex,
        onTap: (idx) {
          setState(() {
            selectIndex = idx;
          });
          if (selectIndex == 2) {
            getAllDiary();
          }
        },
      ),
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
      return const Center(
        child: Text(
          '일기 작성 해주세요!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      );
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

  void getDiaryByDate(DateTime date) async {
    List<Diary> d = await dbHelper.getDiaryByDate(Utils.getFormatTime(date));
    setState(() {
      if (d.isEmpty) {
        historyDiary = null;
      } else {
        historyDiary = d.first;
      }
    });
  }

  Widget getHistoryPage() {
    return ListView.builder(
      itemCount: 2,
      itemBuilder: (ctx, idx) {
        if (idx == 0) {
          return TableCalendar(
            // https://dipeshgoswami.medium.com/table-calendar-3-0-0-null-safety-818ba8d4c45e
            // reference: Flutter table_calendar >= 3.0.0
            firstDay: DateTime(2021, 1, 1),
            lastDay: DateTime(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              }
              // _selectedDay = selectedDay;
              getDiaryByDate(selectedDay);
            },
          );
        } else if (idx == 1) {
          if (historyDiary == null) {
            return Container();
          }
          return SizedBox(
            height: 300,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(historyDiary!.image.toString(), fit: BoxFit.cover),
                ),
                Positioned.fill(
                  child: ListView(
                    children: [
                      Container(
                        // container 로 항상 감쌀 경우 margin, padding option 을 사용할 수 있음, 개발 완료 후 무의미한 container 는 삭제
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${_selectedDay.month}.${_selectedDay.day}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            Image.asset(statusImg[int.parse(historyDiary!.status.toString())], fit: BoxFit.contain),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.white54,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              historyDiary!.title.toString(),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(height: 12),
                            Text(historyDiary!.memo.toString(), style: const TextStyle(fontSize: 18)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }

  Widget getChartPage() {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (BuildContext ctx, int idx) {
        if (idx == 0) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(
                statusImg.length,
                (_idx) {
                  return Column(
                    children: [
                      Image.asset(statusImg[_idx], fit: BoxFit.contain),
                      Text("${allDiaries.where((element) => element.status == _idx).length}개"),
                    ],
                  );
                },
              ),
            ),
          );
        } else if (idx == 1) {
          return SizedBox(
            height: 120,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              children: List.generate(
                allDiaries.length,
                (_idx) {
                  return Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    child: Image.asset(allDiaries[_idx].image!, fit: BoxFit.cover),
                  );
                },
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
