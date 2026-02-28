# 📱 GST Invoice Maker - Complete Flutter App

> Professional GST-compliant offline invoice maker for Indian businesses

---

## 🚀 QUICK START

### Prerequisites
- Flutter 3.x (stable)
- Android Studio (latest)
- JDK 17
- Android device / emulator (API 24+)

### Setup
```bash
cd gst_invoice_app
flutter pub get
flutter run
```

### Build
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Release App Bundle (for Play Store)
flutter build appbundle --release
```

### Enable ProGuard for release
In `android/app/build.gradle`:
```gradle
buildTypes {
    release {
        minifyEnabled true
        shrinkResources true
        proguardFiles getDefaultProguardFile('proguard-android-optimize.txt'),
                      'proguard-rules.pro'
    }
}
```

---

## 📁 PROJECT STRUCTURE

```
lib/
├── main.dart                          # App entry point
├── core/
│   ├── constants/app_constants.dart   # Ad IDs, GST rates, states
│   └── theme/app_theme.dart           # Blue corporate theme
├── data/
│   ├── models/hive/                   # Hive data models + adapters
│   │   ├── company_model.dart/.g.dart
│   │   ├── customer_model.dart/.g.dart
│   │   ├── product_model.dart/.g.dart
│   │   ├── invoice_model.dart/.g.dart
│   │   └── invoice_item_model.dart/.g.dart
│   └── repositories/                  # Data access layer
│       ├── company_repository.dart
│       ├── customer_repository.dart
│       ├── product_repository.dart
│       └── invoice_repository.dart
├── services/
│   ├── gst_calculator_service.dart    # Core GST engine
│   ├── pdf_generator_service.dart     # PDF generation (4 templates)
│   ├── admob_service.dart             # AdMob banner + interstitial
│   ├── consent_manager.dart           # Google UMP GDPR consent
│   └── number_to_words_service.dart   # Amount in words (Indian)
└── presentation/
    ├── screens/
    │   ├── dashboard/                 # Dashboard with charts + banner ad
    │   ├── invoice/                   # Create, list, preview invoices
    │   ├── customer/                  # Customer CRUD
    │   ├── product/                   # Product/Service CRUD
    │   ├── company/                   # Business profile setup
    │   ├── settings/                  # Settings + Privacy Policy + Terms
    │   └── templates/                 # Template selector with previews
    └── widgets/
        └── invoice_item_row_widget.dart
```

---

## 🧾 GST ENGINE

Location: `lib/services/gst_calculator_service.dart`

```dart
// Intrastate
if (sellerState == buyerState) {
  cgst = gstAmount / 2
  sgst = gstAmount / 2
} else {
  igst = gstAmount  // Interstate
}

// Inclusive pricing
taxableAmount = priceIncludingGST / (1 + gstRate/100)

// Supported rates: 0%, 5%, 12%, 18%, 28%
```

**Features:**
- Auto CGST/SGST vs IGST based on state comparison
- Inclusive / Exclusive pricing
- Reverse charge support
- HSN/SAC tracking
- Auto round-off
- Amount in Indian words (Crore/Lakh)
- Full tax breakdown JSON per rate

---

## 📢 ADMOB SETUP

### Replace Ad IDs before release

In `lib/core/constants/app_constants.dart`:
```dart
static const String prodBannerAdId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
static const String prodInterstitialAdId = 'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';
```

In `android/app/src/main/AndroidManifest.xml`:
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="ca-app-pub-YOUR_ACTUAL_APP_ID" />
```

### Ad Placement Policy (Compliant)
| Screen | Banner | Interstitial |
|--------|--------|-------------|
| Dashboard | ✅ Bottom only | ❌ |
| Invoice Preview | ❌ | ❌ |
| PDF View | ❌ | ❌ |
| After Invoice Saved | ❌ | ✅ Max once/session |
| Near action buttons | ❌ | ❌ |

---

## 🎨 TEMPLATES

| ID | Name | Description |
|----|------|-------------|
| 1 | Blue Corporate VIP | Dark blue header, gold VIP badge, rounded border |
| 2 | Modern Minimal | Clean white with blue accent line |
| 3 | Bold Business | Dark header with orange accents |
| 4 | Clean Corporate | Subtle blue, professional |

---

## 🔑 APP SIGNING

1. Generate keystore:
```bash
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key
```

