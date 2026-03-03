# flutter_local_notifications uses Gson with TypeToken to serialize/deserialize
# scheduled notifications. R8 strips generic type parameters by default,
# which causes "Missing type parameter" at runtime. Keep all plugin classes
# and Gson TypeToken hierarchy to prevent this.
-keep class com.dexterous.** { *; }
-keepattributes Signature
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken