plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.last_telemedicine"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    // --- ИСПРАВЛЕНИЕ 1 ---
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11

        // Эта строка включает "desugaring"
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.last_telemedicine"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
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

dependencies {
    // --- ИСПРАВЛЕНИЕ 2 ---
    // (Используйте вашу версию Kotlin, 2.1.10 - это пример, если он не работает, используйте "1.8.20" или тот, что в корневом файле)
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk7:2.1.10")

    // Эта зависимость добавляет библиотеку "desugaring"
        coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")

    // ... (здесь могут быть другие ваши зависимости, например, для Firebase)
}