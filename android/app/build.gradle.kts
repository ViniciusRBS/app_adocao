plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // plugin do Google Services
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.app_teste1"
    compileSdk = 35 // ou a versão que você estiver usando (flutter.compileSdkVersion não funciona aqui)

    defaultConfig {
        applicationId = "com.example.app_teste1"
        minSdk = 21
        targetSdk = 35 // igual ao compileSdk, ou flutter.targetSdkVersion se for possível
        versionCode = 1 // ajuste conforme seu versionamento
        versionName = "1.0" // ajuste conforme seu versionamento
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug") // assinatura debug (para release ajustar depois)
        }
    }
}

flutter {
    source = "../.."
}
