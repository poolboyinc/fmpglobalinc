plugins {
    id("com.android.application")
    
    id("com.google.gms.google-services")
    
    id("kotlin-android")
    
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.fmpglobalinc"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {  
        applicationId = "com.example.fmpglobalinc"
        minSdk = 23
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