2. Create `android/key.properties`:
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=key
storeFile=/path/to/key.jks
```

3. In `android/app/build.gradle`, add:
```gradle
def keystoreProperties = new Properties()
keystoreProperties.load(new FileInputStream(rootProject.file('key.properties')))

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile file(keystoreProperties['storeFile'])
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
        }
    }
}
```

---

## 🏪 GOOGLE PLAY STORE LISTING

### App Title (ASO Optimized)
```
GST Invoice Maker - Billing App
```

### Short Description (80 chars)
```
Create GST invoices offline. PDF, WhatsApp share. India compliant. Free.
```

### Full Description
```
📄 GST Invoice Maker – Professional GST-compliant Invoice Generator for Indian Businesses

Create professional GST invoices instantly, completely offline. Perfect for small businesses, freelancers, traders, and service providers in India.

✅ KEY FEATURES:

🧾 GST INVOICE CREATION
• Auto CGST/SGST for intrastate, IGST for interstate
• Support for 0%, 5%, 12%, 18%, 28% GST rates
• HSN/SAC code support
• Inclusive & exclusive pricing
• Reverse charge mechanism
• Item-level and total discounts
• Shipping charges
• Auto round-off

📊 BUSINESS MANAGEMENT
• Company profile with logo & signature
• Customer database with GSTIN
• Product/Service catalogue
• Invoice history per customer
• Payment status tracking (Paid/Unpaid/Partial)

📑 PDF GENERATION
• A4 GST-compliant PDF invoices
• Download, Print & Share via WhatsApp
• Amount in words (Indian format)
• Bank details on invoice
• Terms & Conditions

🎨 PROFESSIONAL TEMPLATES
• Blue Corporate VIP (with optional VIP badge)
• Modern Minimal
• Bold Business
• Clean Corporate

📈 DASHBOARD
• Total sales & GST collected
• Monthly sales chart
• Pending payments
• Recent invoices

🔒 100% OFFLINE & PRIVATE
• All data stored locally on your device
• No login required
• No internet needed (except for ads)
• Your data never leaves your device

Perfect for: Retailers, Wholesalers, Manufacturers, Service Providers, Freelancers, Consultants

Keywords: GST invoice, billing app, invoice generator, tax invoice India, CGST SGST IGST, HSN code invoice, PDF invoice, small business invoice
```

### Category: Business

### Keywords
```
gst invoice, billing app, invoice maker, tax invoice, cgst sgst, igst, hsn sac, pdf invoice, 
offline invoice, india gst, gst calculator, invoice generator, small business, freelance invoice
```

---

## 🛡️ DATA SAFETY (Play Store)

**Does your app collect or share user data?**
Answer: YES (for advertising purposes only)

| Data Type | Collected | Shared | Required |
|-----------|-----------|--------|----------|
| Device identifiers | Yes (AdMob) | Yes (Google) | No (can decline) |
| Business data | No | No | - |
| Customer data | No | No | - |
| Financial data | No | No | - |

**Is data encrypted in transit?** YES
**Can users request data deletion?** YES (uninstall app, all local data deleted)

---

## 📊 CONTENT RATING

Answers for Play Store rating questionnaire:
- Violence: None
- Sexual content: None
- Profanity: None
- Controlled substances: None
- Target audience: Adults (18+)
- **Expected rating: Everyone / 3+**

---

## 🛠️ TROUBLESHOOTING

**Build errors:**
```bash
flutter clean
flutter pub get
cd android && ./gradlew clean
cd ..
flutter build apk
```

**Hive adapter errors:**
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

**AdMob not loading:**
- Ensure internet permission in manifest
- Check App ID in manifest
- Verify consent was obtained via UMP

---

## 📋 CHECKLIST BEFORE RELEASE

- [ ] Replace test Ad IDs with production IDs
- [ ] Replace AdMob App ID in AndroidManifest.xml
- [ ] Generate & configure release keystore
- [ ] Enable ProGuard in build.gradle
- [ ] Test on multiple devices (API 24+, 28+, 33+)
- [ ] Test offline functionality (airplane mode)
- [ ] Test UMP consent flow
- [ ] Verify GST calculations with test cases
- [ ] Test PDF generation and sharing
- [ ] Update Privacy Policy with actual contact info
- [ ] Screenshot all 4 templates for Play Store

---

## 📞 SUPPORT

For questions: Create an issue in the repository.

**Disclaimer:** GST calculations are for guidance only. Always verify with a qualified CA.
