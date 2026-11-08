#!/usr/bin/env bash
# After `npx cap add android`: our icon, the version number of this build, the fixed signing key
# (so a new APK installs over the old one and the phone keeps its data).
set -euo pipefail
RES=android/app/src/main/res
rm -rf "$RES/mipmap-anydpi-v26" "$RES"/drawable-land-* "$RES"/drawable-port-*
cp -r android-res/* "$RES/"
N="${GITHUB_RUN_NUMBER:-1}"
sed -i -E "s/versionCode [0-9]+/versionCode $N/; s/versionName \"[^\"]*\"/versionName \"1.$N\"/" android/app/build.gradle
cat >> android/app/build.gradle <<'GRADLE'

android {
    signingConfigs {
        debug {
            storeFile file("../../ci/debug.keystore")
            storePassword "android"
            keyAlias "androiddebugkey"
            keyPassword "android"
        }
    }
}
GRADLE
grep -E "versionCode|versionName" android/app/build.gradle
