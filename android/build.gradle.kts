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
}
subprojects {
    project.evaluationDependsOn(":app")
}

fun forcePluginCompileSdk(project: org.gradle.api.Project) {
    // Older plugins (e.g. flutter_keyboard_visibility) pin an outdated compileSdkVersion.
    // Force all plugin library modules to compile against the app's compileSdk (flutter.compileSdkVersion = 36)
    // so their androidx dependencies (which require API 34+) don't fail AAR metadata checks.
    val androidExtension = project.extensions.findByName("android")
    if (androidExtension is com.android.build.gradle.LibraryExtension) {
        androidExtension.compileSdk = 36
    }
}

subprojects {
    val project = this
    if (project.state.executed) {
        forcePluginCompileSdk(project)
    } else {
        project.afterEvaluate { forcePluginCompileSdk(project) }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
