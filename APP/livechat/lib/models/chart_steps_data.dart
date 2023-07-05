class ChartStepsData {
  ChartStepsData(this.day, this.steps);
  final int day;
  final int steps;

  ChartStepsData.fromJson(Map<String, dynamic> json)
      : day = json['day'],
        steps = json['steps'];
}
