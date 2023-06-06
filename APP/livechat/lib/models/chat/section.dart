
import 'package:isar/isar.dart';

part 'section.g.dart';

@collection
class Section {
  Id id = Isar.autoIncrement;

  String name;

  int? userId;

  Section(this.name);

}