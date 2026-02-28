## ProGuard Rules for GST Invoice Maker

# Flutter
-keep class io.flutter.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# Google Mobile Ads (AdMob)
-keep class com.google.android.gms.** { *; }
-keep class com.google.ads.** { *; }
-dontwarn com.google.android.gms.**

# Hive
-keep class com.hivedb.** { *; }
-keep @interface hive.annotations.** { *; }

# Google UMP
-keep class com.google.android.ump.** { *; }

# Keep app classes
-keep class com.yourcompany.gst_invoice_maker.** { *; }

# Remove logging in release
-assumenosideeffects class android.util.Log {
    public static *** d(...);
    public static *** v(...);
    public static *** i(...);
}
