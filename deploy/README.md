# Jenkins Pipeline for Flutter Application

This Jenkinsfile is used to set up a Continuous Integration (CI) pipeline for a Flutter application.

## Pipeline Stages

The pipeline consists of the following stages:

1. **Checkout**: This stage checks out the source code from your SCM (Source Control Management).

2. **Install Android SDK**: This stage downloads and installs the Android SDK command line tools.

3. **Install Flutter**: This stage downloads and installs the Flutter SDK.

4. **Install Dependencies**: This stage installs the Flutter dependencies.

5. **Build APK**: This stage builds the Android APK.

6. **Archive APK**: This stage archives the Android APK.

## Environment Variables

The pipeline uses the following environment variables:

- `FLUTTER_CHANNEL`: The Flutter channel to use. You can change this to 'beta' or 'dev' based on your Flutter channel preference.
- `FLUTTER_VERSION`: The version of Flutter to use. Update to the latest Flutter version or to the version you want to use.
- `ANDROID_CMD_TOOLS_URL`: The URL to download the Android SDK command line tools from. Update to the latest Android SDK URL.
- `ENVIRONMENT`: The environment to build the application for. This is used to set the application's environment variable. Update to the environment you want to build the application for [e.g. QA, DEV, PROD, etc.]
- `ARCHIVED_NAME`: The name of the archived APK. Update to the name you want to use for the archived APK.

## Tools

The pipeline uses the following tools:

- OpenJDK version 17.0.1

## Usage

To use this Jenkinsfile, place it in the root directory of your Flutter project. Then, in Jenkins, create a new Pipeline job and point it to the Jenkinsfile.

Please adjust this Jenkinsfile according to your needs.
