import 'package:hive/hive.dart';

part 'customer_model.g.dart';

@HiveType(typeId: 1)
class CustomerModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  String gstin;

  @HiveField(3)
  String address;

  @HiveField(4)
  String city;

  @HiveField(5)
  String state;

  @HiveField(6)
  String pincode;

  @HiveField(7)
  String phone;

  @HiveField(8)
  String email;

  @HiveField(9)
  DateTime createdAt;

  CustomerModel({
    required this.id,
    required this.name,
    this.gstin = '',
    required this.address,
    this.city = '',
    required this.state,
    this.pincode = '',
    required this.phone,
    this.email = '',
    required this.createdAt,
  });
}
