#Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }
-keepclassmembers class j$.util.concurrent.ConcurrentHashMap$TreeBin {
    int X;  # Replace X with the obfuscated name of `lockState`
}
-keepclassmembers class j$.util.concurrent.ConcurrentHashMap {
    int X;  # Replace X with the obfuscated name of `sizeCtl`
    int Y;  # Replace Y with the obfuscated name of `transferIndex`
    long Z; # Replace Z with the obfuscated name of `baseCount`
    int W;  # Replace W with the obfuscated name of `cellsBusy`
}

-keep class org.xmlpull.v1.** { *;}
 -dontwarn org.xmlpull.v1.**