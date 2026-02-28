// invoice_item_model.g.dart
part of 'invoice_item_model.dart';

class InvoiceItemModelAdapter extends TypeAdapter<InvoiceItemModel> {
  @override
  final int typeId = 3;

  @override
  InvoiceItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceItemModel(
      productName: fields[0] as String,
      hsnSac: fields[1] as String? ?? '',
      quantity: fields[2] as double,
      unit: fields[3] as String? ?? 'Nos',
      price: fields[4] as double,
      discountPercent: fields[5] as double? ?? 0,
      gstRate: fields[6] as double,
      isInclusive: fields[7] as bool? ?? false,
      taxableAmount: fields[8] as double,
      cgst: fields[9] as double? ?? 0,
      sgst: fields[10] as double? ?? 0,
      igst: fields[11] as double? ?? 0,
      totalAmount: fields[12] as double,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceItemModel obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.hsnSac)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.discountPercent)
      ..writeByte(6)
      ..write(obj.gstRate)
      ..writeByte(7)
      ..write(obj.isInclusive)
      ..writeByte(8)
      ..write(obj.taxableAmount)
      ..writeByte(9)
      ..write(obj.cgst)
      ..writeByte(10)
      ..write(obj.sgst)
      ..writeByte(11)
      ..write(obj.igst)
      ..writeByte(12)
      ..write(obj.totalAmount);
  }
}
