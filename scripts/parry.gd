extends Area2D

@export var duration_msec: int
@export var cooldown_msec: int

var last_parry_msec = 0

func _ready() -> void:
	deactivate()

func _process(delta: float) -> void:
	var elapsed_msec = Time.get_ticks_msec()
	var since_last_msec = elapsed_msec - last_parry_msec
	
	if monitoring:
		if since_last_msec >= duration_msec:
			deactivate()
	elif since_last_msec >= cooldown_msec and Input.is_action_just_pressed("parry"):
		last_parry_msec = elapsed_msec
		activate()

func activate() -> void:
	monitoring = true
	print("Parry on")
	
func deactivate() -> void:
	monitoring = false
	print("Parry off")
