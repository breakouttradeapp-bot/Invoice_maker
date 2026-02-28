// company_model.g.dart
// GENERATED CODE - DO NOT MODIFY BY HAND
// Run: flutter pub run build_runner build

part of 'company_model.dart';

class CompanyModelAdapter extends TypeAdapter<CompanyModel> {
  @override
  final int typeId = 0;

  @override
  CompanyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyModel(
      name: fields[0] as String,
      gstin: fields[1] as String,
      pan: fields[2] as String,
      address: fields[3] as String,
      city: fields[4] as String,
      state: fields[5] as String,
      pincode: fields[6] as String,
      phone: fields[7] as String,
      email: fields[8] as String,
      website: fields[9] as String? ?? '',
      logoPath: fields[10] as String?,
      bankName: fields[11] as String? ?? '',
      accountNumber: fields[12] as String? ?? '',
      ifscCode: fields[13] as String? ?? '',
      accountHolder: fields[14] as String? ?? '',
      upiId: fields[15] as String?,
      upiQrPath: fields[16] as String?,
      signaturePath: fields[17] as String?,
      invoicePrefix: fields[18] as String? ?? 'INV',
      invoiceCounter: fields[19] as int? ?? 1,
      termsAndConditions: fields[20] as String? ?? '',
    );
  }

  @override
  void write(BinaryWriter writer, CompanyModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.gstin)
      ..writeByte(2)
      ..write(obj.pan)
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
      ..write(obj.website)
      ..writeByte(10)
      ..write(obj.logoPath)
      ..writeByte(11)
      ..write(obj.bankName)
      ..writeByte(12)
      ..write(obj.accountNumber)
      ..writeByte(13)
      ..write(obj.ifscCode)
      ..writeByte(14)
      ..write(obj.accountHolder)
      ..writeByte(15)
      ..write(obj.upiId)
      ..writeByte(16)
      ..write(obj.upiQrPath)
      ..writeByte(17)
      ..write(obj.signaturePath)
      ..writeByte(18)
      ..write(obj.invoicePrefix)
      ..writeByte(19)
      ..write(obj.invoiceCounter)
      ..writeByte(20)
      ..write(obj.termsAndConditions);
  }
}
