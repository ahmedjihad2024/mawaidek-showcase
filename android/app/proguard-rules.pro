# Mawaeidk — release-build ProGuard / R8 rules.
#
# minifyEnabled and shrinkResources are both ON for release. Without
# these rules, R8 happily strips classes that are loaded reflectively
# at runtime (Firebase, Sentry, Sadad SDK, etc.) and the app crashes
# silently the moment the user reaches that code path.
#
# Test any new release build BEFORE shipping by installing the AAB
# locally with `bundletool` and walking the booking → payment flow.

# ---- Flutter / Dart ----
# Flutter wires plugins via reflection; keep its bridge fully intact.
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.embedding.** { *; }
-dontwarn io.flutter.embedding.**

# ---- Firebase ----
# Firebase SDK reads service classes via reflection at startup.
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes EnclosingMethod
-keepattributes InnerClasses
-dontwarn com.google.firebase.**
-dontwarn com.google.android.gms.**
-dontwarn com.google.j2objc.annotations.**

# Firebase Messaging — service registration
-keep class * extends com.google.firebase.messaging.FirebaseMessagingService { *; }

# ---- Sentry ----
# Sentry's native crash handler + Hub access methods are referenced
# from generated code at runtime.
-keep class io.sentry.** { *; }
-keep class io.sentry.android.** { *; }
-dontwarn io.sentry.**
-keep public class * extends java.lang.Exception
-keepattributes SourceFile,LineNumberTable

# ---- Sadad SDK ----
# The sadad_qa_payments Flutter plugin bridges to a native Android
# layer that uses reflection on its model classes. Keeping the whole
# package is the safe move.
-keep class com.sadad.** { *; }
-keep class com.sadadqa.** { *; }
-dontwarn com.sadad.**
-dontwarn com.sadadqa.**

# ---- Kotlin coroutines / JSON ----
-keep class kotlin.coroutines.Continuation { *; }
-keep class kotlin.Metadata { *; }
-keepclassmembers class kotlinx.serialization.** { *; }
-dontwarn kotlinx.coroutines.**
-dontwarn kotlinx.serialization.**

# ---- WebView (Sadad payment screen) ----
-keep class android.webkit.** { *; }
-keepclassmembers class * extends android.webkit.WebView {
    public *;
}
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# ---- Image / cache plugins ----
-keep class com.bumptech.glide.** { *; }
-keep class id.zelory.compressor.** { *; }
-dontwarn com.bumptech.glide.**

# ---- Keep enums + parcelable boilerplate ----
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-keepclassmembers class * implements android.os.Parcelable {
    public static final android.os.Parcelable$Creator CREATOR;
}

# ---- App classes ----
# Don't strip anything in our own package even if R8 thinks it is unused.
# Cheap insurance against missed reflection paths.
-keep class com.azsystem.** { *; }
-keep class com.example.mawadk.** { *; }
