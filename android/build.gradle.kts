allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)

    // Force all plugin subprojects to use Java 11+ so the compiler
    // does not emit "source/target value 8 is obsolete" warnings.
    afterEvaluate {
        if (extensions.findByName("android") != null) {
            extensions.configure<com.android.build.gradle.BaseExtension> {
                compileOptions {
                    sourceCompatibility = JavaVersion.VERSION_17
                    targetCompatibility = JavaVersion.VERSION_17
                }
            }
        }
        tasks.withType<org.jetbrains.kotlin.gradle.tasks.KotlinCompile>().configureEach {
            compilerOptions {
                jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
            }
        }
    }
}
subprojects {
    project.evaluationDependsOn(":app")
}

// The home_widget plugin declares androidx.glance:glance-appwidget:1.+, a
// dynamic range. It started to resolve to 1.3.0-alpha02, which needs
// compileSdk 37 and AGP 9.1 and broke every Android build. Pin the last stable
// release that builds with the current toolchain (compileSdk 36, AGP 8.11).
subprojects {
    configurations.all {
        resolutionStrategy {
            force(
                "androidx.glance:glance:1.1.1",
                "androidx.glance:glance-appwidget:1.1.1",
            )
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
