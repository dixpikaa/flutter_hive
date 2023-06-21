import 'package:hive/hive.dart';
part 'model.g.dart';


@HiveType(typeId: 1)
class Data extends HiveObject {
  @HiveField(0)
  late String title;
  
  @HiveField(1)
  late String description;
}