// product_model.g.dart
part of 'product_model.dart';

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 2;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String,
      name: fields[1] as String,
      hsnSac: fields[2] as String? ?? '',
      gstRate: fields[3] as double,
      price: fields[4] as double,
      unit: fields[5] as String? ?? 'Nos',
      description: fields[6] as String? ?? '',
      trackStock: fields[7] as bool? ?? false,
      stockQuantity: fields[8] as double? ?? 0,
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.hsnSac)
      ..writeByte(3)
      ..write(obj.gstRate)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.unit)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.trackStock)
      ..writeByte(8)
      ..write(obj.stockQuantity);
  }
}
