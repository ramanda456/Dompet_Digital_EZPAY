plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
}

android {
    namespace = "com.example.aplikasi_ezpay_1"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11

        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.aplikasi_ezpay_1"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        multiDexEnabled = true
    }
    buildTypes {
    release {
        signingConfig = signingConfigs.getByName("debug")

        isMinifyEnabled = false
        isShrinkResources = false
        }
    }
    
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BoM (mengatur semua versi Firebase)
    implementation(platform("com.google.firebase:firebase-bom:34.12.0"))

    // Firebase Analytics (opsional tapi disarankan)
    implementation("com.google.firebase:firebase-analytics")

    // WAJIB untuk Crashlytics
    implementation("com.google.firebase:firebase-crashlytics")

    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}