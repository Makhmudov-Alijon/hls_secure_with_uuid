import 'package:isar/isar.dart';

mixin Crud<T> {
  Future<Id> create(T v);

  Future<T> delete(T v);

  Future<T> update(T v);

  Future<T?> getById(Id v);
}
