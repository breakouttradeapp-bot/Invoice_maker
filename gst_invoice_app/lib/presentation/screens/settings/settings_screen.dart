// settings_screen.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../company/company_setup_screen.dart';
import '../templates/template_selector_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.business, color: AppTheme.primaryBlue),
            title: const Text('Business Profile'),
            subtitle: const Text('Edit company details, logo, bank info'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => const CompanySetupScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.design_services, color: AppTheme.primaryBlue),
            title: const Text('Invoice Templates'),
            subtitle: const Text('Choose invoice design'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(
                    builder: (_) => const TemplateSelectorScreen())),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.privacy_tip, color: AppTheme.primaryBlue),
            title: const Text('Privacy Policy'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen())),
          ),
          ListTile(
            leading: const Icon(Icons.description, color: AppTheme.primaryBlue),
            title: const Text('Terms & Conditions'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const TermsScreen())),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('App Version'),
            trailing: Text('1.0.0', style: TextStyle(color: AppTheme.textMedium)),
          ),
        ],
      ),
    );
  }
}

// ── Privacy Policy ────────────────────────────────────────────────────
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privacy Policy')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text('''PRIVACY POLICY

Last updated: January 2025

1. OFFLINE APP
This app works completely offline. All data (company details, customers, products, invoices) is stored locally on your device only. No personal data is transmitted to our servers.

2. DATA WE DO NOT COLLECT
We do not collect, store, or transmit any personal business data, customer information, financial data, or invoice details to any server.

3. ADVERTISING (GOOGLE ADMOB)
This app uses Google AdMob to serve advertisements. AdMob may use device identifiers and other data to serve personalized ads. You will be shown a consent form in compliance with GDPR. If you decline personalized ads, non-personalized ads will be shown.

For more information about Google's data practices, see: https://policies.google.com/privacy

4. PERMISSIONS
- INTERNET: Required only for AdMob advertisements
- READ/WRITE STORAGE: Required to save generated PDF invoices to your device
- CAMERA/GALLERY: Required to upload business logo and signature

5. DATA SECURITY
Your data is stored locally on your device. We recommend keeping your device secure with a screen lock.

6. CHILDREN'S PRIVACY
This app is not directed at children under 13.

7. CONTACT
For privacy concerns, contact: support@gstinvoicemaker.app

8. DISCLAIMER
GST calculations are provided for guidance only. Please verify calculations with a qualified CA. We are not responsible for any discrepancies in tax calculations.

© 2025 GST Invoice Maker. All rights reserved.'''),
      ),
    );
  }
}

// ── Terms Screen ──────────────────────────────────────────────────────
class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms & Conditions')),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text('''TERMS & CONDITIONS

Last updated: January 2025

1. ACCEPTANCE OF TERMS
By using GST Invoice Maker, you agree to these terms.

2. USE OF APP
This app is provided for creating GST-compliant invoices for Indian businesses. You are responsible for the accuracy of all information entered.

3. DISCLAIMER ON GST CALCULATIONS
The GST calculations provided by this app are based on the information you enter. While we strive for accuracy, this app does not constitute tax advice. Users are advised to verify all tax calculations with a qualified Chartered Accountant. The developers are not liable for any tax penalties or discrepancies arising from the use of this app.

4. DATA RESPONSIBILITY
You are responsible for the accuracy and legality of all data entered into the app. The app stores data locally on your device.

5. INTELLECTUAL PROPERTY
The app and its original content are the property of GST Invoice Maker.

6. LIMITATION OF LIABILITY
The app is provided "as is" without warranties. We are not liable for any indirect, incidental, or consequential damages.

7. GOVERNING LAW
These terms are governed by the laws of India.

8. CHANGES TO TERMS
We reserve the right to modify these terms at any time.

Contact: support@gstinvoicemaker.app'''),
      ),
    );
  }
}
