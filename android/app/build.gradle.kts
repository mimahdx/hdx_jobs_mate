plugins {
    id("com.android.application")
    kotlin("android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.hdx.jobs_mate"
    compileSdk = 34
    ndkVersion = "25.1.8937393"

    defaultConfig {
        applicationId = "com.hdx.savings_tracker"
        minSdk = 24
        targetSdk = 34
        versionCode = 1
        versionName = "1.0"
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    sourceSets {
        getByName("main").java.srcDirs("src/main/kotlin")
    }

    flavorDimensions += "flavor-type"
    productFlavors {
        create("dev") {
            dimension = "flavor-type"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
        }
        create("staging") {
            dimension = "flavor-type"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
        }
        create("prod") {
            dimension = "flavor-type"
            versionNameSuffix = "-prod"
        }
        create("hotfix") {
            dimension = "flavor-type"
            applicationIdSuffix = ".hotfix"
            versionNameSuffix = "-hotfix"
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = true
            proguardFiles(getDefaultProguardFile("proguard-android.txt"), "proguard-rules.pro")
        }
        debug {
            isMinifyEnabled = false
        }
    }

    lint {
        disable += "InvalidPackage"
    }
}

afterEvaluate {
    android.applicationVariants.all {
        val variant = this
        val variantName = variant.name
        tasks.named("assemble${variantName.capitalize()}") {
            doLast {
                copy {
                    val flavorName = variant.flavorName
                    val buildType = variant.buildType.name
                    from("build/outputs/apk/${flavorName}/${buildType}/app-${flavorName}-${buildType}.apk")
                    into("../../build/app/outputs/flutter-apk/")
                    rename("app-${flavorName}-${buildType}.apk", "app-${flavorName}-${buildType}.apk")
                }
            }
        }
    }
}