// customer_model.g.dart
part of 'customer_model.dart';

class CustomerModelAdapter extends TypeAdapter<CustomerModel> {
  @override
  final int typeId = 1;

  @override
  CustomerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomerModel(
      id: fields[0] as String,
      name: fields[1] as String,
      gstin: fields[2] as String? ?? '',
      address: fields[3] as String,
      city: fields[4] as String? ?? '',
      state: fields[5] as String,
      pincode: fields[6] as String? ?? '',
      phone: fields[7] as String,
      email: fields[8] as String? ?? '',
      createdAt: fields[9] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CustomerModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.gstin)
      ..writeByte(3)
      ..write(obj.address)
      ..writeByte(4)
      ..write(obj.city)
      ..writeByte(5)
      ..write(obj.state)
      ..writeByte(6)
      ..write(obj.pincode)
      ..writeByte(7)
      ..write(obj.phone)
      ..writeByte(8)
      ..write(obj.email)
      ..writeByte(9)
      ..write(obj.createdAt);
  }
}
