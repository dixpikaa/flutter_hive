
import 'package:hive/hive.dart';
import 'package:todo/model.dart';

class Boxes {
  static Box<Data> getTodo()=> Hive.box<Data>('data_box');}