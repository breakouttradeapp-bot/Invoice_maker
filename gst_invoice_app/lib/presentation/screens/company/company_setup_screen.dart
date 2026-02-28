import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/models/hive/company_model.dart';
import '../../../data/repositories/company_repository.dart';
import '../dashboard/dashboard_screen.dart';

class CompanySetupScreen extends StatefulWidget {
  final bool isFirstTime;
  const CompanySetupScreen({super.key, this.isFirstTime = false});

  @override
  State<CompanySetupScreen> createState() => _CompanySetupScreenState();
}

class _CompanySetupScreenState extends State<CompanySetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _repo = CompanyRepository();
  final _picker = ImagePicker();

  late TextEditingController _name;
  late TextEditingController _gstin;
  late TextEditingController _pan;
  late TextEditingController _address;
  late TextEditingController _city;
  late TextEditingController _pincode;
  late TextEditingController _phone;
  late TextEditingController _email;
  late TextEditingController _website;
  late TextEditingController _bankName;
  late TextEditingController _accountNumber;
  late TextEditingController _ifsc;
  late TextEditingController _accountHolder;
  late TextEditingController _upiId;
  late TextEditingController _prefix;
  late TextEditingController _terms;

  String _state = AppConstants.indianStates.first;
  String? _logoPath;
  String? _signaturePath;

  @override
  void initState() {
    super.initState();
    final c = _repo.getCompany();
    _name = TextEditingController(text: c?.name ?? '');
    _gstin = TextEditingController(text: c?.gstin ?? '');
    _pan = TextEditingController(text: c?.pan ?? '');
    _address = TextEditingController(text: c?.address ?? '');
    _city = TextEditingController(text: c?.city ?? '');
    _pincode = TextEditingController(text: c?.pincode ?? '');
    _phone = TextEditingController(text: c?.phone ?? '');
    _email = TextEditingController(text: c?.email ?? '');
    _website = TextEditingController(text: c?.website ?? '');
    _bankName = TextEditingController(text: c?.bankName ?? '');
    _accountNumber =
        TextEditingController(text: c?.accountNumber ?? '');
    _ifsc = TextEditingController(text: c?.ifscCode ?? '');
    _accountHolder =
        TextEditingController(text: c?.accountHolder ?? '');
    _upiId = TextEditingController(text: c?.upiId ?? '');
    _prefix = TextEditingController(text: c?.invoicePrefix ?? 'INV');
    _terms = TextEditingController(text: c?.termsAndConditions ?? '');
    _state = c?.state ?? AppConstants.indianStates.first;
    _logoPath = c?.logoPath;
    _signaturePath = c?.signaturePath;
  }

  Future<void> _pickImage(bool isLogo) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        if (isLogo) _logoPath = picked.path;
        else _signaturePath = picked.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isFirstTime
            ? 'Setup Your Business'
            : 'Business Profile'),
        automaticallyImplyLeading: !widget.isFirstTime,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (widget.isFirstTime) ...[
              const Icon(Icons.business,
                  size: 60, color: AppTheme.primaryBlue),
              const SizedBox(height: 8),
              const Text('Let\'s set up your business profile',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center),
              const SizedBox(height: 20),
            ],

            _section('Business Information', [
              // Logo upload
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _pickImage(true),
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.dividerColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _logoPath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(File(_logoPath!),
                                  fit: BoxFit.cover))
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_a_photo,
                                    color: AppTheme.textLight),
                                Text('Logo', style: TextStyle(fontSize: 11)),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                      child: Text(
                          'Tap to upload business logo (appears on invoices)',
                          style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textMedium))),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Business Name *'),
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _gstin,
                decoration: const InputDecoration(
                    labelText: 'GSTIN *',
                    hintText: '22AAAAA0000A1Z5'),
                textCapitalization: TextCapitalization.characters,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _pan,
                decoration: const InputDecoration(labelText: 'PAN'),
                textCapitalization: TextCapitalization.characters,
              ),
            ]),

            const SizedBox(height: 16),

            _section('Contact & Address', [
              TextFormField(
                controller: _address,
                decoration: const InputDecoration(labelText: 'Address *'),
                maxLines: 2,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                      child: TextFormField(
                    controller: _city,
                    decoration: const InputDecoration(labelText: 'City'),
                  )),
                  const SizedBox(width: 12),
                  Expanded(
                      child: TextFormField(
                    controller: _pincode,
                    decoration:
                        const InputDecoration(labelText: 'Pincode'),
                    keyboardType: TextInputType.number,
                  )),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _state,
                decoration: const InputDecoration(labelText: 'State *'),
                items: AppConstants.indianStates
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (v) => setState(() => _state = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(labelText: 'Phone *'),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _website,
                decoration: const InputDecoration(labelText: 'Website'),
              ),
            ]),

            const SizedBox(height: 16),

            _section('Bank Details', [
              TextFormField(
                  controller: _bankName,
                  decoration:
                      const InputDecoration(labelText: 'Bank Name')),
              const SizedBox(height: 12),
              TextFormField(
                  controller: _accountNumber,
                  decoration:
                      const InputDecoration(labelText: 'Account Number')),
              const SizedBox(height: 12),
              TextFormField(
                  controller: _ifsc,
                  decoration: const InputDecoration(
                      labelText: 'IFSC Code'),
                  textCapitalization: TextCapitalization.characters),
              const SizedBox(height: 12),
              TextFormField(
                  controller: _accountHolder,
                  decoration:
                      const InputDecoration(labelText: 'Account Holder Name')),
              const SizedBox(height: 12),
              TextFormField(
                  controller: _upiId,
                  decoration: const InputDecoration(labelText: 'UPI ID')),
            ]),

            const SizedBox(height: 16),

            _section('Invoice Settings', [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _prefix,
                      decoration: const InputDecoration(
                          labelText: 'Invoice Prefix',
                          hintText: 'INV'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                        'e.g. INV-0001, ABC-0001',
                        style: TextStyle(
                            fontSize: 11, color: AppTheme.textMedium)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Signature upload
              Row(
                children: [
                  GestureDetector(
                    onTap: () => _pickImage(false),
                    child: Container(
                      width: 120,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.dividerColor),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: _signaturePath != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.file(
                                  File(_signaturePath!),
                                  fit: BoxFit.contain))
                          : const Center(
                              child: Text('Upload Signature',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: AppTheme.textLight),
                                  textAlign: TextAlign.center)),
                    ),
                  ),
                ],
              ),
            ]),

            const SizedBox(height: 16),

            _section('Terms & Conditions', [
              TextFormField(
                controller: _terms,
                maxLines: 5,
                decoration:
                    const InputDecoration(border: OutlineInputBorder()),
              ),
            ]),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: _save,
              style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50)),
              child: Text(
                  widget.isFirstTime ? 'Get Started' : 'Save Changes'),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryBlue)),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final company = CompanyModel(
      name: _name.text.trim(),
      gstin: _gstin.text.trim(),
      pan: _pan.text.trim(),
      address: _address.text.trim(),
      city: _city.text.trim(),
      state: _state,
      pincode: _pincode.text.trim(),
      phone: _phone.text.trim(),
      email: _email.text.trim(),
      website: _website.text.trim(),
      logoPath: _logoPath,
      bankName: _bankName.text.trim(),
      accountNumber: _accountNumber.text.trim(),
      ifscCode: _ifsc.text.trim(),
      accountHolder: _accountHolder.text.trim(),
      upiId: _upiId.text.trim(),
      signaturePath: _signaturePath,
      invoicePrefix: _prefix.text.trim().isEmpty ? 'INV' : _prefix.text.trim(),
      termsAndConditions: _terms.text.trim(),
    );

    // Preserve counter if editing
    final existing = _repo.getCompany();
    if (existing != null) {
      company.invoiceCounter = existing.invoiceCounter;
    }

    await _repo.saveCompany(company);

    if (mounted) {
      if (widget.isFirstTime) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (_) => const DashboardScreen()));
      } else {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Business profile saved!')));
      }
    }
  }
}
