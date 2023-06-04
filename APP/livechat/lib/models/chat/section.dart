
import 'package:isar/isar.dart';

part 'section.g.dart';

@collection
class Section {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String name;

  Section(this.name);

}