
import 'package:isar/isar.dart';
import 'package:pedometer/pedometer.dart';

part 'steps.g.dart';

@collection
class Steps {
  Id id = Isar.autoIncrement;
  int? steps;
  int? offset;
  DateTime? timeStamp;

  int? userId;

  void updateSteps(StepCount event, bool isSameDay) {
    if (offset == null || !isSameDay) {
      steps = 0;
      offset = event.steps;
    } else {
      steps = event.steps - offset!;
    }
    timeStamp = event.timeStamp;
  }

  Steps({required this.userId, this.offset});
}