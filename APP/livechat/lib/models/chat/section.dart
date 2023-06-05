
import 'package:isar/isar.dart';

import '../auth/auth_user.dart';

part 'section.g.dart';

@collection
class Section {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  String name;

  final authUser = IsarLink<AuthUser>();

  Section(this.name);

}