# Godot CI Build Demo

This demo project shows how to build a Godot VR application using GitHub CI build actions.


## Actions Used

The following actions are used within the CI workflow:
- [actions/checkout](https://github.com/actions/checkout)
- [actions/upload-artifact](https://github.com/actions/upload-artifact)
- [actions/setup-java](https://github.com/actions/setup-java)
- [android-actions/setup-android](https://github.com/android-actions/setup-android)
- [chickensoft-games/setup-godot](https://github.com/chickensoft-games/setup-godot)
- [remarkablegames/setup-butler](https://github.com/remarkablegames/setup-butler)


## Video

For further instructions, please watch the [video](https://youtu.be/PjDDakeG4J0).


## Notes

This now uses Github matrix-builds and:

- Installs the Godot OpenXR Vendors plugin
- Installs the Android SDK (for Android targets)
- Exports for:
  - Windows
  - Linux
  - Android Quest
  - Android Pico
  - Android Magic Leap
  - Android Vive
  - Android Lynx
  - WebXR
- Publish Artifacts (if making Release)
- Push to itch.io (if making Release)

Additional exports may be added by appending to the matrix rules.
