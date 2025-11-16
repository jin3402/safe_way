// 👈 1. 파일 맨 위에 이 3줄을 추가합니다. (import)
import java.util.Properties
import java.nio.charset.StandardCharsets

// 👈 2. plugins { ... } 블록 *전에* 이 코드를 추가합니다.
// local.properties 파일에서 API 키를 읽어옵니다.
val localProperties = Properties()
val localPropertiesFile = rootProject.file("local.properties")
if (localPropertiesFile.exists()) {
    localPropertiesFile.reader(StandardCharsets.UTF_8).use { reader ->
        localProperties.load(reader)
    }
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sw_flutter"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.sw_flutter"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        // 👈 3. defaultConfig { ... } 블록 안에 이 한 줄을 추가합니다.
        // 읽어온 API 키를 'mapsApiKey'라는 변수에 할당합니다.
        manifestPlaceholders["mapsApiKey"] = localProperties.getProperty("maps.apiKey")
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}