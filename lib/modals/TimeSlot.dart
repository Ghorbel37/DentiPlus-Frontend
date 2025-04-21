class TimeSlot {
  final DateTime startTime;

  TimeSlot({required this.startTime});

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
    startTime: DateTime.parse(json['start_time']),
  );
}