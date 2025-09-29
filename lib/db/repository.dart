import 'app_db.dart';
import '../models/user.dart';

class Repo {
  Repo._();
  static final Repo instance = Repo._();

  final dbProvider = AppDatabase.instance;

  Future<User?> login(String username, String password) async {
    final db = await dbProvider.database;
    final res = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (res.isNotEmpty) {
      return User.fromMap(res.first);
    }
    return null;
  }
}
