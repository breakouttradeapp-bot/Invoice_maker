import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 2)
class ProductModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String hsnSac;

  @HiveField(3)
  double gstRate;

  @HiveField(4)
  double price;

  @HiveField(5)
  String unit;

  @HiveField(6)
  String description;

  @HiveField(7)
  bool trackStock;

  @HiveField(8)
  double stockQuantity;

  ProductModel({
    required this.id,
    required this.name,
    this.hsnSac = '',
    required this.gstRate,
    required this.price,
    this.unit = 'Nos',
    this.description = '',
    this.trackStock = false,
    this.stockQuantity = 0,
  });
}
