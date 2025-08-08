# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Firebase rules
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Dio rules
-keep class retrofit2.** { *; }
-keepattributes Signature
-keepattributes Exceptions

# SVG rules
-keep class com.caverock.androidsvg.** { *; }

# Image picker rules
-keep class io.flutter.plugins.imagepicker.** { *; }

# File picker rules
-keep class com.mr.flutter.plugin.filepicker.** { *; }

# Local notifications rules
-keep class com.dexterous.** { *; }

# WebSocket rules
-keep class io.flutter.plugins.connectivity.** { *; }

# General optimization
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification

# Remove unused code
-dontwarn **
-ignorewarnings

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep Parcelable implementations
-keepclassmembers class * implements android.os.Parcelable {
    static ** CREATOR;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep enum values
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Keep R classes
-keep class **.R$* {
    public static <fields>;
} 