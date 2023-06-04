import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../models/chat/chat.dart';
import '../models/chat/section.dart';
import '../models/user.dart';

class IsarService {
  // Singleton
  static IsarService? _instance;
  static IsarService get instance {
    _instance ??= IsarService();
    return _instance!;
  }

  late Future<Isar> db;
  IsarService() {
    db = openIsar();
  }

  Future<Isar> openIsar() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();

      return await Isar.open(
        [UserSchema, ChatSchema, SectionSchema],
        inspector: true,
        directory: dir.path
      );
    }

    return Future.value(Isar.getInstance());
  }

  Future<List<T>> getAll<T>() async {
    final isar = await db;
    return await isar.collection<T>().where().findAll();
  }

  void insertOrUpdate<T>(T data) async{
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<T>().put(data);
    });
  }

  void delete<T>(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<T>().delete(id);
    });
  }

  void saveAll<T>(List<T> data) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<T>().putAll(data);
    });
  }


  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }

}