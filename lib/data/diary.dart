class Diary {
  String title;
  String memo;
  String category;
  int color;
  int done;
  int date;
  int? id;

  // 생성자
  Diary({
    required this.title,
    required this.memo,
    required this.category,
    required this.color,
    required this.done,
    required this.date,
    this.id,
  });
}
