import java.util.Properties
import java.io.FileReader

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.sw_flutter"
    compileSdk = flutter.compileSdkVersion.toInt()
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_1_8
        targetCompatibility = JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_1_8.toString()
    }

    sourceSets {
        getByName("main") {
            java.srcDirs(listOf("src/main/kotlin"))
        }
    }

    defaultConfig {
        applicationId = "com.example.sw_flutter"

        // 👇 [중요] 여기를 21로 변경했습니다! (기존: flutter.minSdkVersion)
        minSdk = flutter.minSdkVersion

        targetSdk = flutter.targetSdkVersion.toInt()
        versionCode = flutter.versionCode.toInt()
        versionName = flutter.versionName

        // 👇 .env 파일 로드 로직 (잘 작성하셨습니다!)
        val envFile = rootProject.file("../.env")
        val envProperties = Properties()
        if (envFile.exists()) {
            envProperties.load(FileReader(envFile))
        }

        manifestPlaceholders["GOOGLE_MAPS_API_KEY"] =
            envProperties.getProperty("GOOGLE_MAPS_API_KEY", "")
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
