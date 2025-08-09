plugins {
    id("com.android.application")
    id("kotlin-android")
    // ➜ Flutter plugin must follow Android/Kotlin plugins
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.techbusiness.taskpulse.task_pulse"
    compileSdk = flutter.compileSdkVersion       // Flutter’s compileSdk (recommended)
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.techbusiness.taskpulse.task_pulse"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        signingConfig = signingConfigs.getByName("debug")
    }

    compileOptions {
        // ⚠️ Since AGP 8.x **requires JDK 17**, choose JavaVersion.VERSION_17
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17

        // ✳️ Enable API desugaring for java.time, streams, etc.
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
            // Add other optimization settings if needed
        }
    }
}

dependencies {
    // Required for Java 8+/11/17 core library desugaring support
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")

    // Example: Kotlin standard library
    implementation("org.jetbrains.kotlin:kotlin-stdlib:jdk8")
}

flutter {
    source = "../.."
}
