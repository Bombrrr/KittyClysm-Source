extends HSlider

func _ready() -> void:
	value = global.cam_sense

func _on_value_changed(value: float) -> void:
	global.cam_sense = value

func _process(delta: float) -> void:
	value = global.cam_sense
