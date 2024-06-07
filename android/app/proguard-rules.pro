# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in /usr/local/share/android-sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.

# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface

# that you want to keep:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Keep Firebase Auth classes
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Keep Facebook SDK classes
-keep class com.facebook.** { *; }

# General ProGuard rules
-dontwarn android.support.v7.**
-keep class * extends android.app.Activity
-keep class * extends android.app.Application
-keep class * extends android.app.Service
-keep class * extends android.content.BroadcastReceiver
-keep class * extends android.content.ContentProvider
-keep class * extends android.view.View
-keepclassmembers class * extends android.app.Activity
-keepclassmembers class * extends android.app.Application
-keepclassmembers class * extends android.app.Service
-keepclassmembers class * extends android.content.BroadcastReceiver
-keepclassmembers class * extends android.content.ContentProvider
-keepclassmembers class * extends android.view.View
