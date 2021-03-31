import 'dart:io';
import 'package:flutter_sqlite/models/contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const _databaseName = 'contact.db';
  static const _databaseVersion = 1;

  //name constructor - singleton class
  DatabaseHelper._();

  //single instance on the class
  static final DatabaseHelper instance = DatabaseHelper._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  //initialize database
  _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String dbPath = join(directory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int version) async {
    String sql = ''' 
    CREATE TABLE ${Contact.tblContact}(
    ${Contact.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
    ${Contact.colName} TEXT NOT NULL,
    ${Contact.colMobile} TEXT NOT NULL,
    ${Contact.colEmail} TEXT)    
    ''';
    await db.execute(sql);
  }

  Future<int> insertContact(Contact contact) async {
    Database db = await database;
    return await db.insert(Contact.tblContact, contact.toMap());
  }

  Future<int> updateContact(Contact contact) async {
    Database db = await database;
    return await db.update(Contact.tblContact, contact.toMap(),
        where: "${Contact.colId} =?", whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    Database db = await database;
    return await db.delete(Contact.tblContact, where: "${Contact.colId} =?", whereArgs: [id]);
  }

  Future<List<Contact>> getContacts() async {
    Database db = await database;
    List<Map> contacts = await db.query(Contact.tblContact);

    return contacts.length == 0
        ? []
        : contacts.map((e) => Contact.fromMap(e)).toList();
  }
}
