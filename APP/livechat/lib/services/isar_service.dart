import 'package:isar/isar.dart';
import 'package:livechat/models/auth/auth_user.dart';
import 'package:path_provider/path_provider.dart';

import '../models/chat/chat.dart';
import '../models/chat/section.dart';
import '../models/friend.dart';

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
          [FriendSchema, ChatSchema, SectionSchema, AuthUserSchema],
          inspector: true, directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }

  Future<List<T>> getAll<T>() async {
    final isar = await db;
    return await isar
        .collection<T>()
        .buildQuery<T>(
          filter: const LinkFilter(
            filter: FilterCondition.equalTo(
              property: r'isLogged',
              value: true,
            ),
            linkName: r'authUser',
          ),
        )
        .findAll();
  }

  void saveAll<T>(List<T> data) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<T>().putAll(data);
    });
  }

  void save<T>(T data) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<T>().put(data);
    });
  }

  void insertOrUpdate<T>(T data) async {
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

  Future<AuthUser?> getLoggedUser() async {
    final isar = await db;
    return await isar.authUsers.filter().isLoggedEqualTo(true).findFirst();
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }
}
