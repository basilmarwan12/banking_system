import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Database? _db;

  Future<void> initSqlite() async {
    _db = await openDatabase(
        onCreate: _onCreate,
        version: 1,
        join(
          await getDatabasesPath(),
          "banking_system4.db",
        ));
  }

  _onCreate(Database db, int x) async {
    final List<Map<String, dynamic>> onCreateData = [
      {"firstName": "First", "lastName": " User", "balance": 3000},
      {"firstName": "Second", "lastName": "User", "balance": 2500},
      {"firstName": "Third", "lastName": "User", "balance": 9000},
      {"firstName": "Fourth", "lastName": "User", "balance": 1000},
      {"firstName": "Fifth", "lastName": "User", "balance": 10000}
    ];
    await db.execute('CREATE TABLE "Users" ('
        'userId INTEGER PRIMARY KEY AUTOINCREMENT, '
        'firstName TEXT NOT NULL, '
        'lastName TEXT NOT NULL, '
        'balance REAL'
        ')');

    await db.execute('CREATE TABLE "Transactions" ('
        'transactionId INTEGER PRIMARY KEY AUTOINCREMENT, '
        'senderId INTEGER NOT NULL, '
        'receiverId INTEGER NOT NULL, '
        'senderName TEXT NOT NULL, '
        'receiverName TEXT NOT NULL, '
        'balance REAL NOT NULL, '
        'transactionTime TEXT NOT NULL, '
        'FOREIGN KEY (senderId) REFERENCES Users (userId), '
        'FOREIGN KEY (receiverId) REFERENCES Users (userId)'
        ')');

    for (dynamic eachUser in onCreateData) {
      await db.insert("Users", eachUser);
    }
  }

  Future<void> insertOne() async {
    await _db!.rawInsert(
        'INSERT INTO Users(userId , firstName , lastName , balance) Values(23,"Test","User",9000)');
  }

  Future<dynamic> getUsers() async {
    final List<Map<String, dynamic>> fetchedUsers =
        await _db!.rawQuery("SELECT * FROM Users WHERE userId != ?", [23]);

    return fetchedUsers;
  }

  Future<void> clearTable() async {
    await _db!.rawDelete("DELETE FROM Transactions");
  }

  Future<void> addTransaction(int senderId, int receiverId, String senderName,
      String receiverName, double balance, String transactionTime) async {
    await _db!.rawInsert(
        'INSERT INTO Transactions(senderId,receiverId ,senderName, receiverName, balance, transactionTime) VALUES($senderId, $receiverId ,"$senderName", "$receiverName", $balance, "$transactionTime")');
  }

  Future<dynamic> getTransactions(int userId) async {
    try {
      return await _db!.rawQuery('''
        SELECT * 
        FROM Transactions
        where Transactions.senderId = ?
        ''', [userId]);
    } catch (e) {
      return [{}];
    }
  }

  Future<void> updateUsersBalance(int userId, double newBalance) async {
    await _db!.update("Users", {"balance": newBalance},
        where: 'userId = ?', whereArgs: [userId]);
  }

  Future<double> getNewBalance(int userId) async {
    List<Map<String, dynamic>> newBalance = await _db!
        .rawQuery('SELECT balance FROM users WHERE userId = ?', [userId]);
    return newBalance.first['balance'];
  }
}
