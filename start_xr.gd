extends Node


# Current XR interface
var _xr_interface : XRInterface

# Is a WebXR is_session_supported query running
var _webxr_session_query : bool = false

# XR active flag
var _xr_active : bool = false


# Initialize XR when ready
func _ready() -> void:
	if !Engine.is_editor_hint():
		_initialize()


# Initialize the XR interface
func _initialize() -> void:
	# Check for OpenXR interface
	_xr_interface = XRServer.find_interface('OpenXR')
	if _xr_interface:
		_initialize_openxr()
		return

	# Check for WebXR interface
	_xr_interface = XRServer.find_interface('WebXR')
	if _xr_interface:
		_initialize_webxr()
		return

	# No XR interface
	print("No XR interface detected")


# Initialize OpenXR interface
func _initialize_openxr() -> void:
	print("OpenXR: Initializing")

	# Initialize the OpenXR interface
	if not _xr_interface.is_initialized():
		print("OpenXR: Initializing interface")
		if not _xr_interface.initialize():
			push_error("OpenXR: Failed to initialize")
			return

	# Connect the OpenXR events
	_xr_interface.connect("session_begun", _on_openxr_session_begun)
	_xr_interface.connect("session_visible", _on_openxr_visible_state)
	_xr_interface.connect("session_focussed", _on_openxr_focused_state)

	# Disable vsync and switch to XR mode
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	get_viewport().use_xr = true


# Initialize WebXR interface
func _initialize_webxr() -> void:
	print("WebXR: Initializing")

	# Connect the WebXR events
	_xr_interface.connect("session_supported", _on_webxr_session_supported)
	_xr_interface.connect("session_started", _on_webxr_session_started)
	_xr_interface.connect("session_ended", _on_webxr_session_ended)
	_xr_interface.connect("session_failed", _on_webxr_session_failed)

	# Skip if already active
	if get_viewport().use_xr:
		return

	# Query for WebXR immersive session - delivered to _webxr_session_supported
	_webxr_session_query = true
	_xr_interface.is_session_supported('immersive-vr')


# Handle OpenXR session ready
func _on_openxr_session_begun() -> void:
	print("OpenXR: Session begun")


# Handle OpenXR visible state
func _on_openxr_visible_state() -> void:
	# Report the XR ending
	if _xr_active:
		print("OpenXR: XR ended (visible_state)")
		_xr_active = false


# Handle OpenXR focused state
func _on_openxr_focused_state() -> void:
	# Report the XR starting
	if not _xr_active:
		print("OpenXR: XR started (focused_state)")
		_xr_active = true


# Handle WebXR session supported check
func _on_webxr_session_supported(session_mode: String, supported: bool) -> void:
	# Skip if not running session-query
	if not _webxr_session_query:
		return

	# Clear the query flag
	_webxr_session_query = false

	# Report if not supported
	if not supported:
		OS.alert("Your web browser doesn't support " + session_mode + ". Sorry!")
		return

	# WebXR supported - show canvas on web browser to enter WebVR
	$EnterWebXR.visible = true


# Handle the Enter VR button on the WebXR browser
func _on_enter_webxr_button_pressed() -> void:
	# Configure the WebXR interface
	_xr_interface.session_mode = 'immersive-vr'
	_xr_interface.requested_reference_space_types = 'bounded-floor, local-floor, local'
	_xr_interface.required_features = 'local-floor'
	_xr_interface.optional_features = 'bounded-floor'

	# Add hand-tracking if enabled in the project settings
	if ProjectSettings.get_setting_with_override("xr/openxr/extensions/hand_tracking"):
		_xr_interface.optional_features += ", hand-tracking"

	# Initialize the interface. This should trigger either _on_webxr_session_started
	# or _on_webxr_session_failed
	if not _xr_interface.initialize():
		OS.alert("Failed to initialize WebXR")


# Called when the WebXR session has started successfully
func _on_webxr_session_started() -> void:
	print("WebXR: Session started")

	# Hide the canvas and switch the viewport to XR
	$EnterWebXR.visible = false
	get_viewport().use_xr = true

	# Report the XR starting
	_xr_active = true


# Called when the user ends the immersive VR session
func _on_webxr_session_ended() -> void:
	print("WebXR: Session ended")

	# Show the canvas and switch the viewport to non-XR
	$EnterWebXR.visible = true
	get_viewport().use_xr = false

	# Report the XR ending
	_xr_active = false


# Called when the immersive VR session fails to start
func _on_webxr_session_failed(message: String) -> void:
	OS.alert("Unable to enter VR: " + message)
	$EnterWebXR.visible = true
