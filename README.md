# Godot CI Build Demo

This demo project shows how to build a Godot VR application using GitHub CI build actions.


## Actions Used

The following actions are used within the CI workflow:
- [actions/checkout](https://github.com/actions/checkout)
- [actions/upload-artifact](https://github.com/actions/upload-artifact)
- [actions/setup-java](https://github.com/actions/setup-java)
- [android-actions/setup-android](https://github.com/android-actions/setup-android)
- [chickensoft-games/setup-godot](https://github.com/chickensoft-games/setup-godot)


## Video

For further instructions, please watch the [video](https://youtu.be/PjDDakeG4J0).


## Notes

This now uses Github matrix-builds and:

- Installs the Godot OpenXR Vendors plugin
- Installs the Android SDK (for Android targets)
- Exports for:
  - Windows
  - Linux
  - Meta Quest
  - Pico
  - Magic Leap
- Publish Artifacts (if making Github Release)

Additional exports may be added by appending to the matrix rules.
