import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:livechat/models/auth/auth_user.dart';
import 'package:path_provider/path_provider.dart';

import '../models/chat/chat.dart';
import '../models/chat/section.dart';
import '../models/settings.dart';
import '../models/steps.dart';

class IsarService {
  // SINGLETON
  static IsarService? _instance;
  static IsarService get instance {
    _instance ??= IsarService();
    return _instance!;
  }

  late Future<Isar> db;
  IsarService() {
    db = _openIsar();
  }

  Future<Isar> _openIsar() async {
    if (Isar.getInstance() == null) {
      final dir = await getApplicationDocumentsDirectory();

      return await Isar.open(
        [
          ChatSchema,
          SectionSchema,
          AuthUserSchema,
          SettingsSchema,
          StepsSchema
        ],
        inspector: !kReleaseMode,
        directory: dir.path,
      );
    }

    return Future.value(Isar.getInstance());
  }

  // GENERICS

  Future<List<T>> getAll<T>(int authUserId) async {
    final isar = await db;
    return await isar
        .collection<T>()
        .buildQuery<T>(
          filter: FilterCondition.equalTo(
            property: r'userId',
            value: authUserId,
          ),
        )
        .findAll();
  }

  Future<T?> getSingle<T>(int authUserId) async {
    List<T> list = await getAll<T>(authUserId);
    return list.isNotEmpty ? list.first : null;
  }

  Future<void> saveAll<T>(List<T> data) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<T>().putAll(data);
    });
  }

  Future<void> insertOrUpdate<T>(T data) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<T>().put(data);
    });
  }

  Future<void> delete<T>(int id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.collection<T>().delete(id);
    });
  }

  // AUTHUSER
  Future<AuthUser?> getLoggedUser() async {
    final isar = await db;
    return await isar.authUsers.filter().isLoggedEqualTo(true).findFirst();
  }

  // SETTINGS
  Future<Settings?> getSettings() async {
    final isar = await db;
    return await isar.settings.buildQuery().findFirst();
  }

  Future<void> cleanDb() async {
    final isar = await db;
    await isar.writeTxn(() => isar.clear());
  }
}
