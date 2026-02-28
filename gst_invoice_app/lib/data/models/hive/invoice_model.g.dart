// invoice_model.g.dart
part of 'invoice_model.dart';

class InvoiceModelAdapter extends TypeAdapter<InvoiceModel> {
  @override
  final int typeId = 4;

  @override
  InvoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceModel(
      id: fields[0] as String,
      invoiceNumber: fields[1] as String,
      invoiceDate: fields[2] as DateTime,
      dueDate: fields[3] as DateTime?,
      customerId: fields[4] as String,
      customerName: fields[5] as String,
      customerGstin: fields[6] as String? ?? '',
      customerAddress: fields[7] as String,
      customerState: fields[8] as String,
      customerPhone: fields[9] as String? ?? '',
      customerEmail: fields[10] as String? ?? '',
      sellerState: fields[11] as String,
      isInterState: fields[12] as bool,
      isReverseCharge: fields[13] as bool? ?? false,
      placeOfSupply: fields[14] as String,
      items: (fields[15] as List).cast<InvoiceItemModel>(),
      subTotal: fields[16] as double,
      totalDiscount: fields[17] as double? ?? 0,
      taxableAmount: fields[18] as double,
      cgst: fields[19] as double? ?? 0,
      sgst: fields[20] as double? ?? 0,
      igst: fields[21] as double? ?? 0,
      totalTax: fields[22] as double,
      shippingCharges: fields[23] as double? ?? 0,
      grandTotal: fields[24] as double,
      roundOff: fields[25] as double? ?? 0,
      finalTotal: fields[26] as double,
      paymentStatus: fields[27] as String? ?? 'unpaid',
      amountPaid: fields[28] as double? ?? 0,
      notes: fields[29] as String? ?? '',
      termsAndConditions: fields[30] as String? ?? '',
      templateId: fields[31] as int? ?? 1,
      createdAt: fields[32] as DateTime,
      pdfPath: fields[33] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceModel obj) {
    writer
      ..writeByte(34)
      ..writeByte(0)..write(obj.id)
      ..writeByte(1)..write(obj.invoiceNumber)
      ..writeByte(2)..write(obj.invoiceDate)
      ..writeByte(3)..write(obj.dueDate)
      ..writeByte(4)..write(obj.customerId)
      ..writeByte(5)..write(obj.customerName)
      ..writeByte(6)..write(obj.customerGstin)
      ..writeByte(7)..write(obj.customerAddress)
      ..writeByte(8)..write(obj.customerState)
      ..writeByte(9)..write(obj.customerPhone)
      ..writeByte(10)..write(obj.customerEmail)
      ..writeByte(11)..write(obj.sellerState)
      ..writeByte(12)..write(obj.isInterState)
      ..writeByte(13)..write(obj.isReverseCharge)
      ..writeByte(14)..write(obj.placeOfSupply)
      ..writeByte(15)..write(obj.items)
      ..writeByte(16)..write(obj.subTotal)
      ..writeByte(17)..write(obj.totalDiscount)
      ..writeByte(18)..write(obj.taxableAmount)
      ..writeByte(19)..write(obj.cgst)
      ..writeByte(20)..write(obj.sgst)
      ..writeByte(21)..write(obj.igst)
      ..writeByte(22)..write(obj.totalTax)
      ..writeByte(23)..write(obj.shippingCharges)
      ..writeByte(24)..write(obj.grandTotal)
      ..writeByte(25)..write(obj.roundOff)
      ..writeByte(26)..write(obj.finalTotal)
      ..writeByte(27)..write(obj.paymentStatus)
      ..writeByte(28)..write(obj.amountPaid)
      ..writeByte(29)..write(obj.notes)
      ..writeByte(30)..write(obj.termsAndConditions)
      ..writeByte(31)..write(obj.templateId)
      ..writeByte(32)..write(obj.createdAt)
      ..writeByte(33)..write(obj.pdfPath);
  }
}
