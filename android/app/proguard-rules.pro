# Project-specific R8 rules for the release build.
#
# Flutter already supplies:
#   - proguard-android-optimize.txt
#   - flutter_proguard_rules.pro (keeps FlutterPlugin implementations)
# and every Android plugin contributes its own consumer rules (Firebase,
# Crashlytics, local notifications, etc.).
#
# Add a `-keep` rule here only if a class is reached by name at runtime
# (reflection, JNI, or a JavaScript interface). Do not blanket-keep
# packages: that defeats shrinking for the whole app.
